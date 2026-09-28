import 'package:flutter_test/flutter_test.dart';
import 'package:multi_vendor/core/config/app_constants.dart';
import 'package:multi_vendor/core/helper/api_url_helpers.dart';

void main() {
  test('API addresses follow a language switch without a restart', () {
    final previous = selectedLanguage;
    addTearDown(() => selectedLanguage = previous);

    selectedLanguage = 'ar';
    expect(vendorsProductsListApi, contains('/rest/ar/V1/'));

    // The products list stayed on /rest/ar/ after switching to English.
    selectedLanguage = 'en';
    for (final url in [vendorsProductsListApi, dashboardApi, vendorsOrderListApi, vendorDetailsApi,
        vendorsProductCategoriesApi, sendOTPApi]) {
      expect(url, contains('/rest/en/V1/'));
    }
  });
}
