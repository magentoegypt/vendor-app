import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:multi_vendor/core/config/app_constants.dart';
import 'package:multi_vendor/features/auth/forgot_password_feature/data/MobileOTPModel.dart';
import '../../../../core/config/app_exceptions.dart';
import '../../../../core/config/logger.dart';
import '../../../../core/helper/api_response_helper.dart';
import '../../../../core/helper/api_url_helpers.dart';
import '../../../../core/values/string_values.dart';

class OTPApiService {
  final http.Client _httpClient;

  OTPApiService({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  Future<MobileOTPModel> forgotPassword({
    required Map<String, dynamic> requestValueMap,
  }) async {
    final responseBody = await _forgotPassword(
      requestValueMap: requestValueMap,
    );

    try {
      MobileOTPModel mobileOTPModel = MobileOTPModel();
      if(responseBody == true){
        mobileOTPModel.status = "success";
        if(selectedLanguage == 'ar'){
          mobileOTPModel.message = "إذا كان هناك حساب مربوط ب ${requestValueMap["email"]} سوف تتلقى رسالة بريد إلكتروني مع رابط لإعادة تعيين كلمة المرور الخاصة بك.";
        }else{
          mobileOTPModel.message = "Please check your email.You will receive an email with a link to reset your password.";
        }
      }else{
        mobileOTPModel.status = "false";
      }
      return mobileOTPModel;
    } catch (exception, stackTrace) {
      //
      printLog(
        classFileName: 'OTPApiService',
        logType: LoggerType.e,
        message: '$exception\n$stackTrace',
      );
      throw JsonDeserializationException(['$exception']);
    }
  }

  /// get Data Functions
  Future<dynamic> _forgotPassword({
    required Map<String, dynamic> requestValueMap,
  }) async {
    try {
      final response = await _httpClient.put(
        Uri.parse(forgotPasswordApi),
        headers: <String, String>{
          'Content-Type': 'application/json'
        },
        body: json.encode(requestValueMap),
      );

      return apiResponseHelper(
        response: response,
        className: 'forgotPasswordApi',
        apiUrl: forgotPasswordApi,
        requestValue: '$requestValueMap',
        token: "",
      );
    } on SocketException {
      throw HttpException(StringValues.no_internet);
    } catch (exception) {
      throw HttpException('$exception');
    }
  }

  Future<MobileOTPModel> sendMobileOTP({
    required Map<String, dynamic> requestValueMap,
  }) async {
    final responseBody = await _sendMobileOTP(
      requestValueMap: requestValueMap,
    );

    try {
      return  MobileOTPModel.fromJson(responseBody);
    } catch (exception, stackTrace) {
      //
      printLog(
        classFileName: 'OTPApiService',
        logType: LoggerType.e,
        message: '$exception\n$stackTrace',
      );
      throw JsonDeserializationException(['$exception']);
    }
  }

  /// get Data Functions
  Future<dynamic> _sendMobileOTP({
    required Map<String, dynamic> requestValueMap,
  }) async {
    try {
      final response = await _httpClient.post(
        Uri.parse(sendOTPApi),
        headers: <String, String>{
          'Content-Type': 'application/json'
        },
        body: json.encode(requestValueMap),
      );

      return apiResponseHelper(
        response: response,
        className: 'OTPApiService',
        apiUrl: sendOTPApi,
        requestValue: '$requestValueMap',
        token: "",
      );
    } on SocketException {
      throw HttpException(StringValues.no_internet);
    } catch (exception) {
      throw HttpException('$exception');
    }
  }

  Future<MobileOTPModel> verifyMobileOTP({
    required Map<String, dynamic> requestValueMap,
  }) async {
    final responseBody = await _verifyMobileOTP(
      requestValueMap: requestValueMap,
    );

    try {
      return  MobileOTPModel.fromJson(responseBody);
    } catch (exception, stackTrace) {
      //
      printLog(
        classFileName: 'OTPApiService',
        logType: LoggerType.e,
        message: '$exception\n$stackTrace',
      );
      throw JsonDeserializationException(['$exception']);
    }
  }

  /// get Data Functions
  Future<dynamic> _verifyMobileOTP({
    required Map<String, dynamic> requestValueMap,
  }) async {
    try {
      final response = await _httpClient.post(
        Uri.parse(verifyOTPApi),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(requestValueMap),
      );

      return apiResponseHelper(
        response: response,
        className: 'OTPApiService',
        apiUrl: verifyOTPApi,
        requestValue: '$requestValueMap',
        token: "",
      );
    } on SocketException {
      throw HttpException(StringValues.no_internet);
    } catch (exception) {
      throw HttpException('$exception');
    }
  }
}
