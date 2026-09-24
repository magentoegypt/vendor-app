import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../features/auth/register_feature/data/CountryListModel.dart';
import '../../../../features/auth/register_feature/data/SignUpModel.dart';
import '../../../../core/config/pref_keys.dart';
import '../../../../core/helper/shared_preferences_helpers.dart';
import '../../forgot_password_feature/data/MobileOTPModel.dart';
import '../data/register_repository.dart';
part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({required this.repository}) : super(RegisterInitial()) {
    on<PerformUserRegister>(_onPerformUserRegister);
    on<PerformCountriesList>(_onPerformCountriesList);
    on<PerformSendMobileOTP>(_onPerformSendMobileOTP);
    on<PerformVerifyMobileOTP>(_onPerformVerifyMobileOTP);
  }

  final RegisterRepository repository;

  void _onPerformUserRegister(event, emit) async {
    try {
      // emit the loading state
      emit(RegisterLoading());

      final result = await repository.requestUserRegister(
        requestValueMap: event.requestValueMap,
      );

      // Save Token in Shared Preference
      await SharedPreferencesHelpers()
          .setStringData(key: authTokenPrefKey, text: "");
      // emit RegisterLoaded State
      emit(RegisterLoaded(
          isRegister: true, token: result.customer?.email ?? "", userInfo: result));
    } on Exception catch (e) {
      emit(RegisterError(errorMessage: e.toString()));
    }
  }

  void _onPerformCountriesList(event, emit) async {
    try {
      emit(RegisterLoading());
      final result = await repository.getCountries();
      emit(CountriesLoaded(list: result));
    } on Exception catch (e) {
      emit(RegisterError(errorMessage: e.toString()));
    }
  }

  void _onPerformSendMobileOTP(PerformSendMobileOTP event, emit) async {
    try {
      // emit the loading state
      emit(RegisterLoading());

      final mobileOTPModel = await repository.sendMobileOTP(
        requestValueMap: event.requestValueMap,
      );
      emit(SendMobileOTPLoaded(mobileOTPModel: mobileOTPModel));
    } on Exception catch (e) {
      emit(RegisterError(errorMessage: e.toString()));
    }
  }

  void _onPerformVerifyMobileOTP(PerformVerifyMobileOTP event, emit) async {
    try {
      // emit the loading state
      emit(RegisterLoading());

      final mobileOTPModel = await repository.verifyMobileOTP(
        requestValueMap: event.requestValueMap,
      );
      emit(VerifyMobileOTPLoaded(mobileOTPModel: mobileOTPModel));
    } on Exception catch (e) {
      emit(RegisterError(errorMessage: e.toString()));
    }
  }

}
