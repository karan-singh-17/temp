import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:moe/data/services/AWS/amplify/amplifyFlows.dart';
import 'package:moe/domain/classes/utils.dart';
import 'package:moe/screens/widgets/buttons.dart';

class ResetPasswordModal extends StatefulWidget {
  const ResetPasswordModal(
      {super.key, required this.data, required this.username});
  final String data;
  final String username;

  @override
  State<ResetPasswordModal> createState() => _ResetPasswordModalState();
}

class _ResetPasswordModalState extends State<ResetPasswordModal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController reenterPasswordController = TextEditingController();
  TextEditingController verificationCodeController = TextEditingController();
  bool isPassValid = true;
  bool isLoading = false;
  String verificationError = "";

  bool isPasswordValid(String password) {
    final passwordRegExp =
        RegExp(r'^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9]).{8,}$');
    return passwordRegExp.hasMatch(password);
  }

  bool validPassword(String password) {
    setState(() {
      isPassValid = isPasswordValid(password);
    });
    return isPassValid;
  }

  Future<void> resetPassword() async {
    UserAuthProvider userAuthProvider = UserAuthProvider();
    try {
      setState(() => isLoading = true);
      await userAuthProvider.confirmResetPassword(
          username: widget.username,
          newPassword: reenterPasswordController.text,
          confirmationCode: verificationCodeController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Your password has been reset")),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (e is InvalidLambdaResponseException) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Your password has been reset")),
        );
        Navigator.of(context).pop();
      } else {
        setState(() {
          verificationError = "Error occurred with verification code";
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(verificationError)),
        );
      }
    }
  }

  Future<void> resendCode() async {
    try {
      final resetResult =
          await Amplify.Auth.resetPassword(username: widget.username);
      if (resetResult.isPasswordReset) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Verification code sent to ${widget.data}")),
        );
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to resend code: ${e.message}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeProperties themeProperties = ThemeProperties(context: context);
    return Scaffold(
      backgroundColor: themeProperties.scColor,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20), // Add space at the top
                Text(
                  "Reset Password",
                  style: GoogleFonts.roboto(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    color: themeProperties.txColor,
                  ),
                ),
                const SizedBox(
                    height: 10), // Space between header and info text
                Text(
                  "A verification code has been sent to ${widget.data}.",
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: themeProperties.txColor,
                  ),
                ),
                const SizedBox(height: 20), // Space between text and fields
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    _buildTextField(
                      controller: verificationCodeController,
                      hintText: "Verification Code",
                      errorText:
                          verificationError.isEmpty ? null : verificationError,
                      themeProperties: themeProperties,
                    ),
                    TextButton(
                      onPressed: resendCode,
                      child: Text(
                        "Resend Code",
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(color: themeProperties.txColor),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: newPasswordController,
                  hintText: "New Password",
                  errorText: isPassValid ? null : 'Invalid password format.',
                  obscureText: true,
                  onChanged: validPassword,
                  themeProperties: themeProperties,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: reenterPasswordController,
                  hintText: "Re-enter New Password",
                  errorText: newPasswordController.text ==
                          reenterPasswordController.text
                      ? null
                      : 'Passwords do not match',
                  obscureText: true,
                  themeProperties: themeProperties,
                ),
                const SizedBox(height: 100), // Space before button
                GestureDetector(
                  onTap: resetPassword,
                  child: isLoading
                      ? _buildLoadingIndicator(themeProperties)
                      : NextButtonBarComponent(
                          size: MediaQuery.of(context).size,
                          scColorInv: themeProperties.scColorInv,
                          txColorInv: themeProperties.txColorInv,
                        ),
                ),
                const SizedBox(
                    height: 20), // Bottom padding for the last element
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    String? errorText,
    bool obscureText = false,
    Function(String)? onChanged,
    required ThemeProperties themeProperties,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.roboto(
          textStyle: TextStyle(color: themeProperties.txColor),
        ),
        errorText: errorText,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: themeProperties.txColor),
        ),
      ),
      obscureText: obscureText,
      onChanged: onChanged,
      style: GoogleFonts.roboto(
        textStyle: TextStyle(color: themeProperties.txColor),
      ),
    );
  }

  Widget _buildLoadingIndicator(ThemeProperties themeProperties) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: themeProperties.scColorInv,
      ),
      child: Center(
        child: LoadingIndicator(
          indicatorType: Indicator.ballPulseSync,
          backgroundColor: themeProperties.scColorInv,
          colors: [themeProperties.txColorInv],
        ),
      ),
    );
  }
}
