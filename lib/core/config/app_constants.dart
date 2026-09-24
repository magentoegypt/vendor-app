// ignore_for_file: constant_identifier_names

import 'package:universal_platform/universal_platform.dart';

var selectedLanguage = "ar";
const bool isDebugLogEnabled = true;
/// check if the environment is web
final bool kIsWeb = UniversalPlatform.isWeb;
final bool isIos = UniversalPlatform.isIOS;
final bool isAndroid = UniversalPlatform.isAndroid;
final bool isMacOS = UniversalPlatform.isMacOS;
final bool isWindow = UniversalPlatform.isWindows;
final bool isFuchsia = UniversalPlatform.isFuchsia;
final bool isMobile = UniversalPlatform.isIOS || UniversalPlatform.isAndroid;
final bool isDesktop = UniversalPlatform.isMacOS || UniversalPlatform.isWindows;

const double smallSpace = 10;
const double mediumSpace = 15;
const double largeSpace = 20;
const double buttonHeight = 50;
const double switchbuttonHeight = 40;
const double buttonLargeHeight = 60;
const double smallButtonHeight = 40;
const kImageProxy = '';
const kCacheImageWidth = 700;
const kDefaultImage =
    'https://trello.com/1/cards/5d64f19a7cd71013a9a418cf/attachments/5df37e7dc660f72ec2a6b147/previews/5df37e7ec660f72ec2a6b14f/download/placeholder.jpg';
const kAppLogo = "assets/images/app_icon_transparent.png";
const kAppName = "FluxStore Admin";
const AdminKey = "qvy8jeg246pqwvxeoznpeogi3g0mgs2u";
