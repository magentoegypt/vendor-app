// throw an Exception while looking for the Store Info Data

import '../../forgot_password_feature/data/MobileOTPModel.dart';
import '../../forgot_password_feature/data/otp_api_service.dart';

class ResetPasswordRepositoryException implements Exception {}

class ResetPasswordRepository {
  ResetPasswordRepository({OTPApiService? service})
      : _service = service ?? OTPApiService();
  final OTPApiService _service;

  Future<MobileOTPModel> sendMobileOTP({
    required Map<String, dynamic> requestValueMap,
  }) async {
    try {
      return _service.sendMobileOTP(
        requestValueMap: requestValueMap,
      );
    } on Exception {
      throw ResetPasswordRepositoryException();
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
      throw ResetPasswordRepositoryException();
    }
  }
}
