import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/config/app_exceptions.dart';
import '../../../../core/config/pref_keys.dart';
import '../../../../core/helper/shared_preferences_helpers.dart';
import '../../../home/data/UserModel.dart';
import '../../forgot_password_feature/data/MobileOTPModel.dart';
import '../data/login_repository.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required this.repository}) : super(LoginInitial()) {
    on<PerformUserLogin>(_onPerformUserLogin);
    on<PerformSendMobileOTP>(_onPerformSendMobileOTP);
    on<PerformVerifyMobileOTP>(_onPerformVerifyMobileOTP);
  }

  final LoginRepository repository;

  final SharedPreferencesHelpers _sharedPrefKeys = SharedPreferencesHelpers();

  void _onPerformUserLogin(PerformUserLogin event, emit) async {
    try {
      // emit the loading state
      emit(LoginLoading());
      final userToken = await repository.requestUserLogin(
        requestValueMap: event.requestValueMap,
      );
      final vendor = await repository.requestVendor(token: userToken);
      await _saveSession(userToken, vendor);
      emit(LoginLoaded(userToken: userToken));
    } on VendorAccountException catch (e) {
      emit(VendorAccountError(statusCode: e.statusCode, message: e.serverMessage));
    } on Exception catch (e) {
      emit(LoginError(errorMessage: e.toString()));
    }
  }

  void _onPerformSendMobileOTP(PerformSendMobileOTP event, emit) async {
    try {
      // emit the loading state
      emit(LoginLoading());

      final mobileOTPModel = await repository.sendMobileOTP(
        requestValueMap: event.requestValueMap,
      );
      emit(SendMobileOTPLoaded(mobileOTPModel: mobileOTPModel));
    } on Exception catch (e) {
      emit(LoginError(errorMessage: e.toString()));
    }
  }

  void _onPerformVerifyMobileOTP(PerformVerifyMobileOTP event, emit) async {
    try {
      // emit the loading state
      emit(LoginLoading());

      final mobileOTPModel = await repository.verifyMobileOTP(
        requestValueMap: event.requestValueMap,
      );
      if(mobileOTPModel.status == "success"){
        // Same check as the email login: the OTP token must open the vendor
        // account, otherwise the dashboard's first call bounces back here.
        final userToken = mobileOTPModel.token ?? "";
        final vendor = await repository.requestVendor(token: userToken);
        await _saveSession(userToken, vendor);
      }
      emit(VerifyMobileOTPLoaded(mobileOTPModel: mobileOTPModel));
    } on VendorAccountException catch (e) {
      emit(VendorAccountError(statusCode: e.statusCode, message: e.serverMessage));
    } on Exception catch (e) {
      emit(LoginError(errorMessage: e.toString()));
    }
  }

  /// Awaited so the dashboard never reads the token before it is stored.
  Future<void> _saveSession(String userToken, UserModel vendor) async {
    await _sharedPrefKeys.setStringData(key: authTokenPrefKey, text: userToken);
    await _sharedPrefKeys.setStringData(
        key: userPrefKey, text: jsonEncode(vendor.toJson()));
    await _sharedPrefKeys.setIntData(key: initScreenPrefKey, id: 1);
  }
}
