import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../common/PasswordController.dart';
import '../../../../core/config/pref_keys.dart';
import '../../../../common/edit_product_info_widget.dart';
import '../../../../common/flux_image.dart';
import '../../../../core/config/app_constants.dart';
import '../../../../core/config/locator.dart';
import '../../../../core/config/tools.dart';
import '../../../../core/helper/loading_screen.dart';
import '../../../../core/helper/shared_preferences_helpers.dart';
import '../../../../core/utils/validator.dart';
import '../../../../services/navigation_service/navigation_service.dart';
import '../../../home/view/dashboard_widget.dart';
import '../bloc/reset_password_bloc.dart';


class ResetPasswordView extends StatefulWidget {
  String phoneNumber;
   ResetPasswordView({
    Key? key,
    required this.phoneNumber
  }) : super(key: key);

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  bool isPasswordObscure = true;
  final TextEditingController passwordController =
  TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();

  }



  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    pinCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
      ),
      body:SafeArea(
        child: GestureDetector(
          onTap: () => Tools.hideKeyboard(context),
          child: LayoutBuilder(
            builder: (context, viewport) => SingleChildScrollView(
            // As on the login page: anchored at the bottom so the fields and
            // the submit button stay above the keyboard.
            reverse: true,
            child: ConstrainedBox(
            // At least a screen tall, so the page still starts at the top
            // while the keyboard is closed.
            constraints: BoxConstraints(minHeight: viewport.maxHeight),
            child: BlocListener<ResetPasswordBloc, ResetPasswordState>(
              listener: (context, state) async {
                if (state is ResetPasswordLoading) {
                  LoadingScreen().show(
                    context: context,
                    text: 'Please wait a moment',
                  );
                } else {
                  LoadingScreen().hide();
                }
                if (state is VerifyMobileOTPLoaded) {
                  if(state.mobileOTPModel.status == "success") {
                    Tools.showSnackBar(ScaffoldMessenger.of(context),
                        AppLocalizations.of(context)!.password_changeSuccess);
                    Navigator.of(context)..pop()..pop();
                  }else{
                    Tools.showSnackBar(ScaffoldMessenger.of(context), state.mobileOTPModel.message);
                  }
                }
                if (state is ResetPasswordError) {
                  Tools.showSnackBar(ScaffoldMessenger.of(context), state.errorMessage);
                }
              },
              child:Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      AppLocalizations.of(context)!.resetForgotPassword,
                      style: TextStyle(
                          fontSize: 30.0, color: Theme.of(context).primaryColor),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(vertical: 4),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: RichText(
                          text: TextSpan(
                            text: AppLocalizations.of(context)!.enterSendedCode,
                            children: [
                              TextSpan(
                                text: Tools.isRTL(context)
                                    ? ' ${widget.phoneNumber.replaceAll('+', '')}+'
                                    : ' +${widget.phoneNumber.replaceAll('+', '')}',
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
                    const SizedBox(
                      height: 20.0,
                    ),
                    Directionality(
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
                    const SizedBox(height: 20),
                    PasswordController(
                      label: AppLocalizations.of(context)!.password,
                      controller: passwordController,
                    ),
                    const SizedBox(height: 25),
                    PasswordController(
                      label: AppLocalizations.of(context)!.confirmPassword,
                      controller: confirmPasswordController,
                    ),
                    const SizedBox(height: 50.0),
                    InkWell(
                      onTap: () {
                        if(_allValidation()){
                          Map<String, dynamic> params = {
                            "mobile":widget.phoneNumber,
                            "type": "VENDOR_FORGOTPASS"
                            ,"otp": pinCodeController.text.trim(),
                            "password": passwordController.text.trim()
                          };
                          context.read<ResetPasswordBloc>().add(
                            PerformVerifyMobileOTP(
                              requestValueMap: params,
                            ),
                          );
                        }
                      },
                      child: Container(
                        height: 44,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.setnewpassword.toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                  ],
                ),
              ),
            ),
            ),
            ),
          ),
        ),
      ),
    );
  }

  bool _allValidation() {
    bool isValid = true;
    if (pinCodeController.text.trim().length != 6) {
      Tools.showSnackBar(ScaffoldMessenger.of(context), AppLocalizations.of(context)!.validOTP);
      isValid = false;
    }else if (passwordController.text.trim().length < 8) {
      Tools.showSnackBar(ScaffoldMessenger.of(context), AppLocalizations.of(context)!.errorPasswordFormat);
      isValid = false;
    }else if(passwordController.text.trim() != confirmPasswordController.text.trim()){
      Tools.showSnackBar(ScaffoldMessenger.of(context), AppLocalizations.of(context)!.passwordNotMatch);
      isValid = false;
    }
    return isValid;
  }
}
