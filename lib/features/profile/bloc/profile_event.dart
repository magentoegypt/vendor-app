part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class PerformUserProfile extends ProfileEvent {
  final Map<String, dynamic> requestValueMap;

  const PerformUserProfile({
    required this.requestValueMap,
  });

  @override
  List<Object> get props => [requestValueMap];
}

class PerformSendMobileOTP extends ProfileEvent {
  final Map<String, dynamic> requestValueMap;

  const PerformSendMobileOTP({
    required this.requestValueMap,
  });

  @override
  List<Object> get props => [requestValueMap];
}

class PerformVerifyMobileOTP extends ProfileEvent {
  final Map<String, dynamic> requestValueMap;

  const PerformVerifyMobileOTP({
    required this.requestValueMap,
  });

  @override
  List<Object> get props => [requestValueMap];
}

class PerformCountriesList extends ProfileEvent {

  const PerformCountriesList();

  @override
  List<Object> get props => [];
}

/// Deletes the signed-in vendor's own account (no id: the token decides).
class PerformDeleteVendor extends ProfileEvent {

  const PerformDeleteVendor();

  @override
  List<Object> get props => [];
}