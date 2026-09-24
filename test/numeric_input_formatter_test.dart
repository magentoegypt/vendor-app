import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_vendor/core/utils/numeric_input_formatter.dart';

/// Simulates typing [text] into an empty field (caret at the end).
TextEditingValue type(TextInputFormatter formatter, String text,
    {String before = ''}) {
  return formatter.formatEditUpdate(
    TextEditingValue(
        text: before, selection: TextSelection.collapsed(offset: before.length)),
    TextEditingValue(
        text: text, selection: TextSelection.collapsed(offset: text.length)),
  );
}

void main() {
  group('Add product numeric fields (86d4b10r8)', () {
    test('normalizes Arabic-Indic and Persian digits', () {
      expect(normalizeDigits('١٢٣'), '123');
      expect(normalizeDigits('۴۵۶'), '456');
      expect(normalizeDigits('SKU-٧'), 'SKU-7');
    });

    test('price accepts Arabic digits and decimal separators', () {
      final price = NumericInputFormatter();
      expect(type(price, '٩٩٫٩٩').text, '99.99');
      expect(type(price, '99,5').text, '99.5');
      expect(type(price, '150').text, '150');
    });

    test('selection stays at the caret after normalization', () {
      final result = type(NumericInputFormatter(), '١٢');
      expect(result.selection, const TextSelection.collapsed(offset: 2));
    });

    test('rejects letters and a second decimal point', () {
      final price = NumericInputFormatter();
      expect(type(price, '12a', before: '12').text, '12');
      expect(type(price, '1.2.', before: '1.2').text, '1.2');
    });

    test('quantity accepts whole numbers only', () {
      final qty = NumericInputFormatter(decimal: false);
      expect(type(qty, '٥').text, '5');
      expect(type(qty, '5.', before: '5').text, '5');
    });
  });
}
