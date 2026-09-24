import 'package:get_it/get_it.dart';
import 'package:stacked_services/stacked_services.dart';

import '../helper/shared_preferences_helpers.dart';
export 'package:flutter_gen/gen_l10n/app_localizations.dart';
/// get the Instance of Dependency Injection GetIT
GetIt locator = GetIt.instance;

/// Register all Services to be used in app
void setupLocator() {
  locator
    ..registerLazySingleton(() => NavigationService())
    ..registerLazySingleton(() => DialogService())
    ..registerLazySingleton(() => SnackbarService())
    ..registerLazySingleton(() => BottomSheetService())
    ..registerLazySingleton(() => SharedPreferencesHelpers());
}
