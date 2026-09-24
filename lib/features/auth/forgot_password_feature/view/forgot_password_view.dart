import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/ToggleButton.dart';
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
import '../../reset_password_feature/view/reset_password_view.dart';
import '../bloc/forgot_password_bloc.dart';


class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({
    Key? key,
  }) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {

  bool isLoginOTP = true;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final SharedPreferencesHelpers _sharedPrefKeys = SharedPreferencesHelpers();
  CountryCode? countryCode;
  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
    _sharedPrefKeys.setIntData(key: initScreenPrefKey, id: 0);
    countryCode = CountryCode(
      code: "EG",
      dialCode: "+20",
      name: "Egypt",
    );
    // countryCode = CountryCode(
    //   code: "PK",
    //   dialCode: "+92",
    //   name: "Egypt",
    // );
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,//Theme.of(context).colorScheme.background,
      ),
      body:SafeArea(
        child: GestureDetector(
          onTap: () => Tools.hideKeyboard(context),
          child:  SingleChildScrollView(
            child: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
              listener: (context, state) async {
                if (state is ForgotPasswordLoading) {
                  LoadingScreen().show(
                    context: context,
                    text: 'Please wait a moment',
                  );
                } else {
                  LoadingScreen().hide();
                }

                if (state is SendMobileOTPLoaded) {
                  if(state.mobileOTPModel.status == "success"){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ResetPasswordView(phoneNumber: '${countryCode?.dialCode?.replaceAll("+", "")}${_emailController.text.trim()}',)),
                    );
                  }else{
                    Tools.showSnackBar(ScaffoldMessenger.of(context), state.mobileOTPModel.message);
                  }
                }else if (state is ForgotPasswordLoaded) {
                  if(state.mobileOTPModel.status == "success"){
                    Tools.showSnackBar(ScaffoldMessenger.of(context), state.mobileOTPModel.message);
                    Navigator.of(context).pop();
                  }else{
                    Tools.showSnackBar(ScaffoldMessenger.of(context), AppLocalizations.of(context)!.somethingWrong);
                  }
                }
                if (state is ForgotPasswordError) {
                  Tools.showSnackBar(ScaffoldMessenger.of(context), state.errorMessage);
                }
              },
              child:Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 100),
                    Text(
                      AppLocalizations.of(context)!.resetForgotPassword,
                      style: TextStyle(
                          fontSize: 30.0, color: Theme.of(context).primaryColor),
                    ),
                    const SizedBox(
                      height: 40.0,
                    ),
                    const Icon(
                      Icons.vpn_key,
                      color: Colors.orangeAccent,
                      size: 70.0,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ToggleButton(
                        width: MediaQuery.of(context).size.width,
                        height: 60.0,
                        toggleBackgroundColor: Colors.white,
                        toggleBorderColor: (Colors.grey[350])!,
                        toggleColor: (Colors.indigo[900])!,
                        activeTextColor: Colors.white,
                        inactiveTextColor: Colors.grey,
                        leftDescription: AppLocalizations.of(context)!.phone,
                        rightDescription: AppLocalizations.of(context)!.email,
                        onLeftToggleActive: () {
                          setState(() {
                            isLoginOTP = true;
                          });
                        },
                        onRightToggleActive: () {
                          setState(() {
                            isLoginOTP = false;
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
                    const SizedBox(height: 20),
                    if(!isLoginOTP)
                      EditProductInfoWidget(
                        label: AppLocalizations.of(context)!.username,
                        fontSize: 12.0,
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                      ),
                    const SizedBox(height: 50.0),
                    InkWell(
                      onTap: () {
                        // One tap, one request: Magento rate-limits resets, so
                        // a repeat while the first is in flight uses up the
                        // allowance and fails.
                        if (context.read<ForgotPasswordBloc>().state is ForgotPasswordLoading) return;
                        if(_allValidation()){
                          if(isLoginOTP){
                            Map<String, dynamic> params = {
                              "mobile":"${countryCode?.dialCode?.replaceAll("+", "")}${_emailController.text.trim()}",
                              "type": "VENDOR_FORGOTPASS"
                            };
                            context.read<ForgotPasswordBloc>().add(
                              PerformSendMobileOTP(
                                requestValueMap: params,
                              ),
                            );
                          }else{
                            Map<String, dynamic> ForgotPasswordMap = {
                              "email": _emailController.text.trim(),
                              "template": "email_reset"
                            };
                            /// init ForgotPassword event
                            context.read<ForgotPasswordBloc>().add(
                              PerformForgotPassword(
                                requestValueMap: ForgotPasswordMap,
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
                            isLoginOTP ? AppLocalizations.of(context)!.sendSMSCode:AppLocalizations.of(context)!.getPasswordLink,
                            style: const TextStyle(color: Colors.white),
                          ),
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
    }else{
      if (_emailController.text.trim().isEmpty) {
        Tools.showSnackBar(ScaffoldMessenger.of(context), AppLocalizations.of(context)!.emailrequired);
        isValid = false;
      } else if (!Validator.validateEmail(_emailController.text.trim())) {
        Tools.showSnackBar(ScaffoldMessenger.of(context), AppLocalizations.of(context)!.invalidEmail);
        isValid = false;
      }
    }
    return isValid;
  }
}