

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguage extends ChangeNotifier {

  AppLanguage(Locale locale) : _appLocale = locale;

  Locale _appLocale;
  Locale get appLocal => _appLocale;

  Future<void> changeLanguage(String locale) async {
    var prefs = await SharedPreferences.getInstance();
    _appLocale = Locale(locale);
    await prefs.setString('language_code', locale);
    notifyListeners();
  }
}