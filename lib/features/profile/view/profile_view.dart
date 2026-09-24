import 'dart:convert';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_vendor/common/AppDrawer.dart';
import '../../../../core/config/extensions.dart';
import '../../../../common/custom_text_field.dart';
import '../../../../common/flux_image.dart';
import '../../../../core/config/app_constants.dart';
import '../../../../core/config/colors.dart';
import '../../../../core/config/locator.dart';
import '../../../../core/config/tools.dart';
import '../../../../core/helper/loading_screen.dart';
import '../../../common/AppBars.dart';
import '../../../common/edit_product_info_widget.dart';
import '../../../common/otp_dialog.dart';
import '../../../core/config/pref_keys.dart';
import '../../../core/helper/shared_preferences_helpers.dart';
import '../../auth/api_login_feature/view/login_view.dart';
import '../../auth/register_feature/data/CountryListModel.dart';
import '../../auth/register_feature/data/SignUpModel.dart';
import '../../home/data/UserModel.dart';
import '../bloc/profile_bloc.dart';

class ProfileViewWidget extends StatefulWidget {
  UserModel? userModel;

   ProfileViewWidget({
    Key? key,this.userModel,
  }) : super(key: key);

  @override
  State<ProfileViewWidget> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileViewWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final SharedPreferencesHelpers _sharedPrefKeys = SharedPreferencesHelpers();
  CountryCode? countryCode;
  final fullNameNode = FocusNode();
  final vendorIdNode = FocusNode();
  final companyNode = FocusNode();
  final cityNode = FocusNode();
  final stateProvinceNode = FocusNode();
  final zipCodeNode = FocusNode();
  final phoneNumberNode = FocusNode();

  Customer customer = Customer();
  List<CountryListModel> _list = [];
  CountryListModel? countryListModel;

