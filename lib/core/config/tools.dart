import 'dart:convert';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:universal_platform/universal_platform.dart';

import '../utils/json_parser.dart';
import 'app_constants.dart';
import 'locator.dart';


class Tools {
  static double? formatDouble(num? value) => value == null ? null : value * 1.0;

  /// check tablet screen
  static bool isTablet(MediaQueryData query) {

    if (kIsWeb) {
      return true;
    }

    if (UniversalPlatform.isWindows || UniversalPlatform.isMacOS) {
      return false;
    }

    var size = query.size;
    var diagonal =
        sqrt((size.width * size.width) + (size.height * size.height));
    var isTablet = diagonal > 1100.0;
    return isTablet;
  }

  static bool isRTL(BuildContext context) {
    return Directionality.of(context).toString().contains(TextDirection.RTL.value.toLowerCase());
  }

  static bool isPhone(MediaQueryData query) {
    return isMobile && !isTablet(query);
  }

  static Future<List<dynamic>> loadStatesByCountry(String country) async {
    try {
      // load local config
      var path = 'lib/config/states/state_${country.toLowerCase()}.json';
      //if use loadString can't catch file is not exists
      final data = await rootBundle.load(path);
      String? appJson;
      if (data.lengthInBytes < 50 * 1024) {
        appJson = utf8.decode(data.buffer.asUint8List());
      } else {
        String utf8decode(ByteData data) {
          return utf8.decode(data.buffer.asUint8List());
        }

        appJson = utf8decode(data);
      }
      return List<dynamic>.from(jsonDecode(appJson));
    } catch (e) {
      return [];
    }
  }

  static dynamic getValueByKey(Map<String, dynamic>? json, String? key) {
    if (key == null) return null;
    try {
      List keys = key.split('.');
      Map<String, dynamic>? data = Map<String, dynamic>.from(json!);
      if (keys[0] == '_links') {
        var links = json['listing_data']['_links'] ?? [];
        for (var item in links) {
          if (item['network'] == keys[keys.length - 1]) return item['url'];
        }
      }
      for (var i = 0; i < keys.length - 1; i++) {
        if (data![keys[i]] is Map) {
          data = data[keys[i]];
        } else {
          return null;
        }
      }
      if (data![keys[keys.length - 1]].toString().isEmpty) return null;
      return data[keys[keys.length - 1]];
    } catch (err, trace) {
      //printError(err, trace);
      return 'Error when mapping $key';
    }
  }

  static void showSnackBar(ScaffoldMessengerState? state, message) {
    if (state != null) {
      state.showSnackBar(SnackBar(content: Text(message)));
    }
  }


  static String? prepareURL(String? url) {
    if (url == null) {
      return null;
    }

    final uri = Uri.tryParse(url);
    if (uri == null) {
      return null;
    }

    if (!url.startsWith('http') && uri.scheme.isEmpty) {
      return 'https://$url';
    }

    if (url.startsWith('intent://') && url.contains('scheme=')) {
      final intentInfo = url.substring(url.indexOf('scheme='));
      final scheme = intentInfo.substring(
          intentInfo.indexOf('scheme=') + 7, intentInfo.indexOf(';'));
      return url.replaceFirst('intent://', '$scheme://');
    }

    return url;
  }

