import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_vendor/features/ChangeLanguage/LanguageScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/config/locator.dart';
import '../../core/config/pref_keys.dart';
import '../../core/helper/shared_preferences_helpers.dart';
import '../../main.dart';
import '../auth/api_login_feature/view/login_view.dart';
import '../home/view/dashboard_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  /// init Screen bool
  /// check if it is first time App is launched by user
  int? initScreen;
  int? isFirstLaunch;

  bool _visible = false;
  final SharedPreferencesHelpers _sharedPrefKeys = SharedPreferencesHelpers();

  @override
  void initState() {
    super.initState();
    getIsOnboarding();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);


    Future.delayed(const Duration(seconds: 4), () {
      isFirstLaunch == 0 || isFirstLaunch == null ? _showSimpleDialog():
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => initScreen == 0 || initScreen == null
                ? isFirstLaunch == 0 || isFirstLaunch == null ? const LanguageScreen():const SignInView()
                : const DashboardWidget(),
          ),
          (e) => false);
    });
  }

  void getIsOnboarding() async {
    /// Setting an Int value for initScreen
    /// To show the Intro Screens at Start
    initScreen = await _sharedPrefKeys.getIntData(key: initScreenPrefKey);
    isFirstLaunch = await _sharedPrefKeys.getIntData(key: isFirstLaunchPrefKey);
  }

  // Navigate Away to Next Screen
  void navigateAwayFromSplash() async {
    if (initScreen == 0 || initScreen == null) {
    } else {}
  }

  _getVideoBackground() {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 1000),
      child: Container(),
    );
  }

  _getBackgroundColor() {
    return Container(color: Colors.transparent //.withAlpha(120),
        );
  }

  _getContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            _getVideoBackground(),
             Image(
              image: const AssetImage('assets/images/ic_splash.png'),
               fit:BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            )
          ],
        ),
      ),
    );
  }
  void _showSimpleDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,

      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: Color(0xffEADEB9),
          surfaceTintColor: Colors.transparent,
          title: Text(AppLocalizations.of(context)!.selectLanguage),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
                MainApp.setLocale(context, Locale("en", ""));
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => initScreen == 0 || initScreen == null
                          ? const SignInView()
                          : const DashboardWidget(),
                    ),
                        (e) => false);
              },
              child: Text('English'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
                // Handle Option 2 action
                MainApp.setLocale(context, Locale("ar", ""));
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => initScreen == 0 || initScreen == null
                          ? const SignInView()
                          : const DashboardWidget(),
                    ),
                        (e) => false);
              },
              child: Text('عربي'),
            ),
            // SimpleDialogOption(
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            //   child: Text(AppLocalizations.of(context)!.cancel),
            // ),
          ],
        );
      },
    );
  }
}
