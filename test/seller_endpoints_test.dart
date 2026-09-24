import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:multi_vendor/core/config/pref_keys.dart';
import 'package:multi_vendor/features/Products/CreateEditProduct/data/create_edit_product_api_service.dart';
import 'package:multi_vendor/features/auth/register_feature/data/SignUpModel.dart';
import 'package:multi_vendor/features/auth/register_feature/data/register_api_service.dart';
import 'package:multi_vendor/features/profile/data/profile_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

const vendorToken = 'vendor-token';
const vendorJson = '{"id": 4, "vendor_id": "shop4", "street": "1 Main St", "postcode": "12345"}';

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
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({authTokenPrefKey: vendorToken}));

  group('Seller-only endpoints replace the admin token', () {
    test('profile update is PUT /V1/vendors/me with the vendor token', () async {
      final server = FakeServer({
        'PUT /V1/vendors/me': (_) => http.Response(vendorJson, 200),
      });

      final vendor = await ProfileApiService(httpClient: server.client)
          .postUserProfileData(requestValueMap: {'vendor': {'city': 'Cairo'}});

      final request = server.requests.single;
      expect(request.headers['Authorization'], 'Bearer $vendorToken');
      expect(json.decode(request.body), {'vendor': {'city': 'Cairo'}});
      expect(vendor.street, '1 Main St');
    });

    test('profile update answering true reads the profile back', () async {
      final server = FakeServer({
        'PUT /V1/vendors/me': (_) => http.Response('true', 200),
        'GET /V1/vendors/me': (_) => http.Response(vendorJson, 200),
      });

      final vendor = await ProfileApiService(httpClient: server.client)
          .postUserProfileData(requestValueMap: {'vendor': {}});

      expect(server.requests.map((r) => r.method), ['PUT', 'GET']);
      expect(vendor.postcode, '12345');
    });

    test('profile update keeps the server error message', () async {
      final server = FakeServer({
        'PUT /V1/vendors/me': (_) => http.Response(
            '{"message":"\\"%fieldName\\" is invalid.","parameters":{"fieldName":"postcode"}}', 400),
      });

      expect(
        ProfileApiService(httpClient: server.client)
            .postUserProfileData(requestValueMap: {'vendor': {}}),
        throwsA(predicate((e) => '$e'.contains('"postcode" is invalid.'))),
      );
    });

    test('account deletion is DELETE /V1/vendors/me with the vendor token',
        () async {
      final server = FakeServer({
        'DELETE /V1/vendors/me': (_) => http.Response('true', 200),
      });

      final deleted =
          await ProfileApiService(httpClient: server.client).deleteVendorData();

      expect(deleted, isTrue);
      expect(server.requests.single.headers['Authorization'], 'Bearer $vendorToken');
    });

    test('stock and categories use the vendor token and the /me routes',
        () async {
      final server = FakeServer({
        'GET /V1/vendors/me/stockItems/shirt-1': (_) =>
            http.Response('{"item_id": 1, "qty": 7.0}', 200),
        'GET /V1/products/shirt-1': (_) =>
            http.Response('{"id": 9, "sku": "shirt-1", "price": 10.5}', 200),
        'GET /V1/vendors/me/categories': (_) => http.Response(
            '[{"id": 2, "name": "Root", "children_data": []}]', 200),
      });
      final service = CreateEditProductApiService(httpClient: server.client);

      final product = await service.getSingleProduct('shirt-1');
      final categories = await service.getProductCategories();

      expect(product.stockItemQunatityModel?.qty, 7);
      expect(categories.single['name'], 'Root');
      for (final request in server.requests) {
        expect(request.headers['Authorization'], 'Bearer $vendorToken');
      }
    });
  });

  group('Registration uses POST /V1/vendors/register', () {
    Customer applicant() => Customer()
      ..firstname = 'Test Vendor'
      ..email = 'v@x.test'
      ..password = 'secret'
      ..telephone = '1000000000';

    test('body carries vendor, password and the OTP registration token', () {
      final body = applicant().toRegisterRequest(
          telephone: '201000000000', registrationToken: 'reg-token');

      expect(body['password'], 'secret');
      expect(body['registrationToken'], 'reg-token');
      expect(body['vendor']['telephone'], '201000000000');
      expect((body['vendor'] as Map).containsKey('extension_attributes'), isFalse);
    });

    test('sends no Authorization header and accepts any 2xx body', () async {
      final server = FakeServer({
        'POST /V1/vendors/register': (_) => http.Response('true', 200),
      });

      await RegisterApiService(httpClient: server.client).postUserRegisterData(
          requestValueMap: applicant().toRegisterRequest(
              telephone: '201000000000', registrationToken: 'reg-token'));

      expect(server.requests.single.headers.containsKey('Authorization'), isFalse);
    });

    test('shows the server message for a rejected registration', () async {
      final server = FakeServer({
        'POST /V1/vendors/register': (_) => http.Response(
            '{"message":"The registration code has expired. Verify the phone again."}',
            400),
      });

      expect(
        RegisterApiService(httpClient: server.client)
            .postUserRegisterData(requestValueMap: {'vendor': {}}),
        throwsA(predicate((e) => '$e'.contains('registration code has expired'))),
      );
    });
  });
}