  static Future<dynamic> parseJsonFromAssets(String assetsPath) async {
    return rootBundle.loadString(assetsPath).then(jsonDecode);
  }

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }


  static String? convertDateTime(DateTime date) {
    return DateFormat.yMd().add_jm().format(date);
  }

  static String? getTimeWith2Digit(String time) {
    return time.length == 1 ? '0$time' : time;
  }


  static double calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    var distance = 12742 * asin(sqrt(a));
    return distance.roundToDouble();
  }

  static dynamic formatDate(String date) {
    var dateFormat = DateFormat(DateFormat.YEAR_MONTH_DAY);
    return dateFormat.format(DateTime.tryParse(date) ?? DateTime.now());
  }

  static dynamic formatDateToLocal(String date) {
    var dateFormat = DateFormat(DateFormat.YEAR_MONTH_DAY);
    return dateFormat
        .format(DateTime.tryParse(date)?.toLocal() ?? DateTime.now());
  }


  static FontWeight getFontWeight(
    dynamic fontWeight, {
    FontWeight? defaultValue,
  }) {
    var fontWeightVal = '$fontWeight';
    switch (fontWeightVal) {
      case '100':
        return FontWeight.w100;
      case '200':
        return FontWeight.w200;
      case '300':
        return FontWeight.w300;
      case '400':
        return FontWeight.w400;
      case '500':
        return FontWeight.w500;
      case '600':
        return FontWeight.w600;
      case '700':
        return FontWeight.w700;
      case '800':
        return FontWeight.w800;
      case '900':
        return FontWeight.w900;
      default:
        return defaultValue ?? FontWeight.w400;
    }
  }

  static AlignmentGeometry getAlignment(
    String? alignment, {
    AlignmentGeometry? defaultValue,
  }) {
    switch (alignment) {
      case 'left':
      case 'centerLeft':
      case 'centerStart':
      case 'start':
        return AlignmentDirectional.centerStart;
      case 'right':
      case 'centerRight':
      case 'centerEnd':
      case 'end':
        return AlignmentDirectional.centerEnd;
      case 'topLeft':
      case 'topStart':
        return AlignmentDirectional.topStart;
      case 'topRight':
      case 'topEnd':
        return AlignmentDirectional.topEnd;
      case 'bottomLeft':
      case 'bottomStart':
        return AlignmentDirectional.bottomStart;
      case 'bottomRight':
      case 'bottomEnd':
        return AlignmentDirectional.bottomEnd;
      case 'bottom':
      case 'bottomCenter':
        return AlignmentDirectional.bottomCenter;
      case 'top':
      case 'topCenter':
        return AlignmentDirectional.topCenter;
      case 'center':
        return AlignmentDirectional.center;
      default:
        return defaultValue ?? AlignmentDirectional.center;
    }
  }
  static double? checkDouble(dynamic value) {
    if(value is double) return value;
    if(value is int) return value.toDouble();
    if(value is String) return double.tryParse(value);
    return null;
  }
  static int? checkInt(dynamic value) {
    if(value is int) return value;
    if(value is double) return value.toInt();
    if(value is String) return int.tryParse(value);
    return null;
  }

  static DateTime stringtoDate(String date,String format){
    try{
      DateTime parseDate =
      new DateFormat(format).parse(date);
      return parseDate;
    }catch (e){
      return DateTime.now();
    }
  }

  static String getCurrencyCode(dynamic number){
    if(selectedLanguage == "ar")
      return "${formatPrice(number)} ج.م.";
    else
      return "EGP${formatPrice(number)}";
  }

  /// Money for display with two decimals: 149.95, 100.00.
  static String formatPrice(dynamic value) {
    final number = JsonParser.toNum(value);
    return number == null ? (value?.toString() ?? '') : number.toStringAsFixed(2);
  }

  /// Quantities and percentages without trailing zeros: 2, 2.5.
  static String formatQty(dynamic value) {
    final number = JsonParser.toNum(value);
    if (number == null) return value?.toString() ?? '';
    return number == number.truncate() ? number.toInt().toString() : number.toString();
  }

  static String getOrderStatus(BuildContext context,String status){
    if(status.toLowerCase() == "pending"){
      return AppLocalizations.of(context)!.orderStatusPending;
    }else if(status.toLowerCase() == "complete"){
      return AppLocalizations.of(context)!.orderStatusCompleted;
    }else if(status.toLowerCase() == "processing"){
      return AppLocalizations.of(context)!.orderStatusProcessing;
    }else if(["canceled", "cancelled"].contains(status.toLowerCase())){
      return AppLocalizations.of(context)!.orderStatusCancelled;
    }
    return status;
  }
}
