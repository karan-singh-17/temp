// import 'package:amazon_cognito_identity_dart_2/cognito.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:moe/data/exceptions/AWSExceptions/AuthExcetions.dart';
// import 'package:moe/data/responses/CodeDeliveryAWS.dart';
// import 'package:moe/data/services/AWS/customStorage.dart';
// import 'package:moe/data/services/NavigationServices.dart';
// import 'package:moe/screens/views/authentication/changePassModal.dart';
// import 'package:moe/screens/views/authentication/confirmRegistrationModal.dart';
// import 'package:moe/screens/views/authentication/resetPasswordModal.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AWSServices extends ChangeNotifier {
//   CognitoUser? _cognitoUser;
//   CognitoUserSession? _session;
//   CognitoUserSession? get session => _session;
//   String clientSecret = dotenv.env['CLIENT_SECRET']!;
//   final userPool = CognitoUserPool(
//     dotenv.env['POOL_ID']!,
//     dotenv.env['CLIENT_ID']!,
//     clientSecret: dotenv.env['CLIENT_SECRET']!,
//   );

//   List<CognitoUserAttribute>? userAttributes;

//   AWSServices() {
//     init();
//   }

//   Future<void> init() async {
//     final prefs = await SharedPreferences.getInstance();
//     final storage = CustomStorage(prefs);
//     userPool.storage = storage;
//     // _cognitoUser = await userPool.getCurrentUser();
//     await retrieveSession();
//     Future.delayed(Durations.short4);
//   }

//   Future<void> resetPassword(String username) async {
//     final cognitoUser = CognitoUser(
//       username,
//       userPool,
//       clientSecret: clientSecret,
//       storage: userPool.storage,
//     );

//     try {
//       final data = await cognitoUser.forgotPassword();
//       final codeDeliveryAWS = CodeDeliveryAWS.fromJson(data);
//       await showModalBottomSheet(
//         context: NavigationService.navigatorKey.currentContext!,
//         builder: (_) => ResetPasswordModal(
//           data: codeDeliveryAWS.codeDeliveryDetails.destination,
//           cognitoUser: cognitoUser,
//         ),
//       );
//     } on CognitoClientException {
//       rethrow;
//     }
//   }

//   Future<CognitoUserSession?> signIn(String username, String password) async {
//     final cognitoUser = CognitoUser(
//       username,
//       userPool,
//       clientSecret: clientSecret,
//       storage: userPool.storage,
//     );
//     final authDetails = AuthenticationDetails(
//       username: username,
//       password: password,
//     );

//     try {
//       _session = await cognitoUser.authenticateUser(authDetails);
//       await saveSession(_session!);
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('email', username);
//       await prefs.reload();
//       notifyListeners();
//       return _session;
//     } on CognitoUserNewPasswordRequiredException catch (e) {
//       await _handleNewPasswordRequired(cognitoUser, e);
//       return _session;
//     } on CognitoClientException catch (e) {
//       if (e.name == 'UserNotConfirmedException') {
//         throw UserNotConfirmedException(e);
//       }
//       throw IncorrectCredentialsException(e);
//     } catch (e) {
//       Fluttertoast.showToast(
//         msg: e.toString(),
//         toastLength: Toast.LENGTH_LONG,
//       );
//       print(e);
//       return null;
//     }
//   }

//   Future<void> _handleNewPasswordRequired(CognitoUser cognitoUser,
//       CognitoUserNewPasswordRequiredException e) async {
//     final List<String> results = await showModalBottomSheet(
//       context: NavigationService.navigatorKey.currentContext!,
//       builder: (BuildContext context) {
//         return const ChangePasswordModal();
//       },
//     );

//     if (e.requiredAttributes!.isEmpty) {
//       _session = await cognitoUser.sendNewPasswordRequiredAnswer(results.first);
//     } else if (e.requiredAttributes!.isNotEmpty) {
//       var attributes = {"name": results.last};
//       _session = await cognitoUser.sendNewPasswordRequiredAnswer(
//         results.first,
//         attributes,
//       );
//     }
//     await saveSession(_session!);
//     notifyListeners();
//   }

//   Future<bool> signUp(String? email, String? password, String? name) async {
//     final userAttributes = [AttributeArg(name: 'name', value: name)];

//     try {
//       await userPool.signUp(email!, password!, userAttributes: userAttributes);
//       return true;
//     } on CognitoClientException catch (e) {
//       print(e);
//       rethrow;
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//       return false;
//     }
//   }

