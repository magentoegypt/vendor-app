part of 'reset_password_bloc.dart';

@immutable
abstract class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  @override
  List<Object> get props => [];
}

class PerformSendMobileOTP extends ResetPasswordEvent {
  final Map<String, dynamic> requestValueMap;

  const PerformSendMobileOTP({
    required this.requestValueMap,
  });

  @override
  List<Object> get props => [requestValueMap];
}

class PerformVerifyMobileOTP extends ResetPasswordEvent {
  final Map<String, dynamic> requestValueMap;

  const PerformVerifyMobileOTP({
    required this.requestValueMap,
  });

  @override
  List<Object> get props => [requestValueMap];
}
