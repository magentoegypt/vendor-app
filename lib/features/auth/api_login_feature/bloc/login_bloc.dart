import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/config/pref_keys.dart';
import '../../../../core/helper/shared_preferences_helpers.dart';
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
      final userInfo = await repository.requestUserLogin(
        requestValueMap: event.requestValueMap,
      );

      // Save Token in Shared Preferences
      _sharedPrefKeys.setStringData(
          key: authTokenPrefKey, text: userInfo);
      _sharedPrefKeys.setIntData(
          key: initScreenPrefKey, id: 1);
      //
      // // Save Email in Shared Preferences
      // _sharedPrefKeys.setStringData(
      //     key: userEmailPrefKey,
      //     text: '${userInfo.body?.readableCustomer?.emailAddress ?? ""}');
      //
      // // Save Email in Shared Preferences
      // _sharedPrefKeys.setIntData(
      //     key: userIDPrefKey, id: userInfo.body?.id ?? 0);
      emit(LoginLoaded(userToken: userInfo));
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
        _sharedPrefKeys.setStringData(
            key: authTokenPrefKey, text: mobileOTPModel.token ?? "");
        _sharedPrefKeys.setIntData(
            key: initScreenPrefKey, id: 1);
      }
      emit(VerifyMobileOTPLoaded(mobileOTPModel: mobileOTPModel));
    } on Exception catch (e) {
      emit(LoginError(errorMessage: e.toString()));
    }
  }
}
