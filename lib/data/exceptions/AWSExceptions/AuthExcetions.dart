import 'package:amazon_cognito_identity_dart_2/cognito.dart';

class ForceRequireNewPassword implements Exception {
  final CognitoUserNewPasswordRequiredException exception;
  ForceRequireNewPassword(this.exception);
}

class IncorrectCredentialsException implements Exception {
  final CognitoClientException exception;
  IncorrectCredentialsException(this.exception);
}

class UserNotConfirmedException implements Exception {
  final CognitoClientException exception;
  UserNotConfirmedException(this.exception);
  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }
}
