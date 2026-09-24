part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {}

class ProfileInitial extends ProfileState {
  @override
  List<Object?> get props => [];
}

class ProfileLoading extends ProfileState {
  @override
  List<Object?> get props => [];
}

class CountriesLoaded extends ProfileState {
  final List<CountryListModel> list;

  CountriesLoaded({
    required this.list,
  });

  @override
  List<Object?> get props => [list];
}

class DeleteVendorLoaded extends ProfileState {
  final bool isDelete;

  DeleteVendorLoaded({
    required this.isDelete,
  });

  @override
  List<Object?> get props => [isDelete];
}

class ProfileLoaded extends ProfileState {
  final UserModel userInfo;

  ProfileLoaded({
    required this.userInfo,
  });

  @override
  List<Object?> get props => [userInfo];
}

class SendMobileOTPLoaded extends ProfileState {
  final MobileOTPModel mobileOTPModel;

  SendMobileOTPLoaded({
    required this.mobileOTPModel,
  });

  @override
  List<Object?> get props => [mobileOTPModel];
}

class VerifyMobileOTPLoaded extends ProfileState {
  final MobileOTPModel mobileOTPModel;

  VerifyMobileOTPLoaded({
    required this.mobileOTPModel,
  });

  @override
  List<Object?> get props => [mobileOTPModel];
}

class ProfileError extends ProfileState {
  final String errorMessage;
  ProfileError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
