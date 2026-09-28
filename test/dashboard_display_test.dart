import 'package:flutter_test/flutter_test.dart';
import 'package:multi_vendor/core/config/app_constants.dart';
import 'package:multi_vendor/core/config/tools.dart';
import 'package:multi_vendor/core/utils/money.dart';
import 'package:multi_vendor/features/home/view/sale_stats_chart.dart';

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
}
