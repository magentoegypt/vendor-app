import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../../core/helper/shared_preferences_helpers.dart';
import '../../forgot_password_feature/data/MobileOTPModel.dart';
import '../data/reset_password_repository.dart';
part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc({required this.repository}) : super(ResetPasswordInitial()) {
    on<PerformSendMobileOTP>(_onPerformSendMobileOTP);
    on<PerformVerifyMobileOTP>(_onPerformVerifyMobileOTP);
  }

  final ResetPasswordRepository repository;

  final SharedPreferencesHelpers _sharedPrefKeys = SharedPreferencesHelpers();


  void _onPerformSendMobileOTP(PerformSendMobileOTP event, emit) async {
    try {
      // emit the loading state
      emit(ResetPasswordLoading());

      final mobileOTPModel = await repository.sendMobileOTP(
        requestValueMap: event.requestValueMap,
      );
      emit(SendMobileOTPLoaded(mobileOTPModel: mobileOTPModel));
    } on Exception catch (e) {
      emit(ResetPasswordError(errorMessage: e.toString()));
    }
  }

  void _onPerformVerifyMobileOTP(PerformVerifyMobileOTP event, emit) async {
    try {
      // emit the loading state
      emit(ResetPasswordLoading());

      final mobileOTPModel = await repository.verifyMobileOTP(
        requestValueMap: event.requestValueMap,
      );
      emit(VerifyMobileOTPLoaded(mobileOTPModel: mobileOTPModel));
    } on Exception catch (e) {
      emit(ResetPasswordError(errorMessage: e.toString()));
    }
  }
}
