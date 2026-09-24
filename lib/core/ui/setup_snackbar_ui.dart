import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

import '../config/colors.dart';
import '../enums/snackbar_type.dart';

void setupSnackbarUi() {
  final service = SnackbarService();

  // Registers a config to be used when calling showSnackbar
  service.registerSnackbarConfig(SnackbarConfig(
    backgroundColor: AppColors.twd_Off_Black,
    textColor: Colors.white,
    mainButtonTextColor: Colors.black,
  ));

  service.registerCustomSnackbarConfig(
    variant: SnackbarType.blueAndYellow,
    config: SnackbarConfig(
      snackStyle: SnackStyle.GROUNDED,
      backgroundColor: Colors.blueAccent,
      textColor: Colors.yellow,
      borderRadius: 1,
      dismissDirection: DismissDirection.horizontal,
    ),
  );

  service.registerCustomSnackbarConfig(
    variant: SnackbarType.greenAndRed,
    config: SnackbarConfig(
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      titleColor: Colors.green,
      messageColor: Colors.red,
      borderRadius: 1,
    ),
  );

  service.registerCustomSnackbarConfig(
    variant: SnackbarType.topMnatelier,
    config: SnackbarConfig(
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        messageColor: AppColors.twd_Off_Black,
        borderRadius: 1,
        messageText: Container(
          child: Center(
            child: Text("This is the message"),
          ),
        )),
  );
}
