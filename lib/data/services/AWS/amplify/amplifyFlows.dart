import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:moe/data/services/AWS/amplify/amplifyExceptions.dart';
import 'package:moe/data/services/NavigationServices.dart';
import 'package:moe/screens/views/authentication/confirmRegistrationModal.dart';
import 'package:moe/screens/views/authentication/resetPasswordModal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAuthProvider {
  /// Signs a user up with a username, password, and email.
  Future<void> signUpUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final userAttributes = {
        AuthUserAttributeKey.email: email,
        AuthUserAttributeKey.name: name,
        // Add more attributes if needed
      };
      final result = await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: SignUpOptions(
          userAttributes: userAttributes,
        ),
      );
      await _handleSignUpResult(result, email);
    } on AuthException catch (e) {
      safePrint('Error signing up user: ${e.message}');
      rethrow;
    }
  }

  /// Handles the result of sign up
  Future<void> _handleSignUpResult(SignUpResult result, String username) async {
    switch (result.nextStep.signUpStep) {
      case AuthSignUpStep.confirmSignUp:
        final codeDeliveryDetails = result.nextStep.codeDeliveryDetails!;
        _handleCodeDelivery(codeDeliveryDetails);
        throw SignUpConfirmationRequiredException();
      case AuthSignUpStep.done:
        safePrint('Sign up is complete');
        break;
    }
  }

  



/// Fetches user attributes from Cognito and persists them in SharedPreferences
Future<Map<String, String>> getUserAttributes() async {
  try {
    // Fetch the current authenticated user's attributes
    List<AuthUserAttribute> userAttributes = await Amplify.Auth.fetchUserAttributes();

    // Convert the list of attributes to a key-value map
    Map<String, String> attributesMap = {
      for (var attribute in userAttributes) attribute.userAttributeKey.toString(): attribute.value
    };

    // Example: Extract specific attributes (if needed)
    String? name = attributesMap['name'];
    String? email = attributesMap['email'];

    // Log attributes for debugging
    print('User Name: $name');
    print('User Email: $email');

    // Persist the attributes into SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var entry in attributesMap.entries) {
      await prefs.setString(entry.key, entry.value);
    }

    return attributesMap;
  } on AuthException catch (e) {
    // Handle authentication errors
    print('Error fetching user attributes: ${e.message}');
    return {};
  } catch (e) {
    // Handle general errors
    print('An unexpected error occurred: $e');
    return {};
  }
}

