// throw an Exception while looking for the Store Info Data
import 'package:multi_vendor/features/auth/forgot_password_feature/data/MobileOTPModel.dart';

import 'otp_api_service.dart';

class ForgotPasswordRepositoryException implements Exception {}

class ForgotPasswordRepository {
  ForgotPasswordRepository({OTPApiService? service})
      : _service = service ?? OTPApiService();
  final OTPApiService _service;

  Future<MobileOTPModel> requestForgotPassword({
    required Map<String, dynamic> requestValueMap,
  }) async {
    try {
      return _service.forgotPassword(
        requestValueMap: requestValueMap,
      );
    } on Exception {
      throw ForgotPasswordRepositoryException();
    }
  }

  Future<MobileOTPModel> sendMobileOTP({
    required Map<String, dynamic> requestValueMap,
  }) async {
    try {
      return _service.sendMobileOTP(
        requestValueMap: requestValueMap,
      );
    } on Exception {
      throw ForgotPasswordRepositoryException();
    }
  }

  Future<MobileOTPModel> verifyMobileOTP({
    required Map<String, dynamic> requestValueMap,
  }) async {
    try {
      return _service.verifyMobileOTP(
        requestValueMap: requestValueMap,
      );
    } on Exception {
      throw ForgotPasswordRepositoryException();
    }
  }
}
