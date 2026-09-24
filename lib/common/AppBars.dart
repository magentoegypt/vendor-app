
import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/config/locator.dart';
import '../features/auth/api_login_feature/view/login_view.dart';
import '../main.dart';



class AppBars extends AppBar {

  AppBars(BuildContext context,GlobalKey<ScaffoldState> _scaffoldKey,String screenTitle,bool isFromMv,bool isHomeEnable):super(
    iconTheme: IconThemeData(
      color: Colors.black, //change your color here
    ),
    backgroundColor: Colors.white,
    title: Text(
      screenTitle,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: Theme.of(context)
              .colorScheme.primary,fontSize: 17),
    ),
    centerTitle: true,
    elevation: 0.0,
    automaticallyImplyLeading: false,
    leading: isFromMv ? IconButton(
      icon: Icon(Icons.arrow_back_ios_outlined),
      onPressed: () {
        Navigator.of(context).pop();
      },
    ):
    IconButton(
      icon: Icon(Icons.menu),
      onPressed: () {
        print("press");
        _scaffoldKey.currentState!.openDrawer();
      },
    ),
    actions: <Widget>[
      // IconButton(
      //   icon: Icon(Icons.notifications),
      //   onPressed: () {
      //
      //   },
      // ),
      IconButton(
        icon: Icon(Icons.logout),
        onPressed: () {
          _exitApp(context);
        },
      ),
    ],
  );


  void exitA(){

  }

  static  _exitApp(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(AppLocalizations.of(context)!.confirmation),
            content: new Text(AppLocalizations.of(context)!.logout_message),
            actions: <Widget>[
              new TextButton(
                onPressed: () => Navigator.pop(context), // Closes the dialog
                child: new Text(AppLocalizations.of(context)!.no),
              ),
              new TextButton(
                onPressed: () {
                  Navigator.pop(context); // Closes the dialog
                  Navigator.pushAndRemoveUntil(
                      navigatorKey.currentState!.context,
                      MaterialPageRoute(

                        builder: (context) => const SignInView(),
                      ),
                          (e) => false);
                },
                child: new Text(AppLocalizations.of(context)!.yes),
              ),
            ],
          );
        }
    );
  }
}

// Theme.of(context).textTheme.bodyText1!.copyWith(
// fontWeight: FontWeight.bold,
// fontStyle: FontStyle.italic,
// color: Colors.blue, // overriding color
// ),