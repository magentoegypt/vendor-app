import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor/features/auth/forgot_password_feature/data/MobileOTPModel.dart';
import '../data/forgot_password_repository.dart';
part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc({required this.repository}) : super(ForgotPasswordInitial()) {
    on<PerformSendMobileOTP>(_onPerformSendMobileOTP);
    on<PerformVerifyMobileOTP>(_onPerformVerifyMobileOTP);
    on<PerformForgotPassword>(_onPerformForgotPassword);
  }

  final ForgotPasswordRepository repository;

  void _onPerformForgotPassword(PerformForgotPassword event, emit) async {
    try {
      // emit the loading state
      emit(ForgotPasswordLoading());

      final mobileOTPModel = await repository.requestForgotPassword(
        requestValueMap: event.requestValueMap,
      );
      emit(ForgotPasswordLoaded(mobileOTPModel: mobileOTPModel));
    } on Exception catch (e) {
      emit(ForgotPasswordError(errorMessage: e.toString()));
    }
  }

  void _onPerformSendMobileOTP(PerformSendMobileOTP event, emit) async {
    try {
      // emit the loading state
      emit(ForgotPasswordLoading());

      final mobileOTPModel = await repository.sendMobileOTP(
        requestValueMap: event.requestValueMap,
      );
      emit(SendMobileOTPLoaded(mobileOTPModel: mobileOTPModel));
    } on Exception catch (e) {
      emit(ForgotPasswordError(errorMessage: e.toString()));
    }
  }

  void _onPerformVerifyMobileOTP(PerformVerifyMobileOTP event, emit) async {
    try {
      // emit the loading state
      emit(ForgotPasswordLoading());

      final mobileOTPModel = await repository.verifyMobileOTP(
        requestValueMap: event.requestValueMap,
      );
      emit(VerifyMobileOTPLoaded(mobileOTPModel: mobileOTPModel));
    } on Exception catch (e) {
      emit(ForgotPasswordError(errorMessage: e.toString()));
    }
  }
}