//   Future<void> signOut() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//     _session = null;
//     notifyListeners();
//   }

//   Future<bool> confirmRegistration({String? email, bool? isFromLogin}) async {
//     final cognitoUser = CognitoUser(
//       email,
//       userPool,
//       clientSecret: clientSecret,
//       storage: userPool.storage,
//     );

//     if (isFromLogin!) {
//       await cognitoUser.resendConfirmationCode();
//     }

//     final isRegistrationConfirmed = await showModalBottomSheet(
//       context: NavigationService.navigatorKey.currentContext!,
//       builder: (BuildContext context) => ConfirmRegistrationModal(
//         cognitoUser: cognitoUser,
//         data: email!,
//       ),
//     );

//     return isRegistrationConfirmed;
//   }

//   Future<void> saveSession(CognitoUserSession userSession) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('idToken', userSession.idToken.jwtToken ?? "null");
//     await prefs.setString(
//         'accessToken', userSession.accessToken.jwtToken ?? "null");
//     await prefs.setString(
//         'refreshToken', userSession.refreshToken!.token ?? "null");
//   }

//   Future<CognitoUserSession> retrieveSession() async {
//     final prefs = await SharedPreferences.getInstance();
//     final idToken = prefs.getString('idToken');
//     final accessToken = prefs.getString('accessToken');
//     final refreshToken = prefs.getString('refreshToken');

//     if (idToken != "null" && accessToken != "null" && refreshToken != "null") {
//       _session = CognitoUserSession(
//         CognitoIdToken(idToken),
//         CognitoAccessToken(accessToken),
//         refreshToken: CognitoRefreshToken(refreshToken),
//       );
//       notifyListeners();
//       return _session!;
//     }
//     return _session!;
//   }

//   bool isAuthenticated() {
//     return _session?.isValid() ?? false;
//   }
// }

// // import 'package:amazon_cognito_identity_dart_2/cognito.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_dotenv/flutter_dotenv.dart';
// // import 'package:fluttertoast/fluttertoast.dart';
// // import 'package:moe/data/exceptions/AWSExceptions/AuthExcetions.dart';
// // import 'package:moe/data/responses/CodeDeliveryAWS.dart';
// // import 'package:moe/data/services/AWS/customStorage.dart';

// // import 'package:moe/data/services/NavigationServices.dart';
// // import 'package:moe/presentation/views/authentication/changePassModal.dart';
// // import 'package:moe/presentation/views/authentication/confirmRegistrationModal.dart';
// // import 'package:moe/presentation/views/authentication/resetPasswordModal.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// // class AWSServices extends ChangeNotifier {
// //   CognitoUser? _cognitoUser;
// //   CognitoUserSession? _session;
// //   CognitoUserSession? get session => _session;
// //   AWSServices() {
// //     init();
// //   }
// //   final String clientSecret = '${dotenv.env['CLIENT_SECRET']}';

// //   Future<void> init() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final storage = CustomStorage(prefs);
// //     userPool.storage = storage;
// //     _cognitoUser = await userPool.getCurrentUser();
// //     if (_cognitoUser == null) {
// //       _session = null;
// //       notifyListeners();
// //     }
// //     _session = await _cognitoUser!.getSession();
// //     notifyListeners();
// //   }

// //   final userPool = CognitoUserPool(
// //     '${dotenv.env['POOL_ID']}',
// //     '${dotenv.env['CLIENT_ID']}',
// //     clientSecret: '${dotenv.env['CLIENT_SECRET']}',
// //   );

// //   Future<void> resetPassword(String username) async {
// //     final cognitoUser = CognitoUser(username, userPool,
// //         clientSecret: clientSecret, storage: userPool.storage);
// //     var data;
// //     try {
// //       data = await cognitoUser.forgotPassword();
// //       CodeDeliveryAWS codeDeliveryAWS = CodeDeliveryAWS.fromJson(data);
// //       await showModalBottomSheet(
// //           context: NavigationService.navigatorKey.currentContext!,
// //           builder: (_) => ResetPasswordModal(
// //                 data: codeDeliveryAWS.codeDeliveryDetails.destination,
// //                 cognitoUser: cognitoUser,
// //               ));
// //     } on CognitoClientException {
// //       rethrow;
// //     }
// //   }

