import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/config/extensions.dart';
import '../../main.dart';
import '../../features/auth/api_login_feature/view/login_view.dart';
import '../config/app_exceptions.dart';
import '../config/logger.dart';

dynamic apiResponseHelper({
  required http.Response response,
  required String className,
  required String apiUrl,
  required String requestValue,
  required String token,
}) async {
  // print log the response
  printLog(
    classFileName: className,
    logType: LoggerType.w,
    message:
        'url:$apiUrl\nreq:$requestValue\nres:${response.statusCode}:${response.body}',
  );
  //
  'url:$apiUrl\nreq:$requestValue\nres:${response.statusCode}:${response.body}'
      .log();
  'url:$apiUrl\nreq:$requestValue\nres:${response.statusCode}:${response.body}'
      .log();
  'url:$apiUrl\nreq:$requestValue\nres:${response.statusCode}:${response.body}'
      .log();
  switch (response.statusCode) {
    case 200:
      try {
        return json.decode(response.body);
      } catch (exception, stackTrace) {
        '============ inside jsonDecodeException'.log();
        throw JsonDecodeException();
      }
    case 201:
      try {
        return json.decode(response.body);
      } catch (exception, stackTrace) {
        '============ inside jsonDecodeException'.log();
        throw JsonDecodeException();
      }
    case 202:
      try {
        return json.decode(response.body);
      } catch (exception, stackTrace) {
        '============ inside jsonDecodeException'.log();
        throw JsonDecodeException();
      }
    case 401:
      if(token.isEmpty){
        final decodedResponse = json.decode(response.body);
        throw HttpException(
            '${decodedResponse['message'] ?? ""} ${decodedResponse['details'] ?? ""}'); //: ${response.statusCode}
      }else{
        try {
          Navigator.pushAndRemoveUntil(
              navigatorKey.currentState!.context,
              MaterialPageRoute(
                builder: (context) => const SignInView(),
              ),
                  (e) => false);
          return json.decode(response.body);
        } catch (exception, stackTrace) {
          '============ inside jsonDecodeException'.log();
          throw JsonDecodeException();
        }
      }
    default:
      final decodedResponse = json.decode(response.body);
      throw HttpException(
          '${decodedResponse['message'] ?? ""} ${decodedResponse['parameters'] ?? ""} : ${response.statusCode}');
  }
}
