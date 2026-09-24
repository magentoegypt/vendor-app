// throw an Exception while looking for the Store Info Data
import '../../../../features/auth/register_feature/data/CountryListModel.dart';
import '../../../../features/auth/register_feature/data/register_api_service.dart';

import '../../forgot_password_feature/data/MobileOTPModel.dart';
import '../../forgot_password_feature/data/otp_api_service.dart';
import 'SignUpModel.dart';

class RegisterRepositoryException implements Exception {}

class RegisterRepository {
  RegisterRepository({RegisterApiService? service})
      : _service = service ?? RegisterApiService();
  final RegisterApiService _service;
  final OTPApiService otpApiService = OTPApiService();
  Future<SignUpModel> requestUserRegister({
    required Map<String, dynamic> requestValueMap,
  }) async {
    try {
      return _service.postUserRegisterData(
        requestValueMap: requestValueMap,
      );
    } on Exception {
      throw RegisterRepositoryException();
    }
  }

  Future<List<CountryListModel>> getCountries() async {
    try {
      return _service.getCountriesData();
    } on Exception {
      throw RegisterRepositoryException();
    }
  }

  Future<MobileOTPModel> sendMobileOTP({
    required Map<String, dynamic> requestValueMap,
  }) async {
    try {
      return otpApiService.sendMobileOTP(
        requestValueMap: requestValueMap,
      );
    } on Exception {
      throw RegisterRepositoryException();
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
      throw RegisterRepositoryException();
    }
  }
}
