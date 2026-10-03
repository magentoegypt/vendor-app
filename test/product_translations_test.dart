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

  http.Request? last(String method, String pathEnd) => requests
      .where((r) => r.method == method && r.url.path.endsWith(pathEnd))
      .lastOrNull;
}

http.Response jsonResponse(Object body) => http.Response.bytes(
    utf8.encode(json.encode(body)), 200,
    headers: {'content-type': 'application/json; charset=utf-8'});

List<Map<String, dynamic>> values(Map<String, String?> texts) => [
      for (final entry in texts.entries) {'attribute_code': entry.key, 'value': entry.value},
    ];

/// The translations GET as the backend answers it (10-03): every store view
/// of the website, the default one (en) first, each with its own values.
Map<String, dynamic> translationsJson({
  Map<String, String?> defaults = const {
    'name': 'Fresh Strawberries',
    'short_description': null,
    'description': 'Sweet and red',
  },
  Map<String, String?> en = const {},
  Map<String, String?> ar = const {'name': 'فراولة طازجة'},
}) {
  Map<String, String?> own(Map<String, String?> texts) =>
      {for (final code in defaults.keys) code: texts[code]};
  return {
    'default_values': values(defaults),
    'stores': [
      {'store_id': 3, 'store_code': 'en', 'store_name': 'English', 'locale': 'en_US', 'values': values(own(en))},
      {'store_id': 1, 'store_code': 'ar', 'store_name': 'عربي', 'locale': 'ar_SA', 'values': values(own(ar))},
    ],
  };
}

