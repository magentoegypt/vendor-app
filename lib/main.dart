import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_vendor/core/config/AppLanguage.dart';
import 'package:multi_vendor/features/auth/forgot_password_feature/bloc/forgot_password_bloc.dart';
import 'package:multi_vendor/features/auth/forgot_password_feature/data/forgot_password_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/config/app_constants.dart';
import 'core/config/colors.dart';
import 'core/config/locator.dart';
import 'core/helper/api_response_helper.dart';
import 'core/helper/loading_screen.dart';
import 'core/helper/shared_preferences_helpers.dart';
import 'core/ui/setup_snackbar_ui.dart';
import 'features/Orders/OrderList/bloc/orders_bloc.dart';
import 'features/Orders/OrderList/data/orders_repository.dart';
import 'features/Orders/SingleOrder/bloc/single_order_bloc.dart';
import 'features/Orders/SingleOrder/data/single_order_repository.dart';
import 'features/Products/CreateEditProduct/bloc/create_edit_product_bloc.dart';
import 'features/Products/CreateEditProduct/data/create_edit_product_repository.dart';
import 'features/auth/api_login_feature/bloc/login_bloc.dart';
import 'features/auth/api_login_feature/data/login_repository.dart';
import 'features/auth/api_login_feature/view/login_view.dart';
import 'features/auth/register_feature/bloc/register_bloc.dart';
import 'features/auth/register_feature/data/register_repository.dart';
import 'features/auth/reset_password_feature/bloc/reset_password_bloc.dart';
import 'features/auth/reset_password_feature/data/reset_password_repository.dart';
import 'features/home/bloc/dashboard_bloc.dart';
import 'features/home/data/dashboard_repository.dart';
import 'features/profile/bloc/profile_bloc.dart';
import 'features/profile/data/profile_repository.dart';
import 'features/splash/spalsh_screen.dart';
import 'features/Products/ProductList/bloc/products_bloc.dart';
import 'features/Products/ProductList/data/products_repository.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  // initialize flutter widget
  // must needed to communicate with native code and also firebase needs it
  WidgetsFlutterBinding.ensureInitialized();
  ///  calling dependencies setting for get_it
  setupLocator();
  ///  calling dependencies setting for get_it
  setupSnackbarUi();
  onSessionExpired = _openLoginAfterSessionExpired;

  runApp(const MainApp());
}

