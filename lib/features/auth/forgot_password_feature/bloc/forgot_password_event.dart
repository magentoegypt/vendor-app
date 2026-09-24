part of 'forgot_password_bloc.dart';

@immutable
abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object> get props => [];
}

class PerformForgotPassword extends ForgotPasswordEvent {
  final Map<String, dynamic> requestValueMap;

  const PerformForgotPassword({
    required this.requestValueMap,
  });

  @override
  List<Object> get props => [requestValueMap];
}

class PerformSendMobileOTP extends ForgotPasswordEvent {
  final Map<String, dynamic> requestValueMap;

  const PerformSendMobileOTP({
    required this.requestValueMap,
  });

  @override
  List<Object> get props => [requestValueMap];
}

class PerformVerifyMobileOTP extends ForgotPasswordEvent {
  final Map<String, dynamic> requestValueMap;

  const PerformVerifyMobileOTP({
    required this.requestValueMap,
  });

  @override
  List<Object> get props => [requestValueMap];
}