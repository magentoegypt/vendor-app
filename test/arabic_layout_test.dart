import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_vendor/core/utils/bidi_text.dart';

/// Where [part] of the paragraph's text starts on screen, from the left.
double leftOf(WidgetTester tester, String part) {
  final paragraph = tester.renderObject<RenderParagraph>(find.byType(RichText));
  final text = paragraph.text.toPlainText();
  final start = text.indexOf(part);
  final boxes = paragraph.getBoxesForSelection(
      TextSelection(baseOffset: start, extentOffset: start + part.length));
  return boxes.first.left;
}

Future<void> showArabic(WidgetTester tester, String text) =>
    tester.pumpWidget(Directionality(
      textDirection: TextDirection.rtl,
      child: Center(child: Text(text)),
    ));

void main() {
  group('An English date in Arabic screens', () {
    const date = '28 Sep 2026, 03:24:28 AM';

    test('is wrapped in a left-to-right isolate', () {
      expect(BidiText.leftToRight(date), '\u2066$date\u2069');
      expect(BidiText.leftToRight(''), '');
    });

    testWidgets('as plain text, Arabic layout moves the day to the end',
        (tester) async {
      await showArabic(tester, date);
      expect(leftOf(tester, '28 '), greaterThan(leftOf(tester, 'Sep')));
    });

    testWidgets('kept left to right, it reads in order', (tester) async {
      await showArabic(tester, BidiText.leftToRight(date));
      expect(leftOf(tester, '28 '), lessThan(leftOf(tester, 'Sep')));
      expect(leftOf(tester, 'Sep'), lessThan(leftOf(tester, 'AM')));
    });
  });
}
