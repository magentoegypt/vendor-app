import 'package:flutter_test/flutter_test.dart';
import 'package:multi_vendor/features/Products/CreateEditProduct/data/ProductAttributeModel.dart';

void main() {
  // The Enable Product options as the attribute API sends them.
  final status = [
    Options(label: 'Enabled', value: '1'),
    Options(label: 'Disabled', value: '2'),
  ];

  group('Enable Product (14zb93nv5v7)', () {
    test('a disabled product opens as Disabled, not the first option', () {
      // The product's status is an int; the options' values are strings.
      expect(optionLabelFor(status, 2), 'Disabled');
      expect(optionLabelFor(status, 1), 'Enabled');
    });

    test('an unknown or missing status picks nothing', () {
      expect(optionLabelFor(status, 9), isNull);
      expect(optionLabelFor(status, null), isNull);
      expect(optionLabelFor(null, 1), isNull);
    });

    test('the chosen label maps back to the value that is saved', () {
      expect(optionValueFor(status, 'Disabled'), '2');
      expect(optionValueFor(status, 'Archived'), isNull);
    });
  });
}
