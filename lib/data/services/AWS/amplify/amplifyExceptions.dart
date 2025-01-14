class AmplifyExceptions implements Exception {
  final String message;

  AmplifyExceptions([this.message = "An unknown error occurred"]);

  @override
  String toString() => message;
}

// Incorrect password exception
class IncorrectPasswordException extends AmplifyExceptions {
  IncorrectPasswordException() : super("Incorrect password.");
}

// Account already exists exception
class AccountAlreadyExistsException extends AmplifyExceptions {
  AccountAlreadyExistsException()
      : super("An account with this username already exists.");
}

// Sign-up confirmation required exception
class SignUpConfirmationRequiredException extends AmplifyExceptions {
  SignUpConfirmationRequiredException()
      : super("Sign-up confirmation is required.");
}

// Code expired exception
class CodeExpiredException extends AmplifyExceptions {
  CodeExpiredException() : super("The confirmation code has expired.");
}

// Too many attempts exception
class TooManyAttemptsException extends AmplifyExceptions {
  TooManyAttemptsException()
      : super("Too many incorrect attempts. Please try again later.");
}
