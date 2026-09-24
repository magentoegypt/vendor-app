import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_vendor/features/auth/forgot_password_feature/view/forgot_password_view.dart';
import '../../../../common/PasswordController.dart';
import '../../../../common/ToggleButton.dart';
import '../../../../common/otp_dialog.dart';
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
import '../bloc/login_bloc.dart';


class SignInView extends StatefulWidget {
  const SignInView({
    Key? key,
  }) : super(key: key);

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {

  bool isLoginOTP = true;
  CountryCode? countryCode;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final SharedPreferencesHelpers _sharedPrefKeys = SharedPreferencesHelpers();

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
    _sharedPrefKeys.setIntData(key: initScreenPrefKey, id: 0);
    _sharedPrefKeys.setIntData(key: isFirstLaunchPrefKey, id: 1);
    countryCode = CountryCode(
      code: "EG",
      dialCode: "+20",
      name: "Egypt",
    );
   // setDummyValues();
  }

  void setDummyValues() {
    setState(() {
      // _emailController.text = 'walmart@magento2.com';
      // _passwordController.text = 'walmart23&';
      // _emailController.text = "test2@mailinator.com";
      // _passwordController.text = 'P@ssw0rd99999';
      // _emailController.text = "amira@magentoegypt.com";
      // _passwordController.text = 'amira@123';
      //magentotester2@gmail.com
      // tester2@123
      //amira@magentoegypt.com
      //amira@123
     _emailController.text = "malk09060@gmail.com";
     _passwordController.text = 'malk09060@123';

    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body:SafeArea(
        child: GestureDetector(
          onTap: () => Tools.hideKeyboard(context),
          child:  SingleChildScrollView(
            child: BlocListener<LoginBloc, LoginState>(
              listener: (context, state) async {
                if (state is LoginLoading) {
                  LoadingScreen().show(
                    context: context,
                    text: 'Please wait a moment',
                  );
                } else {
                  LoadingScreen().hide();
                }

                if (state is LoginLoaded) {
                  Tools.showSnackBar(ScaffoldMessenger.of(context), AppLocalizations.of(context)!.login_message);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DashboardWidget()
                      ),
                          (e) => false);
                }else if (state is SendMobileOTPLoaded) {
                  if(state.mobileOTPModel.status == "success"){
                    if(!OtpDialog.isDialogOpen){
                      OtpDialog.showOtpDialog(context, "${countryCode?.dialCode?.replaceAll("+", "")}${_emailController.text.trim()}",((otpCode,actionFrom){
                        if(actionFrom == "resend"){
                          Map<String, dynamic> params = {
                            "mobile":"${countryCode?.dialCode?.replaceAll("+", "")}${_emailController.text.trim()}",
                            "type": "VENDOR_LOGIN"
                          };
                          context.read<LoginBloc>().add(
                            PerformSendMobileOTP(
                              requestValueMap: params,
                            ),
                          );
                        }else{
                          Map<String, dynamic> params = {
                            "mobile":"${countryCode?.dialCode?.replaceAll("+", "")}${_emailController.text.trim()}",
                            "type": "VENDOR_LOGIN"
                            ,"otp": otpCode,
                            "password": ""
                          };
                          context.read<LoginBloc>().add(
                            PerformVerifyMobileOTP(
                              requestValueMap: params,
                            ),
                          );
                        }
                      }));
                    }
                  }else{
                    Tools.showSnackBar(ScaffoldMessenger.of(context), state.mobileOTPModel.message);
                  }

                }else if (state is VerifyMobileOTPLoaded) {
                  if(state.mobileOTPModel.status == "success"){
                    Tools.showSnackBar(ScaffoldMessenger.of(context), AppLocalizations.of(context)!.login_message);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DashboardWidget()
                        ),
                            (e) => false);
                  }else{
                    Tools.showSnackBar(ScaffoldMessenger.of(context), state.mobileOTPModel.message);
                  }
                }

                if (state is LoginError) {
                  Tools.showSnackBar(ScaffoldMessenger.of(context), state.errorMessage);
                }
              },
              child:Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    FluxImage(
                      imageUrl: kAppLogo,
                      fit: BoxFit.contain,
                      width: size.width / 2,
                      height: size.height / 4,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      kAppName,
                      style: const TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ToggleButton(
                        width: MediaQuery.of(context).size.width,
                        height: 70.0,
                        toggleBackgroundColor: Colors.white,
                        toggleBorderColor: (Colors.grey[350])!,
                        toggleColor: (Colors.indigo[900])!,
                        activeTextColor: Colors.white,
                        inactiveTextColor: Colors.grey,
                        leftDescription: AppLocalizations.of(context)!.loginWithOTP,
                        rightDescription: AppLocalizations.of(context)!.loginWithPassword,
                        onLeftToggleActive: () {
                          setState(() {
                            isLoginOTP = true;
                            _emailController.text = "";
                          });
                        },
                        onRightToggleActive: () {
                          setState(() {
                            isLoginOTP = false;
                            _emailController.text = "";
                          });
                        },
                      ),
                    ),
                    if(isLoginOTP)
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            AbsorbPointer(
                              absorbing: true,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 35.0),
                                child: CountryCodePicker(
                                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                  onChanged: (country) {
                                    setState(() {
                                      countryCode = country;
                                    });
                                  },
                                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                  initialSelection: countryCode?.code ?? "eg",

                                  //Get the country information relevant to the initial selection
                                  onInit: (code) {
                                    countryCode = code;
                                  },
                                  //Get the country information relevant to the initial selection
                                  backgroundColor:
                                  Theme.of(context).colorScheme.background,
                                  dialogBackgroundColor:
                                  Theme.of(context).dialogBackgroundColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 2.0),
                            Expanded(child: EditProductInfoWidget(
                              label: AppLocalizations.of(context)!.phoneNumber,
                              fontSize: 12.0,
                              keyboardType: TextInputType.phone,
                              controller: _emailController,
                            ),)
                          ],
                        ),
                      ),
                    if(!isLoginOTP)...[
                      EditProductInfoWidget(
                        label: AppLocalizations.of(context)!.username,
                        fontSize: 12.0,
                        controller: _emailController,
                      ),
                      const SizedBox(height: 15),
                      PasswordController(
                        label: AppLocalizations.of(context)!.password,
                        controller: _passwordController,
                      ),
                    ],
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ForgotPasswordView()),
                          );
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            AppLocalizations.of(context)!.resetPassword,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .primaryColor,
                              decoration:
                              TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if(_allValidation()){
                          if(isLoginOTP){
                            Map<String, dynamic> params = {
                              "mobile":"${countryCode?.dialCode?.replaceAll("+", "")}${_emailController.text.trim()}",
                              "type": "VENDOR_LOGIN"
                            };
                            /// init Login event
                            context.read<LoginBloc>().add(
                              PerformSendMobileOTP(
                                requestValueMap: params,
                              ),
                            );
                          }else{
                            Map<String, dynamic> loginMap = {
                              "username": _emailController.text,
                              "password": _passwordController.text.trim(),
                            };
                            /// init Login event
                            context.read<LoginBloc>().add(
                              PerformUserLogin(
                                requestValueMap: loginMap,
                              ),
                            );
                          }
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
                            isLoginOTP ?  AppLocalizations.of(context)!.sendSMSCode:AppLocalizations.of(context)!.signInWithEmail,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        NavigationServices(context).gotoRegisterView();
                      },
                      child: Text(
                        AppLocalizations.of(context)!.createAnAccount,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          decoration: TextDecoration.underline,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
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
    if(isLoginOTP){
      if(_emailController.text.trim().isEmpty){
        Tools.showSnackBar(ScaffoldMessenger.of(context), AppLocalizations.of(context)!.enterMobile);
        isValid = false;
      }else if(_emailController.text.trim().startsWith("0")){
        Tools.showSnackBar(ScaffoldMessenger.of(context), AppLocalizations.of(context)!.validMobileWithout0);
        isValid = false;
      }else if(_emailController.text.trim().length != 10){
        Tools.showSnackBar(ScaffoldMessenger.of(context), AppLocalizations.of(context)!.validMobile);
        isValid = false;
      }
    }else {
      if (_emailController.text
          .trim()
          .isEmpty) {
        Tools.showSnackBar(ScaffoldMessenger.of(context),
            AppLocalizations.of(context)!.emailrequired);
        isValid = false;
      } else if (!Validator.validateEmail(_emailController.text.trim())) {
        Tools.showSnackBar(ScaffoldMessenger.of(context),
            AppLocalizations.of(context)!.invalidEmail);
        isValid = false;
      } else if (_passwordController.text
          .trim()
          .isEmpty) {
        Tools.showSnackBar(ScaffoldMessenger.of(context),
            AppLocalizations.of(context)!.passwordrequired);
        isValid = false;
      }
    }
    return isValid;
  }
}
