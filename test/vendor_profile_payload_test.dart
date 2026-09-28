import 'package:flutter_test/flutter_test.dart';
import 'package:multi_vendor/features/auth/register_feature/data/CountryListModel.dart';
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

  group('Seller profile (14zb93nv6vw)', () {
    test("an unchanged number is left out, so the seller's own number is not a duplicate",
        () {
      final customer = vendor();

      expect(customer.toUpfateProfileJson(withTelephone: false).containsKey('telephone'), isFalse);
      expect(customer.toUpfateProfileJson()['telephone'], '201000000000');
    });

    test('a state picked from the list is sent with its id', () {
      final customer = vendor()
        ..region = 'Cairo'
        ..region_id = 1112;

      final payload = customer.toUpfateProfileJson();
      expect(payload['region'], 'Cairo');
      expect(payload['region_id'], 1112);
      expect((vendor()..region = 'Elbasan').toUpfateProfileJson().containsKey('region_id'), isFalse);
    });

    test("a country's states come from the store, and the saved one is found in them", () {
      final albania = CountryListModel.fromJson({
        'id': 'AL',
        'full_name_english': 'Albania',
        'available_regions': [
          {'id': '485', 'code': 'AL-03', 'name': 'Elbasan'},
          {'id': '486', 'code': 'AL-04', 'name': 'Fier'},
        ],
      });

      expect(albania.availableRegions.map((region) => region.name), ['Elbasan', 'Fier']);
      expect(albania.regionFor(regionId: 486)?.name, 'Fier');
      expect(albania.regionFor(region: 'elbasan')?.id, 485);
      expect(albania.regionFor(region: 'AL-04')?.name, 'Fier');
      expect(albania.regionFor(region: 'Cairo'), isNull);
      // A country the store has no list for keeps a text field.
      expect(CountryListModel.fromJson({'id': 'AE'}).availableRegions, isEmpty);
    });
  });
}
