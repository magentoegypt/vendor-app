part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordState extends Equatable {}

class ForgotPasswordInitial extends ForgotPasswordState {
  @override
  List<Object?> get props => [];
}

class ForgotPasswordLoading extends ForgotPasswordState {
  @override
  List<Object?> get props => [];
}

class ForgotPasswordLoaded extends ForgotPasswordState {
  final MobileOTPModel mobileOTPModel;

  ForgotPasswordLoaded({
    required this.mobileOTPModel,
  });

  @override
  List<Object?> get props => [mobileOTPModel];
}

class SendMobileOTPLoaded extends ForgotPasswordState {
  final MobileOTPModel mobileOTPModel;

  SendMobileOTPLoaded({
    required this.mobileOTPModel,
  });

  @override
  List<Object?> get props => [mobileOTPModel];
}

class VerifyMobileOTPLoaded extends ForgotPasswordState {
  final MobileOTPModel mobileOTPModel;

  VerifyMobileOTPLoaded({
    required this.mobileOTPModel,
  });

  @override
  List<Object?> get props => [mobileOTPModel];
}

class ForgotPasswordError extends ForgotPasswordState {
  final String errorMessage;
  ForgotPasswordError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