List<Map<String, dynamic>> change(String store, Map<String, String?> texts) => [
      {'store_code': store, 'values': values(texts)},
    ];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({authTokenPrefKey: 'vendor-token'}));

  group('A product\'s text per store view', () {
    test('each store view shows its own text, else the store-wide one', () {
      final translations = ProductTranslations.fromJson(translationsJson());
      final en = translations.stores.first;
      final ar = translations.stores.last;

      expect([en.code, ar.code], ['en', 'ar']);
      expect([en.languageCode, ar.languageCode], ['en', 'ar']);
      expect(translations.textIn(en, 'name'), 'Fresh Strawberries');
      expect(translations.textIn(ar, 'name'), 'فراولة طازجة');
      expect(translations.textIn(ar, 'description'), 'Sweet and red');
      expect(translations.textIn(ar, 'short_description'), isNull);
    });

    test('sends only what the vendor changed from what the store showed', () {
      final loaded = ProductTranslations.fromJson(translationsJson());

      // Shown as loaded: nothing to send.
      expect(
          translationChanges(loaded, {
            'en': {'name': 'Fresh Strawberries', 'description': 'Sweet and red', 'short_description': ''},
            'ar': {'name': 'فراولة طازجة ', 'description': 'Sweet and red'},
          }),
          isEmpty);
      expect(
          translationChanges(loaded, {
            'ar': {'name': 'فراولة', 'description': 'حلوة وحمراء'},
          }),
          change('ar', {'name': 'فراولة', 'description': 'حلوة وحمراء'}));
      // An emptied text goes as null: the store shows the store-wide one again.
      expect(translationChanges(loaded, {'ar': {'description': ''}}),
          change('ar', {'description': null}));
    });

    test('a change the reply does not show yet waits for the admin', () {
      final sent = change('ar', {'name': 'فراولة'});

      expect(translationsAwaitingApproval(sent, ProductTranslations.fromJson(translationsJson())),
          [(store: 'ar', code: 'name')]);
      expect(
          translationsAwaitingApproval(
              sent, ProductTranslations.fromJson(translationsJson(ar: {'name': 'فراولة'}))),
          isEmpty);
    });
  });

  group('Translations API', () {
    test('GET and PUT /V1/vendors/product/:sku/translations with the vendor token',
        () async {
      final server = FakeServer({
        'GET /V1/vendors/product/FRS-1/translations': (_) => jsonResponse(translationsJson()),
        'PUT /V1/vendors/product/FRS-1/translations': (_) =>
            jsonResponse(translationsJson(ar: {'name': 'فراولة'})),
      });
      final service = CreateEditProductApiService(httpClient: server.client);

      final loaded = await service.getProductTranslations('FRS-1');
      final saved = await service.saveProductTranslations('FRS-1', change('ar', {'name': 'فراولة'}));

      expect(loaded.stores.last.values['name'], 'فراولة طازجة');
      expect(saved.stores.last.values['name'], 'فراولة');
      expect(server.requests.last.url.path, '/rest/V1/vendors/product/FRS-1/translations');
      expect(json.decode(server.requests.last.body),
          {'translations': change('ar', {'name': 'فراولة'})});
      for (final request in server.requests) {
        expect(request.headers['Authorization'], 'Bearer vendor-token');
      }
    });

    test('a new product asks without a SKU', () async {
      final server = FakeServer({
        'GET /V1/vendors/product/translations': (_) =>
            jsonResponse(translationsJson(defaults: {'name': null}, ar: {})),
      });

      final template =
          await CreateEditProductApiService(httpClient: server.client).getProductTranslations('');

      expect(server.calls, ['GET /rest/V1/vendors/product/translations']);
      expect(template.stores.map((s) => s.code), ['en', 'ar']);
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

    final save = PerformSaveProduct(
      requestValueMap: const {
        'product': {'sku': 'FRS-1', 'name': 'Fresh Strawberries'},
        'attributes': [],
      },
      isUpdate: true,
      translations: change('ar', {'name': 'فراولة'}),
    );

    test('saves the product, then its text per store view under its SKU', () async {
      final server = FakeServer({
        'PUT /V1/vendors/product/save': (_) =>
            jsonResponse({'id': 7, 'sku': 'FRS-1', 'name': 'Fresh Strawberries'}),
        'PUT /V1/vendors/product/FRS-1/translations': (_) =>
            jsonResponse(translationsJson(ar: {'name': 'فراولة'})),
      });

      final states = await run(blocFor(server), save);

      expect(server.calls, [
        'PUT /rest/V1/vendors/product/save',
        'PUT /rest/V1/vendors/product/FRS-1/translations',
      ]);
      final saved = states.last as SaveProductLoaded;
      expect(saved.translationsError, isNull);
      expect(saved.translationsReply?.stores.last.values['name'], 'فراولة');
    });

    test('a refused text save keeps the product saved and says why', () async {
      final server = FakeServer({
        'PUT /V1/vendors/product/save': (_) =>
            jsonResponse({'id': 7, 'sku': 'FRS-1', 'name': 'Fresh Strawberries'}),
        'PUT /V1/vendors/product/FRS-1/translations': (_) => http.Response(
            '{"message":"Unknown store view \\"fr\\". Use one of: en, ar."}', 400),
      });

      final states = await run(blocFor(server), save);

      final saved = states.last as SaveProductLoaded;
      expect(saved.translationsError, contains('Unknown store view "fr"'));
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
    // Read in the Arabic store, as the app does in Arabic.
    final product = {
      'id': 7, 'sku': 'FRS-1', 'name': 'فراولة طازجة', 'attribute_set_id': 4,
      'price': 12, 'status': 1, 'visibility': 4, 'type_id': 'simple',
      'custom_attributes': [
        {'attribute_code': 'description', 'value': 'Sweet and red'},
        {'attribute_code': 'approval', 'value': '2'},
        {'attribute_code': 'category_ids', 'value': []},
      ],
      'media_gallery_entries': [],
    };

    FakeServer serverFor({
      Map<String, dynamic>? loaded,
      Map<String, dynamic>? reply,
    }) =>
        FakeServer({
          'GET /V1/products/attribute-sets/4/attributes': (_) => jsonResponse(attributes),
          'GET /V1/products/attribute-sets/sets/list/': (_) => jsonResponse({
                'items': [{'attribute_set_id': 4, 'attribute_set_name': 'Default'}],
              }),
          'GET /V1/vendors/product/translations': (_) => jsonResponse(translationsJson(
              defaults: {'name': null, 'short_description': null, 'description': null}, ar: {})),
          'GET /V1/vendors/product/FRS-1/translations': (_) => jsonResponse(loaded ?? translationsJson()),
          'GET /V1/products/FRS-1': (_) => jsonResponse(product),
          'GET /V1/vendors/me/stockItems/FRS-1': (_) => jsonResponse({'item_id': 1, 'qty': 5}),
          'GET /V1/vendors/me/categories': (_) => jsonResponse([]),
          'PUT /V1/vendors/product/save': (_) => jsonResponse(product),
          'POST /V1/vendors/product/save': (_) => jsonResponse({...product, 'id': 9, 'sku': 'NEW-1'}),
          'PUT /V1/vendors/product/FRS-1/translations': (_) => jsonResponse(reply ?? translationsJson()),
          'PUT /V1/vendors/product/NEW-1/translations': (_) => jsonResponse(reply ?? translationsJson()),
        });

    Future<void> openForm(WidgetTester tester, FakeServer server, {String sku = 'FRS-1'}) async {
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
          builder: (_) => CreateEditProductWidget(productSku: sku)));
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

    testWidgets('one field per language, each showing what its store shows; only the change is sent',
        (tester) async {
      final server = serverFor(reply: translationsJson(ar: {'name': 'فراولة'}));
      await openForm(tester, server);

      expect(field('Product Name'), findsNothing);
      expect(field('Product Name (English)'), findsOneWidget);
      expect(textOf(tester, 'Product Name (English)'), 'Fresh Strawberries');
      expect(textOf(tester, 'Product Name (Arabic)'), 'فراولة طازجة');
      // No Arabic description of its own: the Arabic store shows the store-wide one.
      expect(textOf(tester, 'Description (Arabic)'), 'Sweet and red');
      expect(tester.widget<TextField>(field('Product Name (Arabic)')).textDirection,
          TextDirection.rtl);
      expect(tester.widget<TextField>(field('Product Name (English)')).textDirection,
          TextDirection.ltr);

      await tester.enterText(field('Product Name (Arabic)'), 'فراولة');
      await tapSave(tester);

      final productSave = json.decode(server.last('PUT', '/product/save')!.body);
      expect(productSave['attributes'], isNot(contains('name')));
      expect(json.decode(server.last('PUT', '/FRS-1/translations')!.body),
          {'translations': change('ar', {'name': 'فراولة'})});
      // Live at once: saved, and back to the list.
      expect(find.text('Product saved.'), findsOneWidget);
      expect(find.text('Products'), findsOneWidget);
    });

    testWidgets('a product kept in Arabic store-wide edits its English name in the English store',
        (tester) async {
      final server = serverFor(
        loaded: translationsJson(
          defaults: {'name': 'فراولة', 'short_description': null, 'description': null},
          en: {'name': 'Strawberries'},
          ar: {},
        ),
        reply: translationsJson(
          defaults: {'name': 'فراولة', 'short_description': null, 'description': null},
          en: {'name': 'Fresh Strawberries'},
          ar: {},
        ),
      );
      await openForm(tester, server);

      expect(textOf(tester, 'Product Name (English)'), 'Strawberries');
      expect(textOf(tester, 'Product Name (Arabic)'), 'فراولة');

      await tester.enterText(field('Product Name (English)'), 'Fresh Strawberries');
      await tapSave(tester);

      expect(json.decode(server.last('PUT', '/FRS-1/translations')!.body),
          {'translations': change('en', {'name': 'Fresh Strawberries'})});
    });

    testWidgets('an Arabic change the admin must approve is named as waiting',
        (tester) async {
      final server = serverFor();
      await openForm(tester, server);

      await tester.enterText(field('Product Name (Arabic)'), 'فراولة');
      await tapSave(tester);

      expect(find.textContaining('Waiting for admin approval: Product Name (Arabic).'),
          findsOneWidget);
    });

    testWidgets('a name cannot be emptied in one language', (tester) async {
      final server = serverFor();
      await openForm(tester, server);

      await tester.enterText(field('Product Name (English)'), ' ');
      await tapSave(tester);

      expect(find.text('Product Name (English) is required.'), findsOneWidget);
      expect(server.last('PUT', '/product/save'), isNull);
      expect(server.last('PUT', '/FRS-1/translations'), isNull);
    });

    testWidgets('a new product is created with its English text, then gets its Arabic text',
        (tester) async {
      final server = serverFor(reply: translationsJson(
          defaults: {'name': 'Apples', 'short_description': null, 'description': null},
          ar: {'name': 'تفاح'}));
      await openForm(tester, server, sku: '');

      await tester.enterText(field('SKU'), 'NEW-1');
      await tester.enterText(field('Price'), '10');
      await tester.enterText(field('Product Name (English)'), 'Apples');
      await tester.enterText(field('Product Name (Arabic)'), 'تفاح');
      await tapSave(tester);

      final created = json.decode(server.last('POST', '/product/save')!.body);
      expect(created['product']['name'], 'Apples');
      expect(json.decode(server.last('PUT', '/NEW-1/translations')!.body),
          {'translations': change('ar', {'name': 'تفاح'})});
      expect(find.text('Products'), findsOneWidget);
    });
  });
}
