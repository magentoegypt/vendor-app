import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/config/extensions.dart';
import '../config/app_exceptions.dart';
import '../config/logger.dart';
import '../config/pref_keys.dart';
import 'shared_preferences_helpers.dart';

/// Runs after an authenticated request is rejected with 401 and the stored
/// session is cleared. main.dart points it at the login screen, which keeps
/// this helper free of widget imports.
void Function()? onSessionExpired;

dynamic apiResponseHelper({
  required http.Response response,
  required String className,
  required String apiUrl,
  required String requestValue,
  required String token,
}) async {
  // print log the response
  printLog(
    classFileName: className,
    logType: LoggerType.w,
    message:
        'url:$apiUrl\nreq:$requestValue\nres:${response.statusCode}:${response.body}',
  );
  //
  'url:$apiUrl\nreq:$requestValue\nres:${response.statusCode}:${response.body}'
      .log();
  'url:$apiUrl\nreq:$requestValue\nres:${response.statusCode}:${response.body}'
      .log();
  'url:$apiUrl\nreq:$requestValue\nres:${response.statusCode}:${response.body}'
      .log();
  switch (response.statusCode) {
    case 200:
      try {
        return json.decode(response.body);
      } catch (exception, stackTrace) {
        '============ inside jsonDecodeException'.log();
        throw JsonDecodeException();
      }
    case 201:
      try {
        return json.decode(response.body);
      } catch (exception, stackTrace) {
        '============ inside jsonDecodeException'.log();
        throw JsonDecodeException();
      }
    case 202:
      try {
        return json.decode(response.body);
      } catch (exception, stackTrace) {
        '============ inside jsonDecodeException'.log();
        throw JsonDecodeException();
      }
    case 401:
      if(token.isEmpty){
        final decodedResponse = json.decode(response.body);
        throw HttpException(
            '${decodedResponse['message'] ?? ""} ${decodedResponse['details'] ?? ""}'); //: ${response.statusCode}
      }else{
        // The stored token was rejected: end the session and let the app send
        // the vendor to login with a reason, instead of silently swapping
        // screens and handing the error body to the caller as data.
        final prefs = SharedPreferencesHelpers();
        await prefs.removeSingleKey(key: authTokenPrefKey);
        await prefs.removeSingleKey(key: userPrefKey);
        await prefs.setIntData(key: initScreenPrefKey, id: 0);
        onSessionExpired?.call();
        throw UnauthorizedException(response.statusCode);
      }
    default:
      final decodedResponse = json.decode(response.body);
      throw HttpException(
          '${decodedResponse['message'] ?? ""} ${decodedResponse['parameters'] ?? ""} : ${response.statusCode}');
  }
}

/// The readable text of a Magento REST error, or null when [body] is not one
/// (for example a CDN error page). Magento sends the phrase and its arguments
/// separately ({"message": "... contact %1.", "parameters": ["x"]}, or named
/// "%fieldName" placeholders with a parameters object), so they are
/// substituted here.
String? magentoErrorText(String body) {
  dynamic decoded;
  try {
    decoded = json.decode(body);
  } catch (_) {
    decoded = null;
  }
  if (decoded is! Map || decoded['message'] == null) {
    return null;
  }

  var message = decoded['message'].toString();
  final parameters = decoded['parameters'];
  if (parameters is List) {
    // Highest index first, so %1 does not eat the start of %10.
    for (var i = parameters.length; i >= 1; i--) {
      message = message.replaceAll('%$i', '${parameters[i - 1]}');
    }
  } else if (parameters is Map) {
    parameters.forEach((key, value) {
      message = message.replaceAll('%$key', '$value');
    });
  }
  final details = decoded['details'];
  return details == null ? message : '$message $details';
}