// //   Future<CognitoUserSession?> signIn(String username, String password) async {
// //     final cognitoUser = CognitoUser(username, userPool,
// //         clientSecret: clientSecret, storage: userPool.storage);

// //     final authDetails =
// //         AuthenticationDetails(username: username, password: password);

// //     try {
// //       _session = await cognitoUser.authenticateUser(authDetails);
// //       await saveSession(_session!);
// //       notifyListeners();
// //       return _session;
// //     } on CognitoUserNewPasswordRequiredException catch (e) {
// //       final List<String> results = await showModalBottomSheet(
// //         context: NavigationService.navigatorKey.currentContext!,
// //         builder: (BuildContext context) {
// //           return const ChangePasswordModal();
// //         },
// //       );
// //       if (e.requiredAttributes!.isEmpty) {
// //         _session =
// //             await cognitoUser.sendNewPasswordRequiredAnswer(results.first);
// //       } else if (e.requiredAttributes!.isNotEmpty) {
// //         var attributes = {"name": results.last};
// //         _session = await cognitoUser.sendNewPasswordRequiredAnswer(
// //           results.first,
// //           attributes,
// //         );
// //       }
// //       await saveSession(_session!);
// //       notifyListeners();
// //       return _session;
// //     } on CognitoClientException catch (e) {
// //       if (e.name == 'UserNotConfirmedException') {
// //         throw UserNotConfirmedException(e);
// //       }
// //       throw IncorrectCredentialsException(e);
// //     } catch (e) {
// //       Fluttertoast.showToast(
// //         msg: e.toString(),
// //         toastLength: Toast.LENGTH_LONG,
// //       );
// //       print(e);
// //       return null;
// //     }
// //   }

// //   Future<bool> signUp(String? email, String? password, String? name) async {
// //     final userAttribuets = [AttributeArg(name: 'name', value: name)];

// //     CognitoUserPoolData data;
// //     try {
// //       data = await userPool.signUp(email!, password!,
// //           userAttributes: userAttribuets);
// //       return true;
// //     } on CognitoClientException catch (e) {
// //       print(e);
// //       rethrow;
// //     } catch (e) {
// //       Fluttertoast.showToast(msg: e.toString());
// //     }
// //     return false;
// //   }

// //   Future<void> signOut() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.clear();
// //     _session = null;
// //     notifyListeners();
// //   }

// //   Future<bool> confirmRegistration({String? email, bool? isFromLogin}) async {
// //     final cognitoUser = CognitoUser(email, userPool,
// //         clientSecret: clientSecret, storage: userPool.storage);
// //     if (isFromLogin!) {
// //       cognitoUser.resendConfirmationCode();
// //     }
// //     bool isRegistrationConfirmed = await showModalBottomSheet(
// //         context: NavigationService.navigatorKey.currentContext!,
// //         builder: (BuildContext context) =>
// //             ConfirmRegistrationModal(cognitoUser: cognitoUser, data: email!));
// //     return isRegistrationConfirmed;
// //   }

// //   Future<void> saveSession(CognitoUserSession userSession) async {
// //     final prefs = await SharedPreferences.getInstance();
// //     await prefs.setString('idTokenn', userSession.idToken.jwtToken ?? "null");
// //     await prefs.setString(
// //       'accessTokenn',
// //       userSession.accessToken.jwtToken ?? "null",
// //     );
// //     await prefs.setString(
// //       'refreshTokenn',
// //       userSession.refreshToken!.token ?? "null",
// //     );
// //   }

// //   Future<CognitoUserSession> retrieveSession() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final idToken = prefs.getString('idTokenn');
// //     final accessToken = prefs.getString('accessTokenn');
// //     final refreshToken = prefs.getString('refreshTokenn');
// //     print(idToken);
// //     print(accessToken);
// //     print(refreshToken);

// //     if (idToken != "null" && accessToken != "null" && refreshToken != "null") {
// //       _session = CognitoUserSession(
// //         CognitoIdToken(idToken),
// //         CognitoAccessToken(accessToken),
// //         refreshToken: CognitoRefreshToken(refreshToken),
// //       );
// //       notifyListeners();
// //       return _session!;
// //     }
// //     return CognitoUserSession(CognitoIdToken(''), CognitoAccessToken(''),
// //         refreshToken: CognitoRefreshToken(''));
// //   }

// //   bool isAuthenticated() {
// //     if (_session != null) {
// //       return _session!.isValid();
// //     } else {
// //       return false;
// //     }
// //   }
// // }
