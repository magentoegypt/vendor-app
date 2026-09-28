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

  /// Whether two telephones are the same number in any of the forms the
  /// backend accepts: "+20 100…", "20100…", "0100…" and "100…" are one number.
  /// Comparing the digits alone took a saved "01114007802" for a new number,
  /// so an unchanged number asked for a WhatsApp code, and got "Mobile number
  /// already exists." for the seller's own number.
  static bool same(String? a, String? b, {String dialCode = '+20'}) =>
      local(a, dialCode: dialCode) == local(b, dialCode: dialCode);

  static String digits(String? value) =>
      (value ?? '').replaceAll(RegExp(r'\D'), '');
}