/// Retrieves a specific user attribute from SharedPreferences
Future<String?> getPersistedUserAttribute(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}


  /// Sends a confirmation code delivery message
  void _handleCodeDelivery(AuthCodeDeliveryDetails codeDeliveryDetails) {
    safePrint(
      'A confirmation code has been sent to ${codeDeliveryDetails.destination}. '
      'Please check your ${codeDeliveryDetails.deliveryMedium.name} for the code.',
    );
  }

  /// Confirms user sign-up with the provided confirmation code
  Future<void> confirmUser({
    required String username,
    required String confirmationCode,
  }) async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
        username: username,
        confirmationCode: confirmationCode,
      );
      await _handleSignUpResult(result, username);
    } on AuthException catch (e) {
      safePrint('Error confirming user: ${e.message}');
      rethrow;
    }
  }

  /// Signs a user in using username and password
  Future<void> signInUser(String username, String password) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: username,
        password: password,
      );
      await _handleSignInResult(result, username);
    } on AuthValidationException catch (e) {
      throw IncorrectPasswordException();
    } on AuthException catch (e) {
      safePrint('Error signing in: ${e.message}');
      rethrow;
    }
  }

  /// Handles the result of sign in
  Future<void> _handleSignInResult(SignInResult result, String username) async {
    switch (result.nextStep.signInStep) {
      case AuthSignInStep.confirmSignInWithSmsMfaCode:
        final codeDeliveryDetails = result.nextStep.codeDeliveryDetails!;
        _handleCodeDelivery(codeDeliveryDetails);
        break;
      case AuthSignInStep.confirmSignInWithNewPassword:
        safePrint('Enter a new password to continue signing in');
        break;
      case AuthSignInStep.confirmSignInWithCustomChallenge:
        final parameters = result.nextStep.additionalInfo;
        final prompt = parameters['prompt']!;
        safePrint(prompt);
        break;
      case AuthSignInStep.resetPassword:
        final resetResult = await Amplify.Auth.resetPassword(
          username: username,
        );
        await _handleResetPasswordResult(resetResult);
        break;
      case AuthSignInStep.confirmSignUp:
        final resendResult = await Amplify.Auth.resendSignUpCode(
          username: username,
        );
        _handleCodeDelivery(resendResult.codeDeliveryDetails);
        throw SignUpConfirmationRequiredException();
      case AuthSignInStep.done:
        safePrint('Sign in is complete');
        break;
      // TODO: Handle other sign-in steps like MFA, TOTP, etc.
      case AuthSignInStep.continueSignInWithMfaSelection:
      // TODO: Handle this case.
      case AuthSignInStep.continueSignInWithTotpSetup:
      // TODO: Handle this case.
      case AuthSignInStep.confirmSignInWithTotpMfaCode:
      // TODO: Handle this case.
    }
  }

  /// Initiates the password reset process
  Future<void> initiateResetPassword(String username) async {
    try {
      final result = await Amplify.Auth.resetPassword(
        username: username,
      );
      await _handleResetPasswordResult(result);
    } on AuthException catch (e) {
      safePrint('Error initiating password reset: ${e.message}');
      rethrow;
    }
  }

  /// Handles the result of the password reset process
  Future<void> _handleResetPasswordResult(
      ResetPasswordResult resetPasswordResult) async {
    switch (resetPasswordResult.nextStep.updateStep) {
      case AuthResetPasswordStep.confirmResetPasswordWithCode:
        final codeDeliveryDetails =
            resetPasswordResult.nextStep.codeDeliveryDetails!;
        // await showModalBottomSheet(
        //   context: NavigationService.navigatorKey.currentContext!,
        //   builder: (_) =>

        //   //  ResetPasswordModal(
        //   //   data: codeDeliveryDetails.destination!,
        //   // ),
        // );
        _handleCodeDelivery(codeDeliveryDetails);

        // Prompt user to enter the confirmation code and the new password
        break;

      case AuthResetPasswordStep.done:
        safePrint('Password reset is complete.');
        break;
    }
  }

  /// Confirms the password reset with the confirmation code and new password
  Future<void> confirmResetPassword({
    required String username,
    required String newPassword,
    required String confirmationCode,
  }) async {
    try {
      final result = await Amplify.Auth.confirmResetPassword(
        username: username,
        newPassword: newPassword,
        confirmationCode: confirmationCode,
      );
      if (result.isPasswordReset) {
        safePrint('Password has been successfully reset.');
      } else {
        safePrint('Password reset failed.');
      }
    } on AuthException catch (e) {
      safePrint('Error confirming password reset: ${e.message}');
      rethrow;
    }
  }

  /// Signs out the currently signed-in user
  Future<void> signOutCurrentUser() async {
    try {
      final result = await Amplify.Auth.signOut();
      if (result is CognitoCompleteSignOut) {
        final SharedPreferences _prefs = await SharedPreferences.getInstance();
        await _prefs.setBool("isFinalLoggedIn", false);
        _prefs.reload();
        safePrint('Sign out completed successfully');

      } else if (result is CognitoFailedSignOut) {
        safePrint('Error signing user out: ${result.exception.message}');
      }
    } on AuthException catch (e) {
      safePrint('Error signing out: ${e.message}');
      rethrow;
    }
  }

  /// Checks the current authentication session
  Future<bool> checkLoginSession() async {
    try {
      AuthSession session = await Amplify.Auth.fetchAuthSession();
      if (session.isSignedIn) {
        return true; // User is signed in
      } else {
        return false; // User is not signed in
      }
    } catch (e) {
      print('Error checking login session: $e');
      return false; // In case of an error, return false
    }
  }
}