/// Opens the login screen once when a stored token is rejected (401), even if
/// several requests fail at the same time.
void _openLoginAfterSessionExpired() {
  final navigator = navigatorKey.currentState;
  if (navigator == null || SignInView.isShown) return;
  SignInView.isShown = true;
  navigator.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const SignInView(sessionExpired: true),
      ),
      (route) => false);
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  /*
  To Change Locale of App
   */
  static void setLocale(BuildContext context, Locale newLocale) async {
    _MainAppState? state = context.findAncestorStateOfType<_MainAppState>();

    var prefs = await SharedPreferences.getInstance();
    prefs.setString('languageCode', newLocale.languageCode);
    state?.setState(() {
      state._locale = newLocale;
      selectedLanguage = newLocale.languageCode ?? "";
    });
  }

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  Locale _locale = Locale('en', '');

  @override
  void initState() {
    super.initState();
    SharedPreferencesHelpers().fetchLocale().then((locale) {
      setState(() {
        this._locale = locale;
        selectedLanguage = locale.languageCode ?? "";
      });
    });
  }


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        // Login Repository
        RepositoryProvider<LoginRepository>(
          create: ((context) => LoginRepository()),
        ),
        // ForgotPassword Repository
        RepositoryProvider<ForgotPasswordRepository>(
          create: ((context) => ForgotPasswordRepository()),
        ),
        // ResetPassword Repository
        RepositoryProvider<ResetPasswordRepository>(
          create: ((context) => ResetPasswordRepository()),
        ),
        // Register Repository
        RepositoryProvider<RegisterRepository>(
          create: ((context) => RegisterRepository()),
        ),
        RepositoryProvider<DashboardRepository>(
          create: ((context) => DashboardRepository()),
        ),
        RepositoryProvider<OrdersRepository>(
          create: ((context) => OrdersRepository()),
        ),
        RepositoryProvider<SingleOrderRepository>(
          create: ((context) => SingleOrderRepository()),
        ),
        RepositoryProvider<ProductsRepository>(
          create: ((context) => ProductsRepository()),
        ),
        RepositoryProvider<CreateEditProductRepository>(
          create: ((context) => CreateEditProductRepository()),
        ),
        RepositoryProvider<ProfileRepository>(
          create: ((context) => ProfileRepository()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          // Login Bloc
          BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(
              repository: context.read<LoginRepository>(),
            ),
          ),
          // ForgotPassword Bloc
          BlocProvider<ForgotPasswordBloc>(
            create: (context) => ForgotPasswordBloc(
              repository: context.read<ForgotPasswordRepository>(),
            ),
          ),
          // ForgotPassword Bloc
          BlocProvider<ResetPasswordBloc>(
            create: (context) => ResetPasswordBloc(
              repository: context.read<ResetPasswordRepository>(),
            ),
          ),
          // Register Bloc
          BlocProvider<RegisterBloc>(
            create: (context) => RegisterBloc(
              repository: context.read<RegisterRepository>(),
            ),
          ),
          BlocProvider<DashboardBloc>(
            create: (context) => DashboardBloc(
              repository: context.read<DashboardRepository>(), ordersRepository: context.read<OrdersRepository>(),
            ),
          ),
          BlocProvider<OrdersBloc>(
            create: (context) => OrdersBloc(ordersRepository: context.read<OrdersRepository>()),
          ),
          BlocProvider<SingleOrderBloc>(
            create: (context) => SingleOrderBloc(orderRepository: context.read<SingleOrderRepository>()),
          ),
          BlocProvider<ProductsBloc>(
            create: (context) => ProductsBloc(
              repository: context.read<ProductsRepository>(),
            ),
          ),
          BlocProvider<CreateEditProductBloc>(
            create: (context) => CreateEditProductBloc(
              repository: context.read<CreateEditProductRepository>(),
            ),
          ),
          BlocProvider<ProfileBloc>(
            create: (context) => ProfileBloc(
              repository: context.read<ProfileRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            const FallbackCupertinoLocalisationsDelegate(),
          ],
          supportedLocales: [
            const Locale('en', ''), // English, no country code
            const Locale('ar', ''), // Arabic, no country code
          ],
          locale: _locale,
          title: kAppName,
          navigatorKey: navigatorKey,
          navigatorObservers: [LoadingScreenObserver()],
          theme: ThemeData(
            fontFamily: selectedLanguage == 'ar' ?'Tajawal':'Roboto',
           // fontFamily:,
            brightness: Brightness.light,
            primaryColor: Colors.blue,
          //  primaryColorLight: Colors.grey,
            highlightColor: Colors.white,
            scaffoldBackgroundColor: AppColors.screenBackground,
            appBarTheme: AppBarTheme(
                elevation: 0.0,
                backgroundColor: AppColors.transparentColor,
                systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarBrightness: Brightness.light,
                    statusBarIconBrightness: Brightness.dark,
                    statusBarColor: AppColors.transparentColor)), colorScheme: ColorScheme.fromSwatch(primarySwatch: AppColors.primaryApp)
                .copyWith(
                secondary: AppColors.black, brightness: Brightness.light).copyWith(background: Colors.white),
          ),
          home: const SplashScreen(),
        ),
      ),
    );
  }

}

/*
  To solve problem of hold press on inputs
 */
class FallbackCupertinoLocalisationsDelegate extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;
}

/*

 Column(
  children: [
  Padding(
  padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
  child: CommonTextFieldView(
  controller: _emailController,
  errorText: _errorEmail,
  labelText: AppLocalizations.of(context)!.email,
  keyboardType: TextInputType.emailAddress,
  onChanged: (String txt) {},
  ),
  ),
  Padding(
  padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
  child: CommonTextFieldView(
  controller: _passwordController,
  errorText: _errorPassword,
  labelText: 'password'.trim(),
  keyboardType: TextInputType.emailAddress,
  onChanged: (String txt) {},
  toggleObscure: () {
  setState(() => isPasswordObscure = !isPasswordObscure);
  },
  isObscureText: isPasswordObscure,
  ),
  ),
  VerticalSpace(20),
  Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: AppButtonLarge(
  text: "SIGNIN".trim(),
  press: () {
  // if (_allValidation()) {
  //   //build loginMap
  //   Map<String, dynamic> loginMap = {
  //     "username": _emailController.text,
  //     "password": _passwordController.text.trim(),
  //   };
  //
  //   /// init Login event
  //   context.read<LoginBloc>().add(
  //     PerformUserLogin(
  //       requestValueMap: loginMap,
  //     ),
  //   );
  // }
  MainApp.setLocale(context, Locale("ar", ""));
  },
  ),
  ),
  VerticalSpace(20),
  Align(
  alignment: Alignment.bottomRight,
  child: Padding(
  padding: const EdgeInsets.only(right: 20.0),
  child: InkWell(
  onTap: () {},
  child: Text(
  "forgot_password".trim(),
  style: TextStyle(
  decoration: TextDecoration.underline,
  fontSize: 12,
  ),
  ),
  ),
  ),
  ),
  VerticalSpace(20),
  InkWell(
  onTap: () {
  NavigationServices(context).gotoGenderSelectionScreenRAR();
  },
  child: Text(
  "continue_as_a_guest".trim(),
  style: TextStyle(
  decoration: TextDecoration.underline,
  fontSize: 12,
  ),
  ),
  ),
  ],
  ),

 */

