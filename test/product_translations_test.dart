import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:multi_vendor/common/edit_product_info_widget.dart';
import 'package:multi_vendor/core/config/pref_keys.dart';
import 'package:multi_vendor/features/Products/CreateEditProduct/bloc/create_edit_product_bloc.dart';
import 'package:multi_vendor/features/Products/CreateEditProduct/bloc/create_edit_product_event.dart';
import 'package:multi_vendor/features/Products/CreateEditProduct/bloc/create_edit_product_state.dart';
import 'package:multi_vendor/features/Products/CreateEditProduct/data/create_edit_product_api_service.dart';
import 'package:multi_vendor/features/Products/CreateEditProduct/data/create_edit_product_repository.dart';
import 'package:multi_vendor/features/Products/CreateEditProduct/data/product_translations.dart';
import 'package:multi_vendor/features/Products/CreateEditProduct/view/create_edit_product_widget.dart';
import 'package:multi_vendor/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Records every request and answers from [routes] ("METHOD /path/suffix").
class FakeServer {
  FakeServer(this.routes);

  final Map<String, http.Response Function(http.Request)> routes;
  final List<http.Request> requests = [];

  http.Client get client => MockClient((request) async {
        requests.add(request);
        for (final entry in routes.entries) {
          final parts = entry.key.split(' ');
          if (request.method == parts[0] && request.url.path.endsWith(parts[1])) {
            return entry.value(request);
          }
        }
        return http.Response('{"message":"Request does not match any route."}', 404);
      });

  List<String> get calls => [for (final r in requests) '${r.method} ${r.url.path}'];
}

http.Response jsonResponse(Object body) => http.Response.bytes(
    utf8.encode(json.encode(body)), 200,
    headers: {'content-type': 'application/json; charset=utf-8'});

/// GET /V1/vendors/product/FRS-1/translations: the store-wide text is English,
/// and the Arabic store has its own name.
Map<String, dynamic> translationsJson({String? arName = 'فراولة طازجة'}) => {
      'default_values': [
        {'attribute_code': 'name', 'value': 'Fresh Strawberries'},
        {'attribute_code': 'short_description', 'value': null},
        {'attribute_code': 'description', 'value': 'Sweet and red'},
      ],
      'stores': [
        {
          'store_id': 1,
          'store_code': 'ar',
          'store_name': 'عربي',
          'locale': 'ar_SA',
          'values': [
            {'attribute_code': 'name', 'value': arName},
            {'attribute_code': 'short_description', 'value': null},
            {'attribute_code': 'description', 'value': null},
          ],
        },
      ],
    };

