import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../auth/forgot_password_feature/data/MobileOTPModel.dart';
import '../../auth/register_feature/data/CountryListModel.dart';
import '../../home/data/UserModel.dart';
import '../data/profile_repository.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required this.repository}) : super(ProfileInitial()) {
    on<PerformUserProfile>(_onPerformUserProfile);
    on<PerformCountriesList>(_onPerformCountriesList);
    on<PerformSendMobileOTP>(_onPerformSendMobileOTP);
    on<PerformVerifyMobileOTP>(_onPerformVerifyMobileOTP);
    on<PerformDeleteVendor>(_onPerformDeleteVendor);
  }

  final ProfileRepository repository;

  void _onPerformUserProfile(event, emit) async {
    try {
      // emit the loading state
      emit(ProfileLoading());

      final result = await repository.requestUserProfile(
        requestValueMap: event.requestValueMap,
      );

      // emit ProfileLoaded State
      emit(ProfileLoaded(userInfo: result));
    } on Exception catch (e) {
      emit(ProfileError(errorMessage: e.toString()));
    }
  }

  void _onPerformCountriesList(event, emit) async {
    try {
      emit(ProfileLoading());
      final result = await repository.getCountires();
      emit(CountriesLoaded(list: result));
    } on Exception catch (e) {
      emit(ProfileError(errorMessage: e.toString()));
    }
  }

  void _onPerformDeleteVendor(event, emit) async {
    try {
      emit(ProfileLoading());
      final result = await repository.deleteVendorData(vendorId: event.vendorId);
      emit(DeleteVendorLoaded(isDelete: result));
    } on Exception catch (e) {
      emit(ProfileError(errorMessage: e.toString()));
    }
  }

  void _onPerformSendMobileOTP(PerformSendMobileOTP event, emit) async {
    try {
      // emit the loading state
      emit(ProfileLoading());

      final mobileOTPModel = await repository.sendMobileOTP(
        requestValueMap: event.requestValueMap,
      );
      emit(SendMobileOTPLoaded(mobileOTPModel: mobileOTPModel));
    } on Exception catch (e) {
      emit(ProfileError(errorMessage: e.toString()));
    }
  }

  void _onPerformVerifyMobileOTP(PerformVerifyMobileOTP event, emit) async {
    try {
      // emit the loading state
      emit(ProfileLoading());

      final mobileOTPModel = await repository.verifyMobileOTP(
        requestValueMap: event.requestValueMap,
      );
      emit(VerifyMobileOTPLoaded(mobileOTPModel: mobileOTPModel));
    } on Exception catch (e) {
      emit(ProfileError(errorMessage: e.toString()));
    }
  }

}
