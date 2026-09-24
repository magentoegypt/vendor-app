part of 'reset_password_bloc.dart';

abstract class ResetPasswordState extends Equatable {}

class ResetPasswordInitial extends ResetPasswordState {
  @override
  List<Object?> get props => [];
}

class ResetPasswordLoading extends ResetPasswordState {
  @override
  List<Object?> get props => [];
}

class SendMobileOTPLoaded extends ResetPasswordState {
  final MobileOTPModel mobileOTPModel;

  SendMobileOTPLoaded({
    required this.mobileOTPModel,
  });

  @override
  List<Object?> get props => [mobileOTPModel];
}

class VerifyMobileOTPLoaded extends ResetPasswordState {
  final MobileOTPModel mobileOTPModel;

  VerifyMobileOTPLoaded({
    required this.mobileOTPModel,
  });

  @override
  List<Object?> get props => [mobileOTPModel];
}

class ResetPasswordError extends ResetPasswordState {
  final String errorMessage;
  ResetPasswordError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
