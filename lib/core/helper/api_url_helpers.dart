
import '../config/app_constants.dart';

// Getters, not variables: a top-level variable is built once, on first use,
// so after switching language the app kept calling the other store view and
// server text (messages, category names) came back in the old language.

 const String apiBaseUrl = "https://multi.magento2.click";
 String baseProductImageUrl = "$apiBaseUrl/media/catalog/product";
String get countryInformationAcquirerApi => '$apiBaseUrl/rest/$selectedLanguage/V1/directory/countries';
String get userLoginApi => '$apiBaseUrl/rest/$selectedLanguage/V1/integration/customer/token';
String get userRegisterApi => '$apiBaseUrl/rest/$selectedLanguage/V1/vendors/register';
String get vendorDetailsApi => '$apiBaseUrl/rest/$selectedLanguage/V1/vendors/me';
const String vendorTokenRefreshApi = '$apiBaseUrl/rest/V1/vendors/me/token/refresh';
 // Seller-only endpoints: PUT updates and DELETE removes the signed-in vendor.
String get vendorUpdateDataApi => '$apiBaseUrl/rest/$selectedLanguage/V1/vendors/me';
String get vendorDeleteDataApi => '$apiBaseUrl/rest/$selectedLanguage/V1/vendors/me';
// period: 24h, 7d, 1m, 1y or 2y; the sales chart shows a week.
String get dashboardApi => '$apiBaseUrl/rest/$selectedLanguage/V1/vendors/dashboard?period=7d';
String get vendorsOrderListApi => '$apiBaseUrl/rest/$selectedLanguage/V1/vendors/order?';
String get vendorsSingleOrderApi => '$apiBaseUrl/rest/$selectedLanguage/V1/vendor/order/';
String get vendorsProductsListApi => '$apiBaseUrl/rest/$selectedLanguage/V1/vendors/product?';
String get vendorsProductCategoriesApi => '$apiBaseUrl/rest/$selectedLanguage/V1/vendors/me/categories';
String get vendorsProductAttributeApi => '$apiBaseUrl/rest/$selectedLanguage/V1/products/attribute-sets/';
String get vendorsProductAttributeSetListApi => '$apiBaseUrl/rest/$selectedLanguage/V1/products/attribute-sets/sets/list/?';
 String vendorsSaveProductsApi = '$apiBaseUrl/rest/V1/vendors/product/save';
String get vendorsSingleProductsApi => '$apiBaseUrl/rest/$selectedLanguage/V1/products/';
String get vendorsSingleProductQuantityApi => '$apiBaseUrl/rest/$selectedLanguage/V1/vendors/me/stockItems/';
String get vendorsProductDeleteMediaApi => '$apiBaseUrl/rest/$selectedLanguage/V1/vendors/product/';
String get sendOTPApi => '$apiBaseUrl/rest/$selectedLanguage/V1/whatsapp/otp/send';
String get verifyOTPApi => '$apiBaseUrl/rest/$selectedLanguage/V1/whatsapp/otp/verify';
String get forgotPasswordApi => '$apiBaseUrl/rest/$selectedLanguage/V1/customers/password';

/// Orders newest first. Magento's default order is oldest first, which put
/// Sep 13 orders under "Latest Sales" while the web panel showed Sep 26.
const String newestOrdersFirst =
    'searchCriteria[sortOrders][0][field]=created_at&searchCriteria[sortOrders][0][direction]=DESC';
