part of 'login_bloc.dart';

abstract class LoginState extends Equatable {}

class LoginInitial extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginLoading extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginLoaded extends LoginState {
  final String userToken;

  LoginLoaded({
    required this.userToken,
  });

  @override
  List<Object?> get props => [userToken];
}

class SendMobileOTPLoaded extends LoginState {
  final MobileOTPModel mobileOTPModel;

  SendMobileOTPLoaded({
    required this.mobileOTPModel,
  });

  @override
  List<Object?> get props => [mobileOTPModel];
}

class VerifyMobileOTPLoaded extends LoginState {
  final MobileOTPModel mobileOTPModel;

  VerifyMobileOTPLoaded({
    required this.mobileOTPModel,
  });

  @override
  List<Object?> get props => [mobileOTPModel];
}

class LoginError extends LoginState {
  final String errorMessage;
  LoginError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

/// Credentials were accepted but the vendor account could not be loaded.
class VendorAccountError extends LoginState {
  final int statusCode;

  /// The server's reason, sent with 403 for pending, disabled, expired and
  /// non-seller accounts.
  final String? message;
  VendorAccountError({required this.statusCode, this.message});

  @override
  List<Object> get props => [statusCode, message ?? ''];
}
