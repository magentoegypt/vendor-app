import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_vendor/common/edit_product_info_widget.dart';
import 'package:multi_vendor/common/otp_dialog.dart';
import 'package:multi_vendor/features/auth/api_login_feature/bloc/login_bloc.dart';
import 'package:multi_vendor/features/auth/api_login_feature/data/login_repository.dart';
import 'package:multi_vendor/features/auth/api_login_feature/view/login_view.dart';
import 'package:multi_vendor/features/auth/forgot_password_feature/data/MobileOTPModel.dart';
import 'package:multi_vendor/l10n/app_localizations.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

const sentByWhatsApp = 'OTP sent successfully. Please check your WhatsApp.';

/// The server's answer to every code asked for: sent by WhatsApp, the only
/// channel there is (TC76).
class WhatsAppCodes extends LoginRepository {
  int sent = 0;

  @override
  Future<MobileOTPModel> sendMobileOTP({
    required Map<String, dynamic> requestValueMap,
  }) async {
    sent++;
    return MobileOTPModel(status: 'success', message: sentByWhatsApp);
  }
}

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
      final texts = lookupAppLocalizations(locale);
      final resendLine = tester
          .widgetList<RichText>(find.byType(RichText))
          .firstWhere((r) => r.text.toPlainText().contains(texts.resend));
      expect(resendLine.text.style?.color, isNotNull);
      expect(resendLine.text.style?.color, isNot(Colors.white));
      // Codes come by WhatsApp only (TC76): the dialog says so, with the
      // number, and offers no SMS autofill, which never fills it.
      expect(find.text(texts.codeSentToWhatsApp('\u2066+201000000000\u2069')), findsOneWidget);
      expect(texts.codeSentToWhatsApp(''), contains(locale.languageCode == 'ar' ? 'واتساب' : 'WhatsApp'));
      final codeField = tester.widget<TextField>(find.descendant(
          of: find.byType(PinCodeTextField), matching: find.byType(TextField)));
      expect(codeField.autofillHints, isNull);
      OtpDialog.isDialogOpen = false;
    });
  }

  testWidgets('a code sent shows the server\'s words, again after Resend (TC76)',
      (tester) async {
    tester.view.physicalSize = const Size(720, 1600);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({});
    final codes = WhatsAppCodes();
    await tester.pumpWidget(BlocProvider<LoginBloc>(
      create: (_) => LoginBloc(repository: codes),
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: const SignInView(),
      ),
    ));
    await tester.pump();

    await tester.enterText(
        find.descendant(
            of: find.byWidgetPredicate(
                (w) => w is EditProductInfoWidget && w.label == 'Phone number'),
            matching: find.byType(TextField)),
        '1000000000');
    await tester.tap(find.text('Get code'));
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(codes.sent, 1);
    expect(find.text('We sent a 6-digit code to your WhatsApp at \u2066+201000000000\u2069.'),
        findsOneWidget);
    expect(find.text(sentByWhatsApp), findsOneWidget);

    // The message goes after a few seconds; Resend, with the dialog open,
    // used to show nothing at all.
    for (var i = 0; i < 12; i++) {
      await tester.pump(const Duration(milliseconds: 500));
    }
    expect(find.text(sentByWhatsApp), findsNothing);
    await tester.tapOnText(find.textRange.ofSubstring('resend'));
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(codes.sent, 2);
    expect(find.text(sentByWhatsApp), findsOneWidget);
    OtpDialog.isDialogOpen = false;
  });
}
