import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_vendor/common/otp_dialog.dart';
import 'package:multi_vendor/l10n/app_localizations.dart';

void main() {
  for (final locale in const [Locale('en'), Locale('ar')]) {
    testWidgets(
        'the OTP dialog fits a 360 dp phone and shows every line '
        '(${locale.languageCode})', (tester) async {
      // The phone QA and the user test on: 720 px wide at 2x.
      tester.view.physicalSize = const Size(720, 1600);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => OtpDialog.showOtpDialog(
                  context, '+201000000000', (_, __) {}),
              child: const Text('open'),
            ),
          ),
        ),
      ));
      await tester.tap(find.text('open'));
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      // Six 40 dp boxes overflowed the dialog's 232 dp by 8 px, and the
      // Cancel/Verify row overflowed once the labels were wider.
      expect(tester.takeException(), isNull);
      // "Didn't receive the code?" was drawn white on the white dialog.
      final resend = lookupAppLocalizations(locale).resend;
      final resendLine = tester
          .widgetList<RichText>(find.byType(RichText))
          .firstWhere((r) => r.text.toPlainText().contains(resend));
      expect(resendLine.text.style?.color, isNotNull);
      expect(resendLine.text.style?.color, isNot(Colors.white));
    });
  }
}
