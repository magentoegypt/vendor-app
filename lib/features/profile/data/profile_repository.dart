// throw an Exception while looking for the Store Info Data


import 'package:multi_vendor/features/profile/data/profile_api_service.dart';
import '../../auth/forgot_password_feature/data/MobileOTPModel.dart';
import '../../auth/forgot_password_feature/data/otp_api_service.dart';
import '../../auth/register_feature/data/CountryListModel.dart';
import '../../home/data/UserModel.dart';

class ProfileRepositoryException implements Exception {}

class ProfileRepository {
  ProfileRepository({ProfileApiService? service})
      : _service = service ?? ProfileApiService();
  final ProfileApiService _service;
  final OTPApiService otpApiService = OTPApiService();
  Future<UserModel> requestUserProfile({
    required Map<String, dynamic> requestValueMap,
  }) async {
    try {
      return _service.postUserProfileData(
        requestValueMap: requestValueMap,
      );
    } on Exception {
      throw ProfileRepositoryException();
    }
  }

  Future<List<CountryListModel>> getCountires() async {
    try {
      return _service.getCountriesData();
    } on Exception {
      throw ProfileRepositoryException();
    }
  }

  Future<bool> deleteVendorData() async {
    try {
      return _service.deleteVendorData();
    } on Exception {
      throw ProfileRepositoryException();
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
      throw ProfileRepositoryException();
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
      throw ProfileRepositoryException();
    }
  }
}
