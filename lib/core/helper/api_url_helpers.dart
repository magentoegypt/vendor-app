
import '../config/app_constants.dart';

 const String apiBaseUrl = "https://multi.magento2.click";
 String baseProductImageUrl = "$apiBaseUrl/media/catalog/product";
 String countryInformationAcquirerApi = '$apiBaseUrl/rest/$selectedLanguage/V1/directory/countries';
 String userLoginApi = '$apiBaseUrl/rest/$selectedLanguage/V1/integration/customer/token';
 String userRegisterApi = '$apiBaseUrl/rest/$selectedLanguage/V1/vendors/register';
 String vendorDetailsApi = '$apiBaseUrl/rest/$selectedLanguage/V1/vendors/me';
 // Seller-only endpoints: PUT updates and DELETE removes the signed-in vendor.
 String vendorUpdateDataApi = '$apiBaseUrl/rest/$selectedLanguage/V1/vendors/me';
String vendorDeleteDataApi = '$apiBaseUrl/rest/$selectedLanguage/V1/vendors/me';
 String dashboardApi = '$apiBaseUrl/rest/$selectedLanguage/V1/vendors/dashboard';
 String vendorsOrderListApi = '$apiBaseUrl/rest/$selectedLanguage/V1/vendors/order?';
 String vendorsSingleOrderApi = '$apiBaseUrl/rest/$selectedLanguage/V1/vendor/order/';
 String vendorsProductsListApi = '$apiBaseUrl/rest/$selectedLanguage/V1/vendors/product?';
String vendorsProductCategoriesApi = '$apiBaseUrl/rest/$selectedLanguage/V1/vendors/me/categories';
 String vendorsProductAttributeApi = '$apiBaseUrl/rest/$selectedLanguage/V1/products/attribute-sets/';
 String vendorsProductAttributeSetListApi = '$apiBaseUrl/rest/$selectedLanguage/V1/products/attribute-sets/sets/list/?';
 String vendorsSaveProductsApi = '$apiBaseUrl/rest/V1/vendors/product/save';
 String vendorsSingleProductsApi = '$apiBaseUrl/rest/$selectedLanguage/V1/products/';
 String vendorsSingleProductQuantityApi = '$apiBaseUrl/rest/$selectedLanguage/V1/vendors/me/stockItems/';
 String vendorsProductDeleteMediaApi = '$apiBaseUrl/rest/$selectedLanguage/V1/vendors/product/';
 String sendOTPApi = '$apiBaseUrl/rest/$selectedLanguage/V1/whatsapp/otp/send';
String verifyOTPApi = '$apiBaseUrl/rest/$selectedLanguage/V1/whatsapp/otp/verify';
String forgotPasswordApi = '$apiBaseUrl/rest/$selectedLanguage/V1/customers/password';
