// throw an Exception while looking for the Store Info Data

import '../../forgot_password_feature/data/MobileOTPModel.dart';
import '../../forgot_password_feature/data/otp_api_service.dart';
import 'login_api_service.dart';

class LoginRepositoryException implements Exception {}

class LoginRepository {
  LoginRepository({LoginApiService? service})
      : _service = service ?? LoginApiService();
  final LoginApiService _service;

  Future<String> requestUserLogin({
    required Map<String, dynamic> requestValueMap,
  }) async {
    try {
      return _service.postUserLoginData(
        requestValueMap: requestValueMap,
      );
    } on Exception {
      throw LoginRepositoryException();
    }
  }

  final OTPApiService otpApiService = OTPApiService();

  Future<MobileOTPModel> sendMobileOTP({
    required Map<String, dynamic> requestValueMap,
  }) async {
    try {
      return otpApiService.sendMobileOTP(
        requestValueMap: requestValueMap,
      );
    } on Exception {
      throw LoginRepositoryException();
    }
  }

  Future<MobileOTPModel> verifyMobileOTP({
    required Map<String, dynamic> requestValueMap,
  }) async {
    try {
      return otpApiService.verifyMobileOTP(
        requestValueMap: requestValueMap,
      );
    } on Exception {
      throw LoginRepositoryException();
    }
  }
}
