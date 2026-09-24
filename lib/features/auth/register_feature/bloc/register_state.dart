part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {}

class RegisterInitial extends RegisterState {
  @override
  List<Object?> get props => [];
}

class RegisterLoading extends RegisterState {
  @override
  List<Object?> get props => [];
}

class CountriesLoaded extends RegisterState {
  final List<CountryListModel> list;

  CountriesLoaded({
    required this.list,
  });

  @override
  List<Object?> get props => [list];
}

class RegisterLoaded extends RegisterState {
  final String token;
  final bool isRegister;
  final SignUpModel userInfo;

  RegisterLoaded({
    required this.token,
    required this.isRegister,
    required this.userInfo,
  });

  @override
  List<Object?> get props => [token, isRegister, userInfo];
}

class SendMobileOTPLoaded extends RegisterState {
  final MobileOTPModel mobileOTPModel;

  SendMobileOTPLoaded({
    required this.mobileOTPModel,
  });

  @override
  List<Object?> get props => [mobileOTPModel];
}

class VerifyMobileOTPLoaded extends RegisterState {
  final MobileOTPModel mobileOTPModel;

  VerifyMobileOTPLoaded({
    required this.mobileOTPModel,
  });

  @override
  List<Object?> get props => [mobileOTPModel];
}

class RegisterError extends RegisterState {
  final String errorMessage;
  RegisterError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
