import 'package:flutter/services.dart';

/// Converts Arabic-Indic (٠-٩) and Persian (۰-۹) digits to ASCII, so numbers
/// typed on an Arabic keyboard reach the API as plain digits.
String normalizeDigits(String input) {
  final buffer = StringBuffer();
  for (final rune in input.runes) {
    if (rune >= 0x0660 && rune <= 0x0669) {
      buffer.writeCharCode(0x30 + rune - 0x0660);
    } else if (rune >= 0x06F0 && rune <= 0x06F9) {
      buffer.writeCharCode(0x30 + rune - 0x06F0);
    } else {
      buffer.writeCharCode(rune);
    }
  }
  return buffer.toString();
}

/// Accepts digits in any of the scripts above and, when [decimal] is set, one
/// decimal separator ("." "," or the Arabic "٫"). The field keeps ASCII digits
/// and "." so the value can be parsed and sent to Magento as a number.
class NumericInputFormatter extends TextInputFormatter {
  NumericInputFormatter({this.decimal = true});

  final bool decimal;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = normalizeDigits(newValue.text);
    if (decimal) text = text.replaceAll(RegExp('[,٫]'), '.');
    final pattern = decimal ? RegExp(r'^\d*\.?\d*$') : RegExp(r'^\d*$');
    if (!pattern.hasMatch(text)) return oldValue;
    // Every replacement is one UTF-16 unit for one, so the selection stays valid.
    return newValue.copyWith(text: text);
  }
}
