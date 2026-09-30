import 'package:flutter/widgets.dart';

/// Digits in the app language's numeral system: Arabic-Indic in Arabic,
/// Western otherwise. The server writes the dashboard amounts that way for
/// each language, and QA's TC75 asks the other Dashboard numbers (Total
/// Products, the chart axes) to follow the app language too.
class Numerals {
  Numerals._();

  /// [text] with its Western digits written for [languageCode].
  static String forLanguage(String text, String languageCode) {
    if (languageCode != 'ar') return text;
    return text.replaceAllMapped(
        RegExp(r'[0-9]'), (digit) => String.fromCharCode(0x0660 + int.parse(digit[0]!)));
  }

  /// [text] with its digits written for the app's current language.
  static String of(BuildContext context, String text) =>
      forLanguage(text, Localizations.localeOf(context).languageCode);
}
