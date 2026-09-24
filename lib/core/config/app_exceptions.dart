class AppException implements Exception {
  AppException([this._message, this._prefix]);

  final dynamic _message;
  final dynamic _prefix;

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

/// Thrown if an exception occurs while making an `http` request.
class HttpException extends AppException {
  HttpException([String? message]) : super(message, '');
}

class HttpRequestFailure extends AppException {
  HttpRequestFailure([String? message]) : super(message, '');
}

class BadRequestException extends AppException {
  BadRequestException([dynamic message]) : super(message, 'Invalid Request: ');
}

class UnauthorizedException extends AppException {
  UnauthorizedException([dynamic message]) : super(message, 'Unauthorised: ');
}

class InvalidInputException extends AppException {
  InvalidInputException([dynamic message]) : super(message, 'Invalid Input: ');
}

/// Thrown when an error occurs while decoding the response body.
class JsonDecodeException extends AppException {
  JsonDecodeException([dynamic message])
      : super(message, 'Jsondecode Exception: ');
}

/// Thrown when an error occurs while deserializing the response body.
class JsonDeserializationException extends AppException {
  JsonDeserializationException([dynamic message])
      : super(message, 'JsonDeserializationException: ');
}

class ErrorEmptyResponse extends AppException {
  ErrorEmptyResponse([dynamic message])
      : super(message, 'ErrorEmptyResponse: ');
}

/// Thrown when login succeeded but the vendor account behind the token could
/// not be loaded (not a vendor, pending approval, or the vendor API failed).
class VendorAccountException extends AppException {
  VendorAccountException(this.statusCode, [this.serverMessage])
      : super(serverMessage ?? statusCode, 'VendorAccountException: ');

  final int statusCode;

  /// The server's reason, e.g. "Your seller account is pending approval".
  final String? serverMessage;
}
