/// Phone numbers as the vendor screens handle them: the field holds the local
/// number (10 digits for Egypt, no trunk 0) and requests send the dial code
/// followed by that number, while the backend may keep a leading "+".
class PhoneNumber {
  PhoneNumber._();

  /// The local number from a saved telephone, whatever form the backend kept:
  /// "+201002004488", "201002004488" and "01002004488" all give "1002004488".
  static String local(String? telephone, {String dialCode = '+20'}) {
    final code = digits(dialCode);
    var number = digits(telephone);
    if (code.isNotEmpty && number.startsWith(code) && number.length > 10) {
      number = number.substring(code.length);
    }
    return number.startsWith('0') ? number.substring(1) : number;
  }

  /// Whether two telephones are the same number, ignoring "+" and spacing.
  static bool same(String? a, String? b) => digits(a) == digits(b);

  static String digits(String? value) =>
      (value ?? '').replaceAll(RegExp(r'\D'), '');
}