/*

[
            VerticalSpace(20),
            // I am here to shop dropdown selection
            userRoleSelection(),
            VerticalSpace(20),
            // =============== if Fashion Creative ================
            (roleDescription == 'register_i_am_fashion_creator'.trim())
                ? Column(
                    children: [
                      fashionProfessionalWorkSelection(),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, left: 20, right: 20),
                        child: CommonTextFieldView(
                          controller: _companyNameController,
                          errorText: "",
                          labelText: 'company_brand_name_if_any'.trim(),
                          keyboardType: TextInputType.text,
                          onChanged: (String txt) {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, left: 20, right: 20),
                        child: CommonTextFieldView(
                          controller: _websiteController,
                          errorText: "",
                          labelText: 'website_portfolio_optional'.trim(),
                          keyboardType: TextInputType.text,
                          prefixIcon: Image.asset(
                            "assets/icons/link.png",
                            scale: 4.0,
                          ),
                          onChanged: (String txt) {},
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          selectFileToUpload();
                        },
                        child: Container(
                          margin: EdgeInsets.all(20),
                          color: AppColors.white,
                          height: 50,
                          width: double.infinity,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 10,
                                left: 10,
                                child: Image.asset(
                                  "assets/icons/attachment.png",
                                  scale: 4.0,
                                ),
                              ),
                              Center(
                                  child: Text(
                                pdfFolioFile,
                             //   style: montserrat11Medium,
                              )),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                : SizedBox.shrink(),

            // ===============================
            VerticalSpace(20),
            // user Title selection
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
              child: CommonTextFieldView(
                controller: _firstNameController,
                errorText: _errorFirstName,
                labelText: 'first_name'.trim(),
                keyboardType: TextInputType.text,
                onChanged: (String txt) {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
              child: CommonTextFieldView(
                controller: _lastNameController,
                errorText: _errorLastName,
                labelText: 'last_name'.trim(),
                keyboardType: TextInputType.text,
                onChanged: (String txt) {},
              ),
            ),
            // =============== if Fashion Creative ================
            (roleDescription == 'register_i_am_fashion_creator'.trim())
                ? InkWell(
                    onTap: () {
                      _selectBirthDate(context);
                    },
                    child: Container(
                      margin: EdgeInsets.all(20),
                      color: AppColors.white,
                      height: 50,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0, left: 10),
                        child: Text(
                          birthDate,
                          // style: (birthDate == "date_of_birth".trim())
                          //     ? montserrat11ExtraLightGrey
                          //     : montserrat12Medium,
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),

            // ===============================
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
              child: CommonTextFieldView(
                controller: _emailController,
                errorText: _errorEmail,
                labelText: 'email'.trim(),
                keyboardType: TextInputType.emailAddress,
                onChanged: (String txt) {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
              child: CommonTextFieldView(
                controller: _passwordController,
                errorText: _errorPassword,
                labelText: 'password'.trim(),
                keyboardType: TextInputType.text,
                onChanged: (String txt) {},
                toggleObscure: () {
                  setState(() => isPasswordObscure = !isPasswordObscure);
                },
                isObscureText: isPasswordObscure,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
              child: CommonTextFieldView(
                controller: _repeatPasswordController,
                errorText: _errorRepeatPassword,
                labelText: 'password_confirm'.trim(),
                keyboardType: TextInputType.text,
                onChanged: (String txt) {},
                toggleObscure: () {
                  setState(
                      () => isRepeatPasswordObscure = !isRepeatPasswordObscure);
                },
                isObscureText: isRepeatPasswordObscure,
              ),
            ),
            // =============== if Fashion Creative ================
            (roleDescription == 'register_i_am_fashion_creator'.trim())
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, left: 20, right: 20),
                        child: CommonTextFieldView(
                          controller: _phoneNumberController,
                          errorText: "",
                          labelText: 'account_details_hint_number'.trim(),
                          keyboardType: TextInputType.phone,
                          onChanged: (String txt) {},
                        ),
                      ),
                      VerticalSpace(20),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, left: 20, right: 20),
                        child: CommonTextFieldView(
                          controller: _instagramUrlController,
                          errorText: "",
                          labelText: 'instagram_handle_optional_checkout'.trim(),
                          keyboardType: TextInputType.text,
                          prefixIcon: Image.asset(
                            "assets/icons/brand_icons_social_instagram.png",
                            scale: 4.0,
                          ),
                          onChanged: (String txt) {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, left: 20, right: 20),
                        child: CommonTextFieldView(
                          controller: _facebookUrlController,
                          errorText: "",
                          labelText: 'facebook_page_optional_checkout'.trim(),
                          keyboardType: TextInputType.text,
                          prefixIcon: Image.asset(
                            "assets/icons/brand_icons_social_facebook.png",
                            scale: 4.0,
                          ),
                          onChanged: (String txt) {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, left: 20, right: 20),
                        child: CommonTextFieldView(
                          controller: _twitterUrlController,
                          errorText: "",
                          labelText: 'twitter_handle_optional_checkout'.trim(),
                          keyboardType: TextInputType.text,
                          prefixIcon: Image.asset(
                            "assets/icons/brand_icons_social_twitter.png",
                            scale: 4.0,
                          ),
                          onChanged: (String txt) {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, left: 20, right: 20),
                        child: CommonTextFieldView(
                          controller: _youtubeUrlController,
                          errorText: "",
                          labelText: 'youtube_handle_optional_checkout'.trim(),
                          keyboardType: TextInputType.text,
                          prefixIcon: Image.asset(
                            "assets/icons/brand_icons_social_you_tube.png",
                            scale: 4.0,
                          ),
                          onChanged: (String txt) {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, left: 20, right: 20),
                        child: CommonTextFieldView(
                          controller: _snapchatUrlController,
                          errorText: "",
                          labelText: 'snapchat_handle_optional_checkout'.trim(),
                          keyboardType: TextInputType.text,
                          prefixIcon: Image.asset(
                            "assets/icons/brand_icons_social_snapchat.png",
                            scale: 4.0,
                          ),
                          onChanged: (String txt) {},
                        ),
                      ),
                    ],
                  )
                : SizedBox.shrink(),

            // ===============================
            CheckboxListTile(
              activeColor: AppColors.twd_Off_Black,
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "register_i_agree".trim() +
                        " " +
                        "app_name".trim() +
                        "'s" +
                        "".trim(),
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(width: 3),
                  InkWell(
                    onTap: () {
                      _launchURL(
                          "https://mnatelier.com/legal/terms-and-conditions?headlessPageView=1");
                    },
                    child: Text(
                      "terms".trim(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.twd_Off_Black,
                      ),
                    ),
                  ),
                ],
              ),
              value: agreeTermsOfServices,
              onChanged: (newValue) {
                setState(() {
                  agreeTermsOfServices = newValue!;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            VerticalSpace(20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AppButtonLarge(
                color: AppColors.black,
                text: "REGISTER".trim(),
                press: () {
                  // first Check if agreeTermsOfServices is true to call validations and then submit form

                  if (agreeTermsOfServices) {
                    ///  if Role is fashion Creative
                    ///
                    if (roleDescription ==
                        'register_i_am_fashion_creator'.trim()) {
                      Map<String, dynamic> requestValueMap = {
                        "emailAddress": _emailController.text.trim(),
                        "password": _passwordController.text.trim(),
                        "dateOfBirth": birthDate,
                        "repeatPassword": _repeatPasswordController.text.trim(),
                        "firstName": _firstNameController.text.trim(),
                        "lastName": _lastNameController.text.trim(),
                        "phoneNumber": _phoneNumberController.text.trim(),
                        "honorific": _honorificTitle,
                        "roleDescription": roleDescription,
                        "role": fashionCreativeWorkRole,
                        "brandName": _companyNameController.text.trim(),
                        "twitterUrl": _twitterUrlController.text.trim(),
                        "snapchatUrl": _snapchatUrlController.text.trim(),
                        "websiteUrl": _websiteController.text.trim(),
                        "youtubeUrl": _youtubeUrlController.text.trim(),
                        "instagramUrl": _instagramUrlController.text.trim(),
                        "facebookUrl": _facebookUrlController.text.trim(),
                        "acceptTerms": agreeTermsOfServices,
                        "active": true
                      };

                      if (_allValidation()) {
                        '$requestValueMap'.log();

                        context.read<RegisterBloc>().add(
                              PerformUserRegister(
                                requestValueMap: requestValueMap,
                              ),
                            );
                      }
                    } else {
                      Map<String, dynamic> requestValueMap = {
                        "emailAddress": _emailController.text.trim(),
                        "firstName": _firstNameController.text.trim(),
                        "lastName": _lastNameController.text.trim(),
                        "password": _passwordController.text.trim(),
                        "repeatPassword": _repeatPasswordController.text.trim(),
                        "honorific": _honorificTitle,
                        "roleDescription": roleDescription,
                        "acceptTerms": agreeTermsOfServices,
                        "active": true
                      };

                      if (_allValidation()) {
                        '$requestValueMap'.log();
                        context.read<RegisterBloc>().add(
                              PerformUserRegister(
                                requestValueMap: requestValueMap,
                              ),
                            );
                      }
                    }
                  }
                },
              ),
            ),
            VerticalSpace(30),
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {},
                child: Text(
                  "continue_as_a_guest".trim(),
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            VerticalSpace(60),
          ]

 */