import 'package:flutter_test/flutter_test.dart';
import 'package:multi_vendor/core/utils/phone_number.dart';

void main() {
  group('Vendor profile phone (14zb93nufcj)', () {
    test('the saved +20 number loads as the 10-digit local number', () {
      // The backend keeps "+201002004488"; cutting two characters left
      // "01002004488", which the profile update then refused.
      expect(PhoneNumber.local('+201002004488'), '1002004488');
      expect(PhoneNumber.local('201002004488'), '1002004488');
      expect(PhoneNumber.local('01002004488'), '1002004488');
      expect(PhoneNumber.local('1002004488'), '1002004488');
      expect(PhoneNumber.local(null), '');
    });

    test('an unchanged number is not treated as a new one', () {
      // Update sends "20" + local number; the saved one starts with "+".
      expect(PhoneNumber.same('201002004488', '+201002004488'), isTrue);
      expect(PhoneNumber.same('201002004489', '+201002004488'), isFalse);
    });
  });

  group('Seller profile phone (14zb93nv6vw)', () {
    test('every form the backend accepts is the same number, so no code is asked for',
        () {
      // What the update builds against each form a profile may have kept.
      for (final saved in ['+20 111 400 7802', '+201114007802', '201114007802',
          '01114007802', '1114007802']) {
        expect(PhoneNumber.same('201114007802', saved), isTrue, reason: saved);
      }
      expect(PhoneNumber.same('201114007803', '01114007802'), isFalse);
      expect(PhoneNumber.same('201114007802', null), isFalse);
    });
  });
}
