import 'dart:convert';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/edit_product_info_widget.dart';
import '../../../../common/otp_dialog.dart';
import '../../../../core/config/extensions.dart';
import '../../../../common/custom_text_field.dart';
import '../../../../common/flux_image.dart';
import '../../../../core/config/app_constants.dart';
import '../../../../core/config/colors.dart';
import '../../../../core/config/locator.dart';
import '../../../../core/config/tools.dart';
import '../../../../core/helper/loading_screen.dart';
import '../../../../core/utils/numeric_input_formatter.dart';
import '../../../../core/utils/validator.dart';
import '../bloc/register_bloc.dart';
import '../data/CountryListModel.dart';
import '../data/SignUpModel.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

  CountryCode? countryCode;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  late TextEditingController _passwordController = TextEditingController();
  late TextEditingController _repeatPasswordController = TextEditingController();

  final fullNameNode = FocusNode();
  final vendorIdNode = FocusNode();
  final companyNode = FocusNode();
  final cityNode = FocusNode();
  final stateProvinceNode = FocusNode();
  final streetNode = FocusNode();
  final zipCodeNode = FocusNode();
  final phoneNumberNode = FocusNode();
  final emailNode = FocusNode();
  final passwordNode = FocusNode();
  final confirmpasswordNode = FocusNode();

  Customer customer = Customer();
  List<CountryListModel> _list = [];
  CountryListModel? countryListModel;

  @override
  void initState() {
    super.initState();
    context.read<RegisterBloc>().add(
      const PerformCountriesList(),
    );
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

  Future selectFileToUpload() async {
    try {
      // FilePickerResult? result = await FilePicker.platform.pickFiles(
      //   allowMultiple: false,
      //   type: FileType.custom,
      //   allowedExtensions: ['pdf'],
      // );
      //
      // if (result != null) {
      //   final path = result.files.single.path!;
      //   setState(() => pdfPortFolioFile = File(path));
      //
      //   final fileName =
      //       pdfPortFolioFile != null ? p.basename(pdfPortFolioFile!.path) : '';
      //   //
      //   setState(() => pdfFolioFile = fileName);
      //   //
      // } else {
      //   "User has cancelled the selection".log();
      // }
    } catch (e) {
      '$e'.log();
    }
  }

  Future<void> _selectBirthDate(BuildContext context) async {
   // final f = DateFormat('yyyy-MM-dd');

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1930, 01),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
     // locale: context.locale,
    );
    if (picked != null) {
      setState(() {
       // birthDate = f.format(picked);
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    fullNameNode.dispose();
    emailNode.dispose();
    passwordNode.dispose();
    phoneNumberNode.dispose();
    confirmpasswordNode.dispose();
    streetNode.dispose();
    zipCodeNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => Tools.hideKeyboard(context),
          child: SingleChildScrollView(
            child: BlocListener<RegisterBloc, RegisterState>(
              listener: (context, state) async {
                if (state is RegisterLoading) {
                  LoadingScreen().show(
                    context: context,
                    text: 'Please wait a moment',
                  );
                } else {
                  LoadingScreen().hide();
                }

                if (state is CountriesLoaded) {
                  setState(() {
                    _list = state.list;
                    countryListModel = _list.first;
                  });
                }else if (state is SendMobileOTPLoaded) {
                  if(state.mobileOTPModel.status == "success"){
                    if(!OtpDialog.isDialogOpen){
                      OtpDialog.showOtpDialog(context, "${countryCode?.dialCode?.replaceAll("+", "")}${customer.telephone?.trim()}",((otpCode,actionFrom){
                        if(actionFrom == "resend"){
                          Map<String, dynamic> params = {
                            "mobile":"${countryCode?.dialCode?.replaceAll("+", "")}${customer.telephone?.trim()}",
                            "type": "VENDOR_REGISTER"
                          };
                          context.read<RegisterBloc>().add(
                            PerformSendMobileOTP(
                              requestValueMap: params,
                            ),
                          );
                        }else{
                          Map<String, dynamic> params = {
                            "mobile":"${countryCode?.dialCode?.replaceAll("+", "")}${customer.telephone?.trim()}",
                            "type": "VENDOR_REGISTER"
                            ,"otp": otpCode,
                            "password": ""
                          };
                          context.read<RegisterBloc>().add(
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
                    customer.country_id = countryListModel?.id;
                    customer.telephone = "${countryCode?.dialCode?.replaceAll("+", "")}${customer.telephone?.trim()}";
                    final Map<String, dynamic> data = new Map<String, dynamic>();
                    data['vendor'] = customer.toRegisterJson();
                    print(jsonEncode(data));
                    //'${data}'.log();
                    context.read<RegisterBloc>().add(
                      PerformUserRegister(
                        requestValueMap: data,
                      ),
                    );
                  }else{
                    Tools.showSnackBar(ScaffoldMessenger.of(context), state.mobileOTPModel.message);
                  }
                }else if (state is RegisterLoaded) {
                 // await Future.delayed(const Duration(seconds: 2));
                //  NavigationServices(context).gotoGenderSelectionScreenRAR();
                  Navigator.of(context).pop();
                }

                if (state is RegisterError) {
                  Tools.showSnackBar(ScaffoldMessenger.of(context), state.errorMessage);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: AutofillGroup(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(height: 5.0),
                      Center(
                        child: FluxImage(
                          imageUrl: kAppLogo,
                          fit: BoxFit.contain,
                          width: size.width / 2,
                          height: size.height / 3,
                        ),
                      ),
                      const SizedBox(height: 5.0,),
                      CustomTextField(
                          autofillHints: const [AutofillHints.givenName],
                          onChanged: (value) => customer.firstname = value,
                          textCapitalization: TextCapitalization.words,
                          focusNode: fullNameNode,
                          nextNode: emailNode,
                          showCancelIcon: true,
                          decoration: _inputDecoration("${AppLocalizations.of(context)!.fullName}*",
                              "${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.fullName}")
                      ),
                      const SizedBox(height: 5.0),
                      CustomTextField(
                          autofillHints: const [AutofillHints.email],
                          focusNode: emailNode,
                          nextNode: companyNode,
                          controller: _emailController,
                          onChanged: (value) => customer.email = value,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _inputDecoration("${AppLocalizations.of(context)!.email}*",
                              AppLocalizations.of(context)!.enterYourEmail)
                      ),
                      const SizedBox(height: 5.0),
                      CustomTextField(
                          autofillHints: const [AutofillHints.familyName],
                          focusNode: companyNode,
                          nextNode: vendorIdNode,
                          showCancelIcon: true,
                          onChanged: (value) => customer.company = value,
                          decoration: _inputDecoration("${AppLocalizations.of(context)!.company}*",
                              "${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.company}")
                      ),
                      const SizedBox(height: 5.0),
                      CustomTextField(
                          autofillHints: const [AutofillHints.familyName],
                          focusNode: vendorIdNode,
                          nextNode: stateProvinceNode,
                          showCancelIcon: true,
                          onChanged: (value) => customer.vendor_id = value,
                          decoration: _inputDecoration("${AppLocalizations.of(context)!.vendorId}*",
                              "${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.vendorId}")
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 0,
                            right: 0,
                            top: 5,
                            bottom: 0
                        ),
                        height: 20,
                        child: Text("${AppLocalizations.of(context)!.country}",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      DropdownButton<CountryListModel>(
                        value: countryListModel,
                        icon: const Icon(Icons.arrow_drop_down),
                        isExpanded: true,
                        elevation: 16,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.black),
                        underline: Container(
                          height: 1,
                          color: Colors.black,
                        ),
                        onChanged: (CountryListModel? newValue) {
                          setState(() => countryListModel = newValue);
                        },
                        items: _list.map<DropdownMenuItem<CountryListModel>>((status) {
                          return DropdownMenuItem<CountryListModel>(
                            value: status,
                            child: Text(
                              selectedLanguage == "ar" ? status.fullNameLocale ?? "":status.fullNameEnglish ?? "",
                            ),
                          );
                        }).toList(),
                      ),
                      CustomTextField(
                          autofillHints: const [AutofillHints.familyName],
                          focusNode: stateProvinceNode,
                          nextNode: cityNode,
                          showCancelIcon: true,
                          onChanged: (value) => customer.region = value,
                          decoration: _inputDecoration("${AppLocalizations.of(context)!.stateProvince}*",
                              "${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.stateProvince}")
                      ),
                      CustomTextField(
                          autofillHints: const [AutofillHints.familyName],
                          focusNode: cityNode,
                          nextNode: streetNode,
                          showCancelIcon: true,
                          onChanged: (value) => customer.city = value,
                          decoration: _inputDecoration("${AppLocalizations.of(context)!.city}*",
                              "${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.city}")
                      ),
                      CustomTextField(
                          autofillHints: const [AutofillHints.streetAddressLine1],
                          focusNode: streetNode,
                          nextNode: zipCodeNode,
                          showCancelIcon: true,
                          onChanged: (value) => customer.street = value,
                          decoration: _inputDecoration(AppLocalizations.of(context)!.streetAddress,
                              "${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.streetAddress}")
                      ),
                      CustomTextField(
                          autofillHints: const [AutofillHints.postalCode],
                          focusNode: zipCodeNode,
                          nextNode: phoneNumberNode,
                          showCancelIcon: true,
                          onChanged: (value) => customer.postcode = normalizeDigits(value),
                          decoration: _inputDecoration(AppLocalizations.of(context)!.zipPostalCode,
                              "${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.zipPostalCode}")
                      ),
                      const SizedBox(height: 5.0),
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
                                  onChanged: (country) {
                                    setState(() {
                                      countryCode = country;
                                    });
                                  },
                                  initialSelection: countryCode?.code ?? "eg",
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
                              label: selectedLanguage == 'ar' ? "*${AppLocalizations.of(context)!.phone}":"${AppLocalizations.of(context)!.phone}*",
                              fontSize: 12.0,
                              focusNode: phoneNumberNode,
                              keyboardType: TextInputType.phone,
                              onChanged: (value) => customer.telephone = value,
                              controller: _phoneController,
                              backgroundColor: Colors.transparent,
                            ),),
                            // Expanded(child: CustomTextField(
                            //   focusNode: phoneNumberNode,
                            //   autofillHints: const [AutofillHints.telephoneNumber],
                            //   nextNode: passwordNode,
                            //   showCancelIcon: true,
                            //   onChanged: (value) => customer.telephone = value,
                            //   decoration: _inputDecoration("${AppLocalizations.of(context)!.phone}*",
                            //       AppLocalizations.of(context)!.enterYourPhoneNumber),
                            //   keyboardType: TextInputType.phone,
                            // ),)
                          ],
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      CustomTextField(
                          autofillHints: const [AutofillHints.password],
                          focusNode: passwordNode,
                          nextNode: confirmpasswordNode,
                          showEyeIcon: true,
                          obscureText: true,
                          controller: _passwordController,
                          onChanged: (value) => customer.password = value,
                          decoration: _inputDecoration("${AppLocalizations.of(context)!.password}*",
                              AppLocalizations.of(context)!.enterYourPassword)
                      ),
                      const SizedBox(height: 5.0),
                      CustomTextField(
                          autofillHints: const [AutofillHints.password],
                          focusNode: confirmpasswordNode,
                          showEyeIcon: true,
                          obscureText: true,
                          controller: _repeatPasswordController,
                          decoration: _inputDecoration("${AppLocalizations.of(context)!.confirmPassword}*",
                              "${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.confirmPassword}")
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Material(
                          color: Theme.of(context).primaryColor,
                          borderRadius:
                          const BorderRadius.all(Radius.circular(5.0)),
                          elevation: 0,
                          child: MaterialButton(
                            onPressed: () async {
                              if (_allValidation()) {
                                Map<String, dynamic> params = {
                                  "mobile":"${countryCode?.dialCode?.replaceAll("+", "")}${customer.telephone?.trim()}",
                                  "type": "VENDOR_REGISTER"
                                };
                                context.read<RegisterBloc>().add(
                                  PerformSendMobileOTP(
                                    requestValueMap: params,
                                  ),
                                );
                              }
                            },
                            minWidth: 200.0,
                            elevation: 0.0,
                            height: 42.0,
                            child: Text(
                              AppLocalizations.of(context)!.createAnAccount,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '${AppLocalizations.of(context)!.or.toLowerCase()} ',
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                AppLocalizations.of(context)!.loginToYourAccount,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  decoration: TextDecoration.underline,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
    if ((customer.firstname ?? "").trim().isEmpty
        || (customer.vendor_id ?? "").trim().isEmpty
        || (customer.company ?? "").trim().isEmpty
        || (customer.city ?? "").trim().isEmpty
        || (customer.region ?? "").trim().isEmpty
        || (customer.telephone ?? "").trim().isEmpty
        || (customer.email ?? "").trim().isEmpty
        || (customer.password ?? "").trim().isEmpty) {
      Tools.showSnackBar(ScaffoldMessenger.of(context), AppLocalizations.of(context)!.allrequiredfields);
      isValid = false;
    }else if (_repeatPasswordController.text.trim().isEmpty) {
      Tools.showSnackBar(ScaffoldMessenger.of(context), AppLocalizations.of(context)!.allrequiredfields);
      isValid = false;
    }else if (!Validator.validateEmail(_emailController.text.trim())) {
      Tools.showSnackBar(ScaffoldMessenger.of(context), AppLocalizations.of(context)!.invalidEmail);
      isValid = false;
    }else if ((customer.telephone ?? "").startsWith("0")) {
      Tools.showSnackBar(ScaffoldMessenger.of(context), AppLocalizations.of(context)!.validMobileWithout0);
      isValid = false;
    }else if ((customer.telephone ?? "").length != 10) {
      Tools.showSnackBar(ScaffoldMessenger.of(context), AppLocalizations.of(context)!.validMobile);
      isValid = false;
    }
    else if (!Validator.validatePassword(_passwordController.text.trim())) {
      Tools.showSnackBar(ScaffoldMessenger.of(context), AppLocalizations.of(context)!.your_password_must_be_at_least_8_characters_with_at_least_1_number_and_1_special_character);
      isValid = false;
    }
    else if (_repeatPasswordController.text.trim() != _passwordController.text.trim()) {
      Tools.showSnackBar(ScaffoldMessenger.of(context), AppLocalizations.of(context)!.passwordsDoNotMatch);
      isValid = false;
    }
    return isValid;
  }



  void _launchURL(String url) async {

  }

  InputDecoration _inputDecoration(String labelText,String hintText){
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      labelStyle: Theme.of(context).textTheme.titleMedium,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary),
      ),
    );
  }

  Widget userRoleSelection() {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Material(
        elevation: 0.4,
        shadowColor: AppColors.grey,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: DropdownButton<String>(
            elevation: 0,
            icon: Padding(
              padding: EdgeInsets.only(right: 8),
              child: Image.asset(
                "assets/icons/brand_icons_ui_chevron_forward.png",
                width: 15,
              ),
            ),
            isExpanded: true,
            value: "i_am_here_to_shop",
            underline: const SizedBox(),
            items: <String>[
              "i_am_here_to_shop".trim(),
              'register_i_am_fashion_creator'.trim()
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      value,
                      textAlign: TextAlign.start,
                     // style: montserrat12LightText,
                    ),
                  ),
                ),
              );
            }).toList(),
            onChanged: (val) {
              setState(() {
               // roleDescription = val ?? "";
              });
            },
          ),
        ),
      ),
    );
  }
}

// const SizedBox(height: 5.0),
// CustomTextField(
// autofillHints: const [AutofillHints.familyName],
// focusNode: lastNameNode,
// nextNode: vendorIdNode,
// showCancelIcon: true,
// textCapitalization: TextCapitalization.words,
// onChanged: (value) => customer.lastname = value,
// decoration: _inputDecoration(AppLocalizations.of(context)!.lastName,
// AppLocalizations.of(context)!.enterYourLastName)
// ),

// const SizedBox(height: 5.0),
// CustomTextField(
// autofillHints: const [AutofillHints.familyName],
// focusNode: addressNode,
// nextNode: cityNode,
// showCancelIcon: true,
// onChanged: (value) => customer.street = value,
// decoration: _inputDecoration("Street Address","Enter Street Address")
// ),

// const SizedBox(height: 5.0),
// CustomTextField(
// autofillHints: const [AutofillHints.familyName],
// focusNode: zipCodeNode,
// nextNode: phoneNumberNode,
// showCancelIcon: true,
// keyboardType: TextInputType.number,
// onChanged: (value) => customer.postcode = value,
// decoration: _inputDecoration("${AppLocalizations.of(context)!.zipCode}*",
// "${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.zipCode}")
// ),