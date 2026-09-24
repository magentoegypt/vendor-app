import 'package:flutter_test/flutter_test.dart';
import 'package:multi_vendor/features/auth/register_feature/data/SignUpModel.dart';

Customer vendor({String? street, String? postcode}) => Customer()
  ..firstname = 'Test Vendor'
  ..company = 'Hub'
  ..city = 'Cairo'
  ..region = 'Giza'
  ..telephone = '201000000000'
  ..email = 'v@x.test'
  ..password = 'secret'
  ..street = street
  ..postcode = postcode;

void main() {
  group('Vendor profile fields (14zb93nufcj)', () {
    test('profile update and registration send street and postcode', () {
      final customer = vendor(street: ' 1 Main St ', postcode: '12345');

      for (final payload in [
        customer.toUpfateProfileJson(),
        customer.toRegisterJson(),
      ]) {
        expect(payload['street'], '1 Main St');
        expect(payload['postcode'], '12345');
      }
    });

    test('empty optional fields keep the previous payload shape', () {
      final customer = vendor(street: '  ', postcode: null);

      for (final payload in [
        customer.toUpfateProfileJson(),
        customer.toRegisterJson(),
      ]) {
        expect(payload.containsKey('street'), isFalse);
        expect(payload.containsKey('postcode'), isFalse);
        expect(payload['firstname'], 'Test');
        expect(payload['lastname'], 'Vendor');
      }
    });
  });
}
