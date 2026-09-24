import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:multi_vendor/core/config/pref_keys.dart';
import 'package:multi_vendor/features/auth/api_login_feature/bloc/login_bloc.dart';
import 'package:multi_vendor/features/auth/api_login_feature/data/login_api_service.dart';
import 'package:multi_vendor/features/auth/api_login_feature/data/login_repository.dart';
import 'package:multi_vendor/features/auth/forgot_password_feature/data/MobileOTPModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Answers the customer-token and vendors/me endpoints with canned responses.
http.Client fakeApi({
  int tokenStatus = 200,
  int vendorStatus = 200,
  String vendorError = '{"message":"Vendor not found"}',
}) {
  return MockClient((request) async {
    if (request.url.path.endsWith('/integration/customer/token')) {
      return tokenStatus == 200
          ? http.Response('"email-token"', 200)
          : http.Response(
              '{"message":"The account sign-in was incorrect."}', tokenStatus);
    }
    if (request.url.path.endsWith('/vendors/me')) {
      return vendorStatus == 200
          ? http.Response('{"id": 4, "vendor_id": "v4", "email": "v@x.test"}', 200)
          : http.Response(vendorError, vendorStatus);
    }
    return http.Response('{}', 404);
  });
}

/// The OTP service is not injectable, so the verify step is stubbed here.
class OtpVerifiedRepository extends LoginRepository {
  OtpVerifiedRepository(http.Client client)
      : super(service: LoginApiService(httpClient: client));

  @override
  Future<MobileOTPModel> verifyMobileOTP({
    required Map<String, dynamic> requestValueMap,
  }) async =>
      MobileOTPModel(status: 'success', message: 'ok', token: 'otp-token');
}

Future<List<LoginState>> run(LoginBloc bloc, LoginEvent event) async {
  final states = <LoginState>[];
  final subscription = bloc.stream.listen(states.add);
  bloc.add(event);
  await Future<void>.delayed(const Duration(milliseconds: 50));
  await subscription.cancel();
  await bloc.close();
  return states;
}

const emailLogin = PerformUserLogin(
    requestValueMap: {'username': 'v@x.test', 'password': 'secret'});
const otpLogin = PerformVerifyMobileOTP(
    requestValueMap: {'mobile': '201000000000', 'otp': '123456'});

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<String?> storedToken() async =>
      (await SharedPreferences.getInstance()).getString(authTokenPrefKey);

  group('Login (86d4b0z85)', () {
    test('email login stores the session only after vendors/me succeeds',
        () async {
      final bloc = LoginBloc(
          repository: LoginRepository(
              service: LoginApiService(httpClient: fakeApi())));

      final states = await run(bloc, emailLogin);

      expect(states.last, isA<LoginLoaded>());
      expect(await storedToken(), 'email-token');
    });

    test('defect A: accepted password but rejected vendor is reported as such',
        () async {
      final bloc = LoginBloc(
          repository: LoginRepository(
              service: LoginApiService(httpClient: fakeApi(vendorStatus: 401))));

      final states = await run(bloc, emailLogin);

      expect(states.last, isA<VendorAccountError>());
      expect((states.last as VendorAccountError).statusCode, 401);
      expect(await storedToken(), isNull);
    });

    test('a 403 carries the server reason, such as pending approval', () async {
      final bloc = LoginBloc(
          repository: LoginRepository(
              service: LoginApiService(
                  httpClient: fakeApi(
                      vendorStatus: 403,
                      vendorError:
                          '{"message":"Your seller account is pending approval."}'))));

      final states = await run(bloc, emailLogin);

      final error = states.last as VendorAccountError;
      expect(error.statusCode, 403);
      expect(error.message, 'Your seller account is pending approval.');
      expect(await storedToken(), isNull);
    });

    test('wrong password still shows the server message', () async {
      final bloc = LoginBloc(
          repository: LoginRepository(
              service: LoginApiService(httpClient: fakeApi(tokenStatus: 401))));

      final states = await run(bloc, emailLogin);

      expect(states.last, isA<LoginError>());
      expect((states.last as LoginError).errorMessage,
          contains('sign-in was incorrect'));
    });

    test('defect B: OTP login with a rejected vendor stays and explains why',
        () async {
      final bloc =
          LoginBloc(repository: OtpVerifiedRepository(fakeApi(vendorStatus: 404)));

      final states = await run(bloc, otpLogin);

      // Before the fix this emitted VerifyMobileOTPLoaded(success), the view
      // navigated to the dashboard, and its first call bounced back to login.
      expect(states.whereType<VerifyMobileOTPLoaded>(), isEmpty);
      expect(states.last, isA<VendorAccountError>());
      expect(await storedToken(), isNull);
    });

    test('OTP login with a valid vendor stores the OTP token', () async {
      final bloc = LoginBloc(repository: OtpVerifiedRepository(fakeApi()));

      final states = await run(bloc, otpLogin);

      expect(states.last, isA<VerifyMobileOTPLoaded>());
      expect(await storedToken(), 'otp-token');
    });
  });
}