final arabicName = [
  {
    'store_code': 'ar',
    'values': [
      {'attribute_code': 'name', 'value': 'فراولة'},
    ],
  },
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({authTokenPrefKey: 'vendor-token'}));

  group('A product\'s text per store view', () {
    test('reads the store-wide text and the Arabic store\'s own', () {
      final translations = ProductTranslations.fromJson(translationsJson());

      expect(translations.defaults['name'], 'Fresh Strawberries');
      expect(translations.attributeCodes, ['name', 'short_description', 'description']);
      final arabic = translations.stores.single;
      expect(arabic.code, 'ar');
      expect(arabic.languageCode, 'ar');
      expect(arabic.values['name'], 'فراولة طازجة');
      expect(arabic.values['description'], isNull);
    });

    test('sends only what the vendor changed; an emptied text goes as null', () {
      final loaded = ProductTranslations.fromJson(translationsJson());

      expect(
          translationChanges(loaded, {
            'ar': {'name': 'فراولة', 'short_description': '', 'description': '  '},
          }),
          arabicName);
      expect(
          translationChanges(loaded, {
            'ar': {'name': ''},
          }),
          [
            {
              'store_code': 'ar',
              'values': [
                {'attribute_code': 'name', 'value': null},
              ],
            },
          ]);
      expect(
          translationChanges(loaded, {
            'ar': {'name': 'فراولة طازجة ', 'description': ''},
          }),
          isEmpty);
    });

    test('a change the reply does not show yet waits for the admin', () {
      expect(
          translationsAwaitingApproval(
              arabicName, ProductTranslations.fromJson(translationsJson())),
          [(store: 'ar', code: 'name')]);
      expect(
          translationsAwaitingApproval(arabicName,
              ProductTranslations.fromJson(translationsJson(arName: 'فراولة'))),
          isEmpty);
    });
  });

  group('Translations API', () {
    test('GET and PUT /V1/vendors/product/:sku/translations with the vendor token',
        () async {
      final server = FakeServer({
        'GET /V1/vendors/product/FRS-1/translations': (_) => jsonResponse(translationsJson()),
        'PUT /V1/vendors/product/FRS-1/translations': (_) =>
            jsonResponse(translationsJson(arName: 'فراولة')),
      });
      final service = CreateEditProductApiService(httpClient: server.client);

      final loaded = await service.getProductTranslations('FRS-1');
      final saved = await service.saveProductTranslations('FRS-1', arabicName);

      expect(loaded.stores.single.values['name'], 'فراولة طازجة');
      expect(saved.stores.single.values['name'], 'فراولة');
      expect(server.requests.last.url.path, '/rest/V1/vendors/product/FRS-1/translations');
      expect(json.decode(server.requests.last.body), {'translations': arabicName});
      for (final request in server.requests) {
        expect(request.headers['Authorization'], 'Bearer vendor-token');
      }
    });

    test('a new product asks without a SKU', () async {
      final server = FakeServer({
        'GET /V1/vendors/product/translations': (_) =>
            jsonResponse(translationsJson(arName: null)),
      });

      final template =
          await CreateEditProductApiService(httpClient: server.client).getProductTranslations('');

      expect(server.calls, ['GET /rest/V1/vendors/product/translations']);
      expect(template.stores.single.code, 'ar');
    });
  });

  group('Saving', () {
    CreateEditProductBloc blocFor(FakeServer server) => CreateEditProductBloc(
        repository: CreateEditProductRepository(
            service: CreateEditProductApiService(httpClient: server.client)));

    Future<List<CreateEditProductState>> run(
        CreateEditProductBloc bloc, CreateEditProductEvent event) async {
      final states = <CreateEditProductState>[];
      final subscription = bloc.stream.listen(states.add);
      bloc.add(event);
      await Future<void>.delayed(const Duration(milliseconds: 100));
      await subscription.cancel();
      await bloc.close();
      return states;
    }

    const save = PerformSaveProduct(
      requestValueMap: {
        'product': {'sku': 'FRS-1', 'name': 'Fresh Strawberries'},
        'attributes': [],
      },
      isUpdate: true,
      translations: [
        {
          'store_code': 'ar',
          'values': [
            {'attribute_code': 'name', 'value': 'فراولة'},
          ],
        },
      ],
    );

    test('saves the product, then its Arabic text under its SKU', () async {
      final server = FakeServer({
        'PUT /V1/vendors/product/save': (_) =>
            jsonResponse({'id': 7, 'sku': 'FRS-1', 'name': 'Fresh Strawberries'}),
        'PUT /V1/vendors/product/FRS-1/translations': (_) =>
            jsonResponse(translationsJson(arName: 'فراولة')),
      });

      final states = await run(blocFor(server), save);

      expect(server.calls, [
        'PUT /rest/V1/vendors/product/save',
        'PUT /rest/V1/vendors/product/FRS-1/translations',
      ]);
      final saved = states.last as SaveProductLoaded;
      expect(saved.translationsError, isNull);
      expect(saved.translationsReply?.stores.single.values['name'], 'فراولة');
    });

    test('a refused text save keeps the product saved and says why', () async {
      final server = FakeServer({
        'PUT /V1/vendors/product/save': (_) =>
            jsonResponse({'id': 7, 'sku': 'FRS-1', 'name': 'Fresh Strawberries'}),
        'PUT /V1/vendors/product/FRS-1/translations': (_) => http.Response(
            '{"message":"The store \\"fr\\" has no text for this product."}', 400),
      });

      final states = await run(blocFor(server), save);

      final saved = states.last as SaveProductLoaded;
      expect(saved.translationsError, contains('has no text for this product'));
      expect(states.whereType<ProductsError>(), isEmpty);
    });

    test('a server without the translations API gives the form none, and no error',
        () async {
      final states = await run(blocFor(FakeServer({})),
          const PerformProductTranslations(productSku: 'FRS-1'));

      expect(states, [isA<ProductTranslationsLoaded>()]);
      expect((states.single as ProductTranslationsLoaded).translations, isNull);
    });
  });

  group('Product form', () {
    // The fields of the attribute set; the form puts them in a set order and
    // needs about ten of them.
    final attributes = [
      {'attribute_code': 'status', 'frontend_input': 'select', 'default_frontend_label': 'Enable Product',
        'options': [{'label': 'Enabled', 'value': '1'}, {'label': 'Disabled', 'value': '2'}]},
      {'attribute_code': 'name', 'frontend_input': 'text', 'is_required': true, 'default_frontend_label': 'Product Name'},
      {'attribute_code': 'sku', 'frontend_input': 'text', 'is_required': true, 'default_frontend_label': 'SKU'},
      {'attribute_code': 'price', 'frontend_input': 'price', 'is_required': true, 'default_frontend_label': 'Price'},
      {'attribute_code': 'weight', 'frontend_input': 'weight', 'default_frontend_label': 'Weight'},
      {'attribute_code': 'material', 'frontend_input': 'text', 'default_frontend_label': 'Material'},
      {'attribute_code': 'origin', 'frontend_input': 'text', 'default_frontend_label': 'Origin'},
      {'attribute_code': 'season', 'frontend_input': 'text', 'default_frontend_label': 'Season'},
      {'attribute_code': 'description', 'frontend_input': 'textarea', 'default_frontend_label': 'Description'},
      {'attribute_code': 'short_description', 'frontend_input': 'textarea', 'default_frontend_label': 'Short Description'},
      {'attribute_code': 'grade', 'frontend_input': 'text', 'default_frontend_label': 'Grade'},
    ];
    // Read in the Arabic store, as the app did in Arabic.
    final product = {
      'id': 7, 'sku': 'FRS-1', 'name': 'فراولة طازجة', 'attribute_set_id': 4,
      'price': 12, 'status': 1, 'visibility': 4, 'type_id': 'simple',
      'custom_attributes': [
        {'attribute_code': 'description', 'value': 'حلوة وحمراء'},
        {'attribute_code': 'approval', 'value': '2'},
        {'attribute_code': 'category_ids', 'value': []},
      ],
      'media_gallery_entries': [],
    };

    FakeServer serverFor({required String liveArabicName}) => FakeServer({
          'GET /V1/products/attribute-sets/4/attributes': (_) => jsonResponse(attributes),
          'GET /V1/products/attribute-sets/sets/list/': (_) => jsonResponse({
                'items': [{'attribute_set_id': 4, 'attribute_set_name': 'Default'}],
              }),
          'GET /V1/vendors/product/FRS-1/translations': (_) => jsonResponse(translationsJson()),
          'GET /V1/products/FRS-1': (_) => jsonResponse(product),
          'GET /V1/vendors/me/stockItems/FRS-1': (_) => jsonResponse({'item_id': 1, 'qty': 5}),
          'GET /V1/vendors/me/categories': (_) => jsonResponse([]),
          'PUT /V1/vendors/product/save': (_) => jsonResponse({...product, 'name': 'Fresh Strawberries'}),
          'PUT /V1/vendors/product/FRS-1/translations': (_) =>
              jsonResponse(translationsJson(arName: liveArabicName)),
        });

    Future<void> openForm(WidgetTester tester, FakeServer server) async {
      tester.view.physicalSize = const Size(720, 1600);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.reset);
      // The form asks for photo access when it opens.
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          const MethodChannel('com.fluttercandies/photo_manager'), (_) async => 3);
      final navigator = GlobalKey<NavigatorState>();
      await tester.pumpWidget(BlocProvider<CreateEditProductBloc>(
        create: (_) => CreateEditProductBloc(
            repository: CreateEditProductRepository(
                service: CreateEditProductApiService(httpClient: server.client))),
        child: MaterialApp(
          navigatorKey: navigator,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: const Scaffold(body: Text('Products')),
        ),
      ));
      navigator.currentState!.push(MaterialPageRoute(
          builder: (_) => CreateEditProductWidget(productSku: 'FRS-1')));
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
    }

    Finder field(String label) => find.descendant(
        of: find.byWidgetPredicate((w) => w is EditProductInfoWidget && w.label == label),
        matching: find.byType(TextField));

    String textOf(WidgetTester tester, String label) =>
        tester.widget<TextField>(field(label)).controller!.text;

    Future<void> tapSave(WidgetTester tester) async {
      await tester.ensureVisible(find.text('SAVE'));
      await tester.tap(find.text('SAVE'));
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
    }

    testWidgets('edits the English and the Arabic text apart, and saves only the Arabic change',
        (tester) async {
      final server = serverFor(liveArabicName: 'فراولة');
      await openForm(tester, server);

      // The store-wide (English) text, though the product came in Arabic.
      expect(textOf(tester, 'Product Name (English)'), 'Fresh Strawberries');
      expect(textOf(tester, 'Product Name (Arabic)'), 'فراولة طازجة');
      expect(textOf(tester, 'Description (English)'), 'Sweet and red');
      expect(textOf(tester, 'Description (Arabic)'), '');
      expect(tester.widget<TextField>(field('Product Name (Arabic)')).textDirection,
          TextDirection.rtl);

      await tester.enterText(field('Product Name (Arabic)'), 'فراولة');
      await tapSave(tester);

      final productSave = server.requests.firstWhere((r) => r.url.path.endsWith('/product/save'));
      final sent = json.decode(productSave.body);
      expect(sent['product']['name'], 'Fresh Strawberries');
      expect(sent['attributes'], isNot(contains('name')));
      final textSave = server.requests.last;
      expect('${textSave.method} ${textSave.url.path}',
          'PUT /rest/V1/vendors/product/FRS-1/translations');
      expect(json.decode(textSave.body), {'translations': arabicName});
      // Live at once: saved, and back to the list.
      expect(find.text('Product saved.'), findsOneWidget);
      expect(find.text('Products'), findsOneWidget);
    });

    testWidgets('an Arabic change the admin must approve is named as waiting',
        (tester) async {
      final server = serverFor(liveArabicName: 'فراولة طازجة');
      await openForm(tester, server);

      await tester.enterText(field('Product Name (Arabic)'), 'فراولة');
      await tapSave(tester);

      expect(find.textContaining('Waiting for admin approval: Product Name (Arabic).'),
          findsOneWidget);
    });
  });
}