  @override
  void initState() {
    super.initState();
    countryCode = CountryCode(
      code: "EG",
      dialCode: "+20",
      name: "Egypt",
    );
    widget.userModel = userModel;
    context.read<ProfileBloc>().add(
      const PerformCountriesList(),
    );
    customer.firstname = widget.userModel?.firstname;
    customer.lastname = widget.userModel?.lastname;
    customer.company = widget.userModel?.company;
    customer.street = widget.userModel?.street;
    customer.city = widget.userModel?.city;
    customer.region = widget.userModel?.regionCode;
    customer.postcode = widget.userModel?.postcode;
    customer.telephone = widget.userModel?.telephone;
    if((widget.userModel?.telephone ?? "").isNotEmpty) {
      try{
        String? phoneWithoutCOde =widget.userModel?.telephone?.substring(
            2, (widget.userModel?.telephone?.length ?? 0));
        customer.telephone = phoneWithoutCOde;
      }catch(e){}
    }
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
    phoneNumberNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBars(context,_scaffoldKey,AppLocalizations.of(context)!.sellerProfile,true,true),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => Tools.hideKeyboard(context),
          child: SingleChildScrollView(
            child: BlocListener<ProfileBloc, ProfileState>(
              listener: (context, state) async {
                if (state is ProfileLoading) {
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
                    countryListModel = _list.firstWhere((e) => e.id == widget.userModel?.countryId);
                  });
                }else if (state is ProfileLoaded) {
                  userModel = state.userInfo;
                  widget.userModel = state.userInfo;
                  _sharedPrefKeys.setStringData(key: userPrefKey, text:  jsonEncode(state.userInfo.toJson()));
                  Tools.showSnackBar(ScaffoldMessenger.of(context),
                      AppLocalizations.of(context)!.profileupdatedSuccessful);
                  await Future.delayed(const Duration(seconds: 2));
                  Navigator.of(context).pop();
                }else if (state is SendMobileOTPLoaded) {
                  if(state.mobileOTPModel.status == "success"){
                    if(!OtpDialog.isDialogOpen){
                      OtpDialog.showOtpDialog(context, customer.telephone ?? "",((otpCode,actionFrom){
                        if(actionFrom == "resend"){
                          Map<String, dynamic> params = {
                            "mobile":customer.telephone,
                            "type": "VENDOR_UPDATEMOB"
                          };
                          context.read<ProfileBloc>().add(
                            PerformSendMobileOTP(
                              requestValueMap: params,
                            ),
                          );
                        }else{
                          Map<String, dynamic> params = {
                            "mobile":customer.telephone,
                            "type": "VENDOR_UPDATEMOB"
                            ,"otp": otpCode,
                            "password": ""
                          };
                          context.read<ProfileBloc>().add(
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
                    final Map<String, dynamic> data = new Map<String, dynamic>();
                    data['vendor'] = customer.toUpfateProfileJson();
                    '${data}'.log();
                    context.read<ProfileBloc>().add(
                      PerformUserProfile(
                        requestValueMap: data,
                      ),
                    );
                  }else{
                    Tools.showSnackBar(ScaffoldMessenger.of(context), state.mobileOTPModel.message);
                  }
                }else if (state is DeleteVendorLoaded) {
                    if(state.isDelete){
                      Tools.showSnackBar(ScaffoldMessenger.of(context), AppLocalizations.of(context)!.deleteAccountSuccess);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInView(),
                          ),
                              (e) => false);
                    }else{
                      Tools.showSnackBar(ScaffoldMessenger.of(context), AppLocalizations.of(context)!.somethingWrong);
                    }
                }
                if (state is ProfileError) {

                  Tools.showSnackBar(ScaffoldMessenger.of(context),
                      state.errorMessage);
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
                      InkWell(
                        onTap: () {
                          _showDialogDeleteAccountSuccess();
                        },
                        child: Text(
                          AppLocalizations.of(context)!.deleteAccount,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Center(
                        child: FluxImage(
                          imageUrl: kAppLogo,
                          fit: BoxFit.contain,
                          width: size.width / 2,
                          height: size.height / 3,
                        ),
                      ),
                      const SizedBox(height: 5.0),

                      CustomTextField(
                          controller: TextEditingController(text: widget.userModel?.vendorId),
                          autofillHints: const [AutofillHints.familyName],
                          focusNode: vendorIdNode,
                          nextNode: fullNameNode,
                          enabled: false,
                          showCancelIcon: true,
                          decoration: _inputDecoration(AppLocalizations.of(context)!.vendorId,"${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.vendorId}")
                      ),
                      const SizedBox(height: 5.0,),
                      CustomTextField(
                          controller: TextEditingController(text: "${widget.userModel?.firstname ?? ""} ${widget.userModel?.lastname ?? ""}"),
                          autofillHints: const [AutofillHints.givenName],
                          onChanged: (value) => customer.firstname = value,
                          textCapitalization: TextCapitalization.words,
                          focusNode: fullNameNode,
                          nextNode: companyNode,
                          showCancelIcon: true,
                          decoration: _inputDecoration("${AppLocalizations.of(context)!.fullName}*",
                              "${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.fullName}")
                      ),
                      const SizedBox(height: 5.0),
                      CustomTextField(
                          controller: TextEditingController(text: widget.userModel?.company),
                          autofillHints: const [AutofillHints.familyName],
                          focusNode: companyNode,
                          nextNode: cityNode,
                          showCancelIcon: true,
                          onChanged: (value) => customer.company = value,
                          decoration: _inputDecoration("${AppLocalizations.of(context)!.company}*",
                              "${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.company}")
                      ),
                      const SizedBox(height: 5.0),
                      CustomTextField(
                          controller: TextEditingController(text: widget.userModel?.city),
                          autofillHints: const [AutofillHints.familyName],
                          focusNode: cityNode,
                          nextNode: stateProvinceNode,
                          showCancelIcon: true,
                          onChanged: (value) => customer.city = value,
                          decoration: _inputDecoration("${AppLocalizations.of(context)!.city}*",
                              "${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.city}")
                      ),
                      const SizedBox(height: 5.0),
                      CustomTextField(
                          controller: TextEditingController(text: widget.userModel?.regionCode),
                          autofillHints: const [AutofillHints.familyName],
                          focusNode: stateProvinceNode,
                          nextNode: zipCodeNode,
                          showCancelIcon: true,
                           onChanged: (value) => customer.region = value,
                          decoration: _inputDecoration("${AppLocalizations.of(context)!.stateProvince}*",
                              "${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.stateProvince}")
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
                              controller: TextEditingController(text: customer.telephone),
                              label: selectedLanguage == 'ar' ? "*${AppLocalizations.of(context)!.phone}":"${AppLocalizations.of(context)!.phone}*",
                              fontSize: 12.0,
                              focusNode: phoneNumberNode,
                              keyboardType: TextInputType.phone,
                              onChanged: (value) => customer.telephone = value,
                              backgroundColor: Colors.transparent,
                            ),),
                            // Expanded(child: CustomTextField(
                            //   controller: TextEditingController(text: customer.telephone),
                            //   focusNode: phoneNumberNode,
                            //   autofillHints: const [AutofillHints.telephoneNumber],
                            //   showCancelIcon: true,
                            //   onChanged: (value) => customer.telephone = value,
                            //   decoration: _inputDecoration("${AppLocalizations.of(context)!.phone}*",
                            //       AppLocalizations.of(context)!.enterYourPhoneNumber),
                            //   keyboardType: TextInputType.phone,
                            // ),)
                          ],
                        ),
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
                                customer.telephone = "${countryCode?.dialCode?.replaceAll("+", "")}${customer.telephone?.trim()}";
                                customer.id = widget.userModel?.id;
                                customer.status = widget.userModel?.status;
                                customer.vendor_id = widget.userModel?.vendorId;
                                customer.country_id = countryListModel?.id;
                                if(customer.telephone != userModel?.telephone){
                                  Map<String, dynamic> params = {
                                    "mobile":"${customer.telephone}",
                                    "type": "VENDOR_UPDATEMOB"
                                  };
                                  context.read<ProfileBloc>().add(
                                    PerformSendMobileOTP(
                                      requestValueMap: params,
                                    ),
                                  );
                                }else{
                                  final Map<String, dynamic> data = new Map<String, dynamic>();
                                  data['vendor'] = customer.toUpfateProfileJson();
                                  '${data}'.log();
                                  context.read<ProfileBloc>().add(
                                    PerformUserProfile(
                                      requestValueMap: data,
                                    ),
                                  );
                                }
                              }
                            },
                            minWidth: 200.0,
                            elevation: 0.0,
                            height: 42.0,
                            child: Text(
                              AppLocalizations.of(context)!.update,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
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

  Future<void> _showDialogDeleteAccountSuccess() async {
    await showCupertinoDialog(
      context: context,
      builder: (ctxDialog) => CupertinoAlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteAccount),
          content: Text(AppLocalizations.of(context)!.deleteAccountMsg),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              context.read<ProfileBloc>().add(
                PerformDeleteVendor(
                  vendorId: '${widget.userModel?.id ?? ""}',
                ),
              );
              Navigator.of(ctxDialog).pop();

            },
            child: Text(AppLocalizations.of(context)!.ok),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(AppLocalizations.of(context)!.cancel),
            onPressed: () => Navigator.of(ctxDialog).pop(),
          ),
        ],
      ),
    );
  }

  bool _allValidation() {
    bool isValid = true;
    if ((customer.firstname ?? "").trim().isEmpty
        || (customer.company ?? "").trim().isEmpty
        || (customer.city ?? "").trim().isEmpty
        || (customer.region ?? "").trim().isEmpty
        || (customer.telephone ?? "").trim().isEmpty) {
      Tools.showSnackBar(ScaffoldMessenger.of(context), AppLocalizations.of(context)!.allrequiredfields);
      isValid = false;
    }else if ((customer.telephone ?? "").startsWith("0")) {
      Tools.showSnackBar(ScaffoldMessenger.of(context), AppLocalizations.of(context)!.validMobileWithout0);
      isValid = false;
    }else if ((customer.telephone ?? "").length != 10) {
      Tools.showSnackBar(ScaffoldMessenger.of(context), AppLocalizations.of(context)!.validMobile);
      isValid = false;
    }
    return isValid;
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

}
