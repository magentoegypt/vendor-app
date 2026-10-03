import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_vendor/common/app_logo.dart';
import 'package:multi_vendor/core/config/app_constants.dart';
import 'package:multi_vendor/features/auth/api_login_feature/bloc/login_bloc.dart';
import 'package:multi_vendor/features/auth/api_login_feature/data/login_repository.dart';
import 'package:multi_vendor/features/auth/api_login_feature/view/login_view.dart';
import 'package:multi_vendor/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// QA's example for DEV15: the logo at 38% of the screen width and the
/// "ME Hub Market" title at 20, smaller but still in place.
void main() {
  for (final phone in const [Size(320, 640), Size(360, 800), Size(411, 890)]) {
    testWidgets(
        'login on a ${phone.width.toInt()} wide phone: the logo and title '
        'have QA\'s sizes and the screen fits', (tester) async {
      tester.view.physicalSize = phone * 2;
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.reset);
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(BlocProvider<LoginBloc>(
        create: (_) => LoginBloc(repository: LoginRepository()),
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SignInView(),
        ),
      ));
      await tester.pump();

      final logo = tester.getSize(find.byType(AppLogo));
      expect(logo.width, closeTo(phone.width * 0.38, 0.01));
      expect(logo.height, closeTo(phone.width * 0.3, 0.01));
      expect(tester.widget<Text>(find.text(kAppName)).style?.fontSize, 20);
      // No overflow, even on the narrowest phone.
      expect(tester.takeException(), isNull);
    });
  }
}
