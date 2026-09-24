part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class PerformUserRegister extends RegisterEvent {
  final Map<String, dynamic> requestValueMap;

  const PerformUserRegister({
    required this.requestValueMap,
  });

  @override
  List<Object> get props => [requestValueMap];
}

class PerformSendMobileOTP extends RegisterEvent {
  final Map<String, dynamic> requestValueMap;

  const PerformSendMobileOTP({
    required this.requestValueMap,
  });

  @override
  List<Object> get props => [requestValueMap];
}

class PerformVerifyMobileOTP extends RegisterEvent {
  final Map<String, dynamic> requestValueMap;

  const PerformVerifyMobileOTP({
    required this.requestValueMap,
  });

  @override
  List<Object> get props => [requestValueMap];
}

class PerformCountriesList extends RegisterEvent {

  const PerformCountriesList();

  @override
  List<Object> get props => [];
}