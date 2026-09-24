import 'package:flutter/material.dart';

import '../../features/auth/register_feature/view/register_view.dart';

class NavigationServices {
  NavigationServices(this.context);

  final BuildContext context;

  Future<dynamic> _pushMaterialPageRoute(Widget widget,
      {bool fullscreenDialog = false}) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => widget, fullscreenDialog: fullscreenDialog),
    );
  }

  Future<dynamic> _pushAndRemoveMaterialPageRoute(Widget widget) async {
    return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => widget),
        (Route<dynamic> route) => false);
  }

  // go to  Welcome  View Removing  All  Routes aka RAR
  Future<dynamic> gotoGenderSelectionScreenRAR() async {
    //return await _pushAndRemoveMaterialPageRoute(const GenderSelectionScreen());
  }

  // go to HomeScreen Removing AllRoutes aka RAR
  Future<dynamic> gotoHomeScreenRAR({required String gender}) async {
    //return await _pushAndRemoveMaterialPageRoute(HomeScreen(selectedGender: gender),);
  }

  // Go to Register View
  // Future<dynamic> gotoLoginView() async {
  //   return await _pushMaterialPageRoute(const LoginView());
  // }

  // Go to Register View
  Future<dynamic> gotoRegisterView() async {
    return await _pushMaterialPageRoute(const RegisterView());
  }

  //  Go to ForgotPasswordView
  // Future<dynamic> gotoForgotPasswordView() async {
  //   return await _pushMaterialPageRoute(const ForgotPasswordView());
  // }

  //  Go to HomeView
  // Future<dynamic> gotoHomeView() async {
  //   return await _pushAndRemoveMaterialPageRoute(const HomeView());
  // }
}
