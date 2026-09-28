/// Left-to-right text, such as an English date, shown inside Arabic
/// (right-to-left) screens.
class BidiText {
  BidiText._();

  /// Keeps [text] in its own left-to-right order in Arabic layout, which
  /// otherwise moves a leading number to the end: "28 Sep 2026, 03:24:28 AM"
  /// read "Sep 2026, 03:24:28 AM 28". The text is wrapped in a left-to-right
  /// isolate (U+2066 ... U+2069), which changes nothing in English.
  static String leftToRight(String text) =>
      text.isEmpty ? text : '\u2066$text\u2069';
}
