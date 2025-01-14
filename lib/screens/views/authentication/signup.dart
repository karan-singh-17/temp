import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:moe/data/services/AWS/amplify/amplifyExceptions.dart';
import 'package:moe/data/services/AWS/amplify/amplifyFlows.dart';
import 'package:moe/domain/classes/utils.dart';
import 'package:moe/screens/views/authentication/confirmRegistrationModal.dart';
import 'package:moe/screens/widgets/buttons.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isNameEmpty = false;
  bool isEmailEmpty = false;
  bool isEmailInvalid = false;
  bool isPasswordInvalid = false;
  bool isPasswordMismatch = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    passwordController.addListener(_validatePassword);
    confirmPasswordController.addListener(_validateConfirmPassword);
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _validatePassword() {
    setState(() {
      isPasswordInvalid = !isPasswordValid(passwordController.text);
    });
  }

  void _validateConfirmPassword() {
    setState(() {
      isPasswordMismatch =
          passwordController.text != confirmPasswordController.text;
    });
  }

  void _validateEmail() {
    setState(() {
      isEmailInvalid = !isEmailValid(emailController.text);
    });
  }

  bool isEmailValid(String email) {
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

  bool isPasswordValid(String password) {
    final passwordRegExp =
        RegExp(r'^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9]).{8,}$');
    return passwordRegExp.hasMatch(password);
  }

  void validEntries() async {
    setState(() {
      isNameEmpty = nameController.text.isEmpty;
      isEmailEmpty = emailController.text.isEmpty;
      isEmailInvalid = !isEmailValid(emailController.text);
      isPasswordInvalid = !isPasswordValid(passwordController.text);
      isPasswordMismatch =
          passwordController.text != confirmPasswordController.text;
    });
    await _signUp();
  }

  Future<void> _signUp() async {
    setState(() {
      isLoading = true;
    });

    final authProvider = UserAuthProvider();

    try {
      await authProvider.signUpUser(
        email: emailController.text.trim(),
        password: passwordController.text,
        name: nameController.text.trim(),
      );
    } on SignUpConfirmationRequiredException {
      await showModalBottomSheet(
          context: context,
          builder: (_) =>
              ConfirmRegistrationModal(username: emailController.text.trim()));
    } catch (e) {
      // Show error to user
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red[400],
      ));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProperties = ThemeProperties(context: context);

    return Scaffold(
      backgroundColor: themeProperties.scColor,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: themeProperties.size.height * 0.2,
              ),
              _buildHeader(themeProperties),
              SizedBox(height: themeProperties.size.height * 0.05),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: themeProperties.size.width * 0.07),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: nameController,
                      hintText: "Name",
                      errorText: isNameEmpty ? "Field cannot be empty" : null,
                      themeProperties: themeProperties,
                    ),
                    SizedBox(height: themeProperties.size.height * 0.035),
                    _buildTextField(
                      controller: emailController,
                      hintText: "Email",
                      errorText: _getEmailErrorText(),
                      themeProperties: themeProperties,
                    ),
                    SizedBox(height: themeProperties.size.height * 0.035),
                    _buildTextField(
                      controller: passwordController,
                      hintText: "Password",
                      errorText: isPasswordInvalid
                          ? "Password must be at least 8 characters long, contain an uppercase letter, a number, and a special character."
                          : null,
                      themeProperties: themeProperties,
                      obscureText: true,
                    ),
                    SizedBox(height: themeProperties.size.height * 0.035),
                    _buildTextField(
                      controller: confirmPasswordController,
                      hintText: "Confirm Password",
                      errorText:
                          isPasswordMismatch ? "Passwords do not match" : null,
                      themeProperties: themeProperties,
                      obscureText: true,
                    ),
                    SizedBox(height: themeProperties.size.height * 0.055),
                    isLoading
                        ? _buildLoadingIndicator(themeProperties)
                        : SignInButtonLarge(
                            isSignup: true,
                            size: themeProperties.size,
                            scColorInv: themeProperties.scColorInv,
                            txColorInv: themeProperties.txColorInv,
                            onTap: validEntries,
                          ),
                    SizedBox(height: themeProperties.size.height * 0.17),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Have an account?",
                            style: TextStyle(color: themeProperties.txColor),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: const ButtonStyle(
                              padding: WidgetStatePropertyAll(EdgeInsets.zero),
                              tapTargetSize: MaterialTapTargetSize.padded,
                              splashFactory: NoSplash.splashFactory,
                            ),
                            child: Text(
                              "Sign in",
                              style: TextStyle(
                                color: themeProperties.txColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeProperties themeProperties) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: themeProperties.size.width * 0.07),
        Text(
          "Sign Up",
          style: TextStyle(
            color: themeProperties.txColor,
            fontSize: 34,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: themeProperties.size.width * 0.02),
        Center(
          child: Icon(
            Icons.account_circle_outlined,
            color: themeProperties.txColor,
            size: 50,
          ),
        ),
      ],
    );
  }

  String? _getEmailErrorText() {
    if (isEmailEmpty) {
      return "Field cannot be empty";
    } else if (isEmailInvalid) {
      return "Enter a valid email address";
    }
    return null;
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required ThemeProperties themeProperties,
    String? errorText,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      onChanged: (_) {
        if (controller == passwordController) {
          _validatePassword();
        } else if (controller == confirmPasswordController) {
          _validateConfirmPassword();
        }
      },
      obscureText: obscureText,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        border: const UnderlineInputBorder(borderSide: BorderSide()),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: themeProperties.txColor),
        ),
        hintText: hintText,
        errorText: errorText,
        errorMaxLines: 2,
        hintStyle: GoogleFonts.roboto(
          textStyle: TextStyle(color: themeProperties.txColor),
        ),
      ),
      cursorColor: themeProperties.txColor,
      style: GoogleFonts.roboto(
        textStyle: TextStyle(color: themeProperties.txColor),
      ),
    );
  }

  Widget _buildLoadingIndicator(ThemeProperties themeProperties) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: themeProperties.size.height * 0.062,
      decoration: BoxDecoration(
        border: Border.all(style: BorderStyle.none),
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
