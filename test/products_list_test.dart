import 'dart:async';
import 'dart:convert';
import 'dart:io' show SocketException;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:multi_vendor/core/config/app_constants.dart';
import 'package:multi_vendor/core/config/app_exceptions.dart';
import 'package:multi_vendor/core/config/pref_keys.dart';
import 'package:multi_vendor/core/helper/loading_screen.dart';
import 'package:multi_vendor/core/helper/overlay_animated_spinner.dart';
import 'package:multi_vendor/features/Products/ProductList/bloc/products_bloc.dart';
import 'package:multi_vendor/features/Products/ProductList/bloc/products_event.dart';
import 'package:multi_vendor/features/Products/ProductList/bloc/products_state.dart';
import 'package:multi_vendor/features/Products/ProductList/data/products_api_service.dart';
import 'package:multi_vendor/features/Products/ProductList/data/products_repository.dart';
import 'package:multi_vendor/features/Products/ProductList/view/products_widget.dart';
import 'package:multi_vendor/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final list = jsonEncode({
    'items': [
      {'id': 2401, 'sku': '2345', 'name': 'test add product app', 'price': 5000,
        'qty': 500, 'type_id': 'simple', 'status': 1},
    ],
    'total_count': 1,
  });
  const serverErrorEn =
      'Something went wrong while contacting the server. Please try again.';
  const serverErrorAr = 'حدث خطأ أثناء الاتصال بالخادم. يرجى المحاولة مرة أخرى.';

  setUp(() {
    // A seller token saved just now, so no refresh call reaches the mocks.
    SharedPreferences.setMockInitialValues({
      authTokenPrefKey: 'seller-token',
      authTokenIssuedAtPrefKey: DateTime.now().millisecondsSinceEpoch,
    });
  });

  ProductsApiService service(http.Client client) =>
      ProductsApiService(httpClient: client, retryPause: Duration.zero);

  Matcher failsWith(String message) => throwsA(
      isA<HttpException>().having((e) => e.toString(), 'message', message));

  group('Products list loading (14zb93nvb0p)', () {
    test('a failed first try is asked again, and the list loads', () async {
      var calls = 0;
      final client = MockClient((_) async {
        calls++;
        return calls == 1
            ? http.Response('<html>502 Bad Gateway</html>', 502)
            : http.Response(list, 200);
      });

      final model = await service(client).getProductsData('searchCriteria[pageSize]=100');

      expect(calls, 2);
      expect(model.products!.single.sku, '2345');
    });

    test('a dropped connection is tried again too', () async {
      var calls = 0;
      final client = MockClient((_) async {
        calls++;
        if (calls == 1) {
          throw http.ClientException('Connection closed before full header was received');
        }
        return http.Response(list, 200);
      });

      final model = await service(client).getProductsData('searchCriteria[pageSize]=100');

      expect(calls, 2);
      expect(model.products!.single.name, 'test add product app');
    });

    test("the server's own message is shown at once, not retried", () async {
      var calls = 0;
      final client = MockClient((_) async {
        calls++;
        return http.Response(
            '{"message":"Your seller account is disabled. Please contact support."}', 403);
      });

      await expectLater(service(client).getProductsData('q'),
          failsWith('Your seller account is disabled. Please contact support.'));
      expect(calls, 1);
    });

    test('after two failures the message is in the app language', () async {
      final previous = selectedLanguage;
      addTearDown(() => selectedLanguage = previous);
      final client = MockClient(
          (_) async => http.Response('<html>504 Gateway Time-out</html>', 504));

      selectedLanguage = 'ar';
      await expectLater(service(client).getProductsData('q'), failsWith(serverErrorAr));
      selectedLanguage = 'en';
      await expectLater(service(client).getProductsData('q'), failsWith(serverErrorEn));
    });

    test('only the newest load changes the state', () async {
      // The old load went out offline: both of its tries hang, then fail.
      final offline = Completer<void>();
      var oldTries = 0;
      final client = MockClient((request) async {
        if (request.url.toString().endsWith('load=old')) {
          oldTries++;
          await offline.future;
          throw const SocketException('Connection timed out');
        }
        return http.Response(list, 200);
      });
      final bloc = ProductsBloc(repository: ProductsRepository(service: service(client)));
      addTearDown(bloc.close);
      final states = <ProductsState>[];
      final subscription = bloc.stream.listen(states.add);
      addTearDown(subscription.cancel);

      bloc.add(const PerformProductList(query: 'load=old'));
      bloc.add(const PerformProductList(query: 'load=new'));
      await bloc.stream.firstWhere((state) => state is ProductsLoaded);
      offline.complete();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(oldTries, 2, reason: 'the old load has failed by now');
      expect(states, [
        ProductsLoading(load: 1),
        ProductsLoading(load: 2),
        isA<ProductsLoaded>(),
      ]);
    });
  });

  testWidgets('a failed load shows the message with Retry, and Retry loads the list',
      (tester) async {
    final previous = selectedLanguage;
    addTearDown(() => selectedLanguage = previous);
    selectedLanguage = 'en';
    var failing = true;
    final client = MockClient((_) async => failing
        ? http.Response('<html>502 Bad Gateway</html>', 502)
        : http.Response(list, 200));
    final bloc = ProductsBloc(repository: ProductsRepository(service: service(client)));
    addTearDown(bloc.close);

    Future<void> settle() async {
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
    }

    await tester.pumpWidget(MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<ProductsBloc>.value(value: bloc, child: ProductsWidget()),
    ));
    await settle();

    expect(find.text(serverErrorEn), findsOneWidget);
    expect(find.byKey(const Key('productsRetry')), findsOneWidget);

    failing = false;
    await tester.tap(find.byKey(const Key('productsRetry')));
    await settle();

    expect(find.text('test add product app'), findsOneWidget);
    expect(find.byKey(const Key('productsRetry')), findsNothing);
  });

  testWidgets('a load that fails after Products was opened again leaves the new list alone',
      (tester) async {
    final previous = selectedLanguage;
    addTearDown(() => selectedLanguage = previous);
    selectedLanguage = 'en';
    // Products opened offline: the first try failed at once, and the second one
    // hung while the connection came back and failed only later.
    final hung = Completer<void>();
    final reopened = Completer<void>();
    var calls = 0;
    final client = MockClient((_) async {
      calls++;
      if (calls == 1) throw const SocketException('Failed host lookup');
      if (calls == 2) {
        await hung.future;
        throw const SocketException('Connection reset by peer');
      }
      await reopened.future;
      return http.Response(list, 200);
    });
    final bloc = ProductsBloc(repository: ProductsRepository(service: service(client)));
    addTearDown(bloc.close);
    final navigator = GlobalKey<NavigatorState>();
    void openProducts() => navigator.currentState!.push(MaterialPageRoute<void>(
        builder: (_) => BlocProvider<ProductsBloc>.value(value: bloc, child: ProductsWidget())));

    Future<void> settle() async {
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
    }

    await tester.pumpWidget(MaterialApp(
      navigatorKey: navigator,
      navigatorObservers: [LoadingScreenObserver()],
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(body: Text('dashboard')),
    ));
    openProducts();
    await settle();
    expect(calls, 2);
    expect(find.byType(OverLayAnimatedSpinner), findsOneWidget);

    // Back while it hangs, then Products again with the connection back.
    navigator.currentState!.pop();
    await settle();
    expect(find.byType(OverLayAnimatedSpinner), findsNothing);
    openProducts();
    await settle();
    expect(find.byType(OverLayAnimatedSpinner), findsOneWidget,
        reason: 'the reopened list shows its own spinner');

    reopened.complete();
    await settle();
    expect(find.text('test add product app'), findsOneWidget);

    hung.complete();
    await settle();
    expect(find.byType(SnackBar), findsNothing);
    expect(find.text('No internet connection'), findsNothing);
    expect(find.text('test add product app'), findsOneWidget);
  });
}
