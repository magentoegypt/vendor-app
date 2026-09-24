import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor/core/config/locator.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../core/config/tools.dart';



class OtpDialog  {

  static bool isDialogOpen = false;
  static void showOtpDialog(BuildContext context,String phoneNumber,Function(String,String) loginSms) {
    OtpDialog.isDialogOpen = true;
    var  onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        loginSms("", "resend");
      };
    final TextEditingController pinCodeController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String otp = '';

        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.phoneNumberVerification),
          content: Wrap(
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: RichText(
                    text: TextSpan(
                      text: AppLocalizations.of(context)!.enterSendedCode,
                      children: [
                        TextSpan(
                          text: Tools.isRTL(context)
                              ? ' ${phoneNumber.replaceAll('+', '')}+'
                              : ' +${phoneNumber.replaceAll('+', '')}',
                          style:
                          Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 15,
                          ),
                        ),
                      ],
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color
                            ?.withOpacity(0.54),
                        fontSize: 15,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: PinCodeTextField(
                    appContext: context,
                    controller: pinCodeController,
                    keyboardType: TextInputType.number,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.underline,
                      borderWidth: 2,
                      activeFillColor: Theme.of(context).colorScheme.background,
                      disabledColor: Theme.of(context).disabledColor,
                    ),
                    length: 6,
                    cursorHeight: 30,
                    autoFocus: true,
                    obscuringCharacter: '*',
                    textStyle: Theme.of(context)
                        .primaryTextTheme
                        .displaySmall!
                        .copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
                    animationType: AnimationType.scale,
                    hapticFeedbackTypes: HapticFeedbackTypes.light,
                    useHapticFeedback: true,
                    autoDisposeControllers: false,
                    animationDuration: const Duration(milliseconds: 300),
                    onChanged: (value) {
                      //  if (value.length == 6) _loginSMS(value, context);
                    },
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                alignment: Alignment.topRight,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: AppLocalizations.of(context)!.didntReceiveCode,
                      style: const TextStyle(fontSize: 15),
                      children: [
                        TextSpan(
                            text: AppLocalizations.of(context)!.resend,
                            recognizer: onTapRecognizer,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ))
                      ]),
                ),
              )
            ],
          ),
          actions: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    OtpDialog.isDialogOpen = false;
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    // Handle OTP submission
                    if (pinCodeController.text.trim().length == 6) {
                      OtpDialog.isDialogOpen = false;
                      Navigator.of(context).pop();
                      loginSms(pinCodeController.text, "verify");
                    }else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(AppLocalizations.of(context)!.validOTP)),
                      );
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.verifySMSCode),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

}