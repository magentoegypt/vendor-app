import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:multi_vendor/core/config/app_exceptions.dart';
import 'package:multi_vendor/core/config/pref_keys.dart';
import 'package:multi_vendor/core/config/tools.dart';
import 'package:multi_vendor/core/helper/api_response_helper.dart';
import 'package:multi_vendor/features/auth/api_login_feature/bloc/login_bloc.dart';
import 'package:multi_vendor/features/auth/api_login_feature/data/login_repository.dart';
import 'package:multi_vendor/features/auth/api_login_feature/view/login_view.dart';
import 'package:multi_vendor/l10n/app_localizations.dart';
import 'package:multi_vendor/features/Orders/OrderList/bloc/orders_bloc.dart';
import 'package:multi_vendor/features/Orders/OrderList/bloc/orders_event.dart';
import 'package:multi_vendor/features/Orders/OrderList/bloc/orders_state.dart';
import 'package:multi_vendor/features/Orders/OrderList/data/orders_api_service.dart';
import 'package:multi_vendor/features/Orders/OrderList/data/orders_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// What Magento answers once the seller's token has expired.
final expired = http.Response(
    '{"message":"The consumer isn\'t authorized to access %resources.",'
    '"parameters":{"resources":"Vnecoms_Vendors::vendors"}}',
    401);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  var loginOpened = 0;
  setUp(() {
    SharedPreferences.setMockInitialValues({authTokenPrefKey: 'old-token'});
    loginOpened = 0;
    onSessionExpired = () => loginOpened++;
  });
  tearDown(() => onSessionExpired = null);

  group('Session expired (401 with a stored token)', () {
    test('ends the session, opens login once and carries no text', () async {
      final call = apiResponseHelper(
          response: expired,
          className: 'test',
          apiUrl: 'orders',
          requestValue: '',
          token: 'old-token');

      await expectLater(
          call,
          throwsA(isA<SessionExpiredException>()
              .having((e) => '$e', 'text', isEmpty)));
      expect(loginOpened, 1);
      expect((await SharedPreferences.getInstance()).getString(authTokenPrefKey),
          isNull);
    });

    test('the Orders screen gets an error without text, not "Unauthorised: 401"',
        () async {
      final bloc = OrdersBloc(
          ordersRepository: OrdersRepository(
              service: OrdersApiService(
                  httpClient: MockClient((_) async => expired))));
      final states = <OrdersState>[];
      final subscription = bloc.stream.listen(states.add);

      bloc.add(const PerformOrdersList(query: ''));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await subscription.cancel();
      await bloc.close();

      expect(states.last, isA<OrderError>());
      expect((states.last as OrderError).errorMessage, isEmpty);
    });

    test('a 401 while logging in still shows the server message', () async {
      final call = apiResponseHelper(
          response: http.Response(
              '{"message":"The account sign-in was incorrect."}', 401),
          className: 'test',
          apiUrl: 'token',
          requestValue: '',
          token: '');

      await expectLater(
          call,
          throwsA(isA<HttpException>().having(
              (e) => '$e', 'text', 'The account sign-in was incorrect.')));
      expect(loginOpened, 0);
    });
  });

  testWidgets('the login screen says the session expired, and nothing else',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final navigator = GlobalKey<NavigatorState>();
    await tester.pumpWidget(BlocProvider<LoginBloc>(
      create: (_) => LoginBloc(repository: LoginRepository()),
      child: MaterialApp(
        navigatorKey: navigator,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(),
      ),
    ));
    // What a screen whose call failed used to queue before login opened.
    Tools.showSnackBar(
        tester.state<ScaffoldMessengerState>(find.byType(ScaffoldMessenger)),
        'Unauthorised: 401');
    await tester.pump();

    navigator.currentState!.pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (_) => const SignInView(sessionExpired: true)),
        (route) => false);
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    expect(find.text('Your session has expired. Please log in again.'),
        findsOneWidget);
    expect(find.text('Unauthorised: 401'), findsNothing);
  });

  testWidgets('an error without text shows no empty bar', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold()));
    final messenger =
        tester.state<ScaffoldMessengerState>(find.byType(ScaffoldMessenger));

    Tools.showSnackBar(messenger, '');
    await tester.pump();
    expect(find.byType(SnackBar), findsNothing);

    Tools.showSnackBar(messenger, 'Saved');
    await tester.pump();
    expect(find.text('Saved'), findsOneWidget);
  });
}
