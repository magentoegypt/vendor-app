import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:multi_vendor/core/config/app_constants.dart';
import 'package:multi_vendor/core/config/pref_keys.dart';
import 'package:multi_vendor/core/config/tools.dart';
import 'package:multi_vendor/core/utils/money.dart';
import 'package:multi_vendor/features/Orders/OrderList/data/orders_api_service.dart';
import 'package:multi_vendor/features/Orders/OrderList/data/orders_repository.dart';
import 'package:multi_vendor/features/home/bloc/dashboard_bloc.dart';
import 'package:multi_vendor/features/home/data/dasboard_api_service.dart';
import 'package:multi_vendor/features/home/data/dashboard_repository.dart';
import 'package:multi_vendor/features/home/view/dashboard_widget.dart';
import 'package:multi_vendor/features/home/view/sale_stats_chart.dart';
import 'package:multi_vendor/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    // What /V1/directory/currency returns on Hub Market.
    Money.storeCurrency = 'AED';
  });
  tearDown(() {
    Money.storeCurrency = null;
  });

  group('Currency (14zb93nv1jw item 7, 14zb93nv1kq item 4)', () {
    test('an order shows in its own currency, not a hard-coded EGP', () {
      expect(Money.format(550, currency: 'AED'), 'AED 550.00');
      expect(Money.format(1430, currency: 'EGP'), 'EGP 1,430.00');
    });

    test('product prices use the store currency', () {
      expect(Money.format(963653), 'AED 963,653.00');
    });

    test('before the store currency is known, amounts show no currency', () {
      Money.storeCurrency = null;
      expect(Money.format(963653), '963,653.00');
    });

    test('Arabic shows the code as well, like the dashboard cards', () {
      final previous = selectedLanguage;
      addTearDown(() => selectedLanguage = previous);
      selectedLanguage = 'en';
      expect(Tools.getCurrencyCode(26000, currency: 'AED'), 'AED 26,000.00');
      selectedLanguage = 'ar';
      expect(Tools.getCurrencyCode(26000, currency: 'AED'), 'AED 26,000.00');
    });
  });

  group('Sales chart (14zb93nv1jw items 3-4)', () {
    test('the Y axis counts orders in whole steps', () {
      expect(SaleStatsChart.orderStep(0), 1);
      expect(SaleStatsChart.orderStep(5), 1);
      expect(SaleStatsChart.orderStep(6), 2);
      expect(SaleStatsChart.orderStep(23), 5);
    });

    test('dates drop the year so a week fits the card', () {
      expect(SaleStatsChart.shortDate('2026-9-27'), '9-27');
      expect(SaleStatsChart.shortDate('9-27'), '9-27');
      expect(SaleStatsChart.shortDate(null), '');
    });

    test('every day is labelled up to ten, and the latest day always', () {
      expect(List.generate(9, (i) => SaleStatsChart.labelsDay(i, 9)),
          everyElement(isTrue));
      final month = List.generate(30, (i) => SaleStatsChart.labelsDay(i, 30));
      expect(month.last, isTrue);
      expect(month.where((shown) => shown).length, 10);
    });
  });

  testWidgets('switching the language loads the cards again, formatted for it',
      (tester) async {
    final previous = selectedLanguage;
    addTearDown(() => selectedLanguage = previous);
    SharedPreferences.setMockInitialValues({
      authTokenPrefKey: 'seller-token',
      authTokenIssuedAtPrefKey: DateTime.now().millisecondsSinceEpoch,
    });
    // The server formats the cards for the store view it is asked through, as
    // on the phone: Arabic digits and the Arabic dirham sign through /rest/ar/.
    const arabicCredit = '٢٤٬٩٩٣٫٠٠ د.إ.‏';
    final dashboards = <String>[];
    final client = MockClient((request) async {
      final path = request.url.path;
      if (path.endsWith('/V1/vendors/dashboard')) {
        dashboards.add(path);
        final arabic = path.contains('/rest/ar/');
        return http.Response(
            jsonEncode({
              'credit_amount': arabic ? arabicCredit : 'AED 24,993.00',
              'lifetime_sales': arabic ? '٢٦٬٠٠٠٫٠٠ د.إ.‏' : 'AED 26,000.00',
              'average_orders': arabic ? '٧٢٢٫٢٢ د.إ.‏' : 'AED 722.22',
              'total_products': 14,
            }),
            200,
            headers: {'content-type': 'application/json; charset=utf-8'});
      }
      if (path.contains('/V1/vendors/order')) {
        return http.Response(jsonEncode({'items': [], 'total_count': 0}), 200);
      }
      return http.Response(jsonEncode({'id': 1}), 200);
    });
    final bloc = DashboardBloc(
      repository: DashboardRepository(service: DasboardApiService(httpClient: client)),
      ordersRepository: OrdersRepository(service: OrdersApiService(httpClient: client)),
    );
    addTearDown(bloc.close);

    Future<void> settle() async {
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
    }

    // What MainApp.setLocale does: the app rebuilds in the new language, and
    // the Dashboard under the language dialog stays where it is.
    final locale = ValueNotifier(const Locale('ar'));
    selectedLanguage = 'ar';
    await tester.pumpWidget(ValueListenableBuilder<Locale>(
      valueListenable: locale,
      builder: (_, value, __) => MaterialApp(
        locale: value,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider<DashboardBloc>.value(value: bloc, child: const DashboardWidget()),
      ),
    ));
    await settle();
    expect(find.text(arabicCredit), findsOneWidget);

    selectedLanguage = 'en';
    locale.value = const Locale('en');
    await settle();

    expect(dashboards, ['/rest/ar/V1/vendors/dashboard', '/rest/en/V1/vendors/dashboard']);
    expect(find.text('AED 24,993.00'), findsOneWidget);
    expect(find.text('AED 26,000.00'), findsOneWidget);
    expect(find.text(arabicCredit), findsNothing);
  });
}
