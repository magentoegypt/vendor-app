import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:multi_vendor/core/config/pref_keys.dart';
import 'package:multi_vendor/core/helper/session_token.dart';
import 'package:multi_vendor/features/Orders/OrderList/data/orders_api_service.dart';
import 'package:multi_vendor/features/Orders/OrderList/data/orders_repository.dart';
import 'package:multi_vendor/features/auth/api_login_feature/bloc/login_bloc.dart';
import 'package:multi_vendor/features/auth/api_login_feature/data/login_repository.dart';
import 'package:multi_vendor/features/auth/api_login_feature/view/login_view.dart';
import 'package:multi_vendor/features/home/bloc/dashboard_bloc.dart';
import 'package:multi_vendor/features/home/data/dasboard_api_service.dart';
import 'package:multi_vendor/features/home/data/dashboard_repository.dart';
import 'package:multi_vendor/features/home/view/dashboard_widget.dart';
import 'package:multi_vendor/features/splash/spalsh_screen.dart';
import 'package:multi_vendor/l10n/app_localizations.dart';
import 'package:multi_vendor/main.dart' show navigatorKey;
import 'package:shared_preferences/shared_preferences.dart';

/// Answers the Dashboard's calls and records the token each one carried.
class SellerServer {
  final List<String?> tokens = [];

  http.Client get client => MockClient((request) async {
        tokens.add(request.headers['Authorization']);
        if (request.url.path.endsWith('/V1/vendors/dashboard')) {
          return http.Response(
              jsonEncode({'credit_amount': 'AED 0.00', 'total_products': 3}), 200);
        }
        if (request.url.path.contains('/V1/vendors/order')) {
          return http.Response(jsonEncode({'items': [], 'total_count': 0}), 200);
        }
        return http.Response(jsonEncode({'id': 1}), 200);
      });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('The session on this phone', () {
    test('a stored token means signed in; clearing it signs this phone out', () async {
      SharedPreferences.setMockInitialValues({
        authTokenPrefKey: 'seller-token',
        authTokenIssuedAtPrefKey: 1,
        userPrefKey: '{"id": 4}',
        isFirstLaunchPrefKey: 1,
      });
      expect(await SessionToken.isSignedIn(), isTrue);

      await SessionToken.clear();

      final prefs = await SharedPreferences.getInstance();
      expect(await SessionToken.isSignedIn(), isFalse);
      expect(prefs.getString(authTokenPrefKey), isNull);
      expect(prefs.getInt(authTokenIssuedAtPrefKey), isNull);
      expect(prefs.getString(userPrefKey), isNull);
      // The language choice stays.
      expect(prefs.getInt(isFirstLaunchPrefKey), 1);
    });
  });

  group('Where the app opens', () {
    Future<SellerServer> start(WidgetTester tester, Map<String, Object> prefs) async {
      tester.view.physicalSize = const Size(720, 1600);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.reset);
      SharedPreferences.setMockInitialValues(prefs);
      SignInView.isShown = false;
      final server = SellerServer();
      await tester.pumpWidget(MultiBlocProvider(
        providers: [
          BlocProvider<DashboardBloc>(
            create: (_) => DashboardBloc(
              repository: DashboardRepository(service: DasboardApiService(httpClient: server.client)),
              ordersRepository: OrdersRepository(service: OrdersApiService(httpClient: server.client)),
            ),
          ),
          BlocProvider<LoginBloc>(create: (_) => LoginBloc(repository: LoginRepository())),
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SplashScreen(),
        ),
      ));
      // The splash shows for 4 seconds.
      await tester.pump(const Duration(seconds: 4));
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      return server;
    }

    testWidgets('a stored token opens the Dashboard and is sent, whatever the old flag says',
        (tester) async {
      // The phone's state on 10-03: a token the server still accepted, and
      // the "logged out" flag that opening the login screen leaves.
      final server = await start(tester, {
        authTokenPrefKey: 'seller-token',
        authTokenIssuedAtPrefKey: DateTime.now().millisecondsSinceEpoch,
        initScreenPrefKey: 0,
        isFirstLaunchPrefKey: 1,
      });

      expect(find.byType(DashboardWidget), findsOneWidget);
      expect(find.byType(SignInView), findsNothing);
      expect(server.tokens, contains('Bearer seller-token'));
    });

    testWidgets('no token opens login, whatever the old flag says', (tester) async {
      await start(tester, {initScreenPrefKey: 1, isFirstLaunchPrefKey: 1});

      expect(find.byType(SignInView), findsOneWidget);
      expect(find.byType(DashboardWidget), findsNothing);
    });

    testWidgets('logging out removes the token, so the app opens on login next time',
        (tester) async {
      await start(tester, {
        authTokenPrefKey: 'seller-token',
        authTokenIssuedAtPrefKey: DateTime.now().millisecondsSinceEpoch,
        initScreenPrefKey: 1,
        isFirstLaunchPrefKey: 1,
      });
      expect(find.byType(DashboardWidget), findsOneWidget);

      await tester.tap(find.byIcon(Icons.logout));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.text('Yes'));
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(find.byType(SignInView), findsOneWidget);
      expect(await SessionToken.isSignedIn(), isFalse);
      expect((await SharedPreferences.getInstance()).getString(authTokenPrefKey), isNull);
    });
  });
}
