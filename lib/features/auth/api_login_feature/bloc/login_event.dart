part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class PerformUserLogin extends LoginEvent {
  final Map<String, dynamic> requestValueMap;

  const PerformUserLogin({
    required this.requestValueMap,
  });

  @override
  List<Object> get props => [requestValueMap];
}

class PerformSendMobileOTP extends LoginEvent {
  final Map<String, dynamic> requestValueMap;

  const PerformSendMobileOTP({
    required this.requestValueMap,
  });

  @override
  List<Object> get props => [requestValueMap];
}

class PerformVerifyMobileOTP extends LoginEvent {
  final Map<String, dynamic> requestValueMap;

  const PerformVerifyMobileOTP({
    required this.requestValueMap,
  });

  @override
  List<Object> get props => [requestValueMap];
}
