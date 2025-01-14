import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:moe/data/services/AWS/amplify/amplifyFlows.dart';
import 'package:moe/domain/classes/utils.dart';
import 'package:moe/screens/views/authentication/resetPasswordModal.dart';
import 'package:moe/screens/views/authentication/signup.dart';
import 'package:moe/screens/views/home.dart';
import 'package:moe/screens/widgets/buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final UserAuthProvider _authProvider = UserAuthProvider();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoginFailed = false;
  bool isLoading = false;
  bool isEmailEmpty = false;
  String emailError = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    temp();
  }

  temp() async{
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    print("HERE BITCH");
    print(_prefs.get("isFinalLoggedIn"));
    //await _prefs.setBool("isFinalLoggedIn", true);
  }

  Future<void> _handleValidation() async {
    setState(() {
      isLoading = true;
      isLoginFailed = false;
      isEmailEmpty = usernameController.text.isEmpty;
    });

    if (isEmailEmpty) {
      setState(() {
        emailError = "Email cannot be empty";
        isLoading = false;
      });
      return;
    }

    // Attempt sign-in
    try {
      await _authProvider.signInUser(
        usernameController.text.trim(),
        passwordController.text.trim(),
      );
      setState(() {
        isLoading = false;
        // Navigate to the next screen if login is successful
      });
      final SharedPreferences _prefs = await SharedPreferences.getInstance();
      await _prefs.setBool("isFinalLoggedIn", true);
      _prefs.reload();

      final UserAuthProvider amplifyProvider = UserAuthProvider();
      await amplifyProvider.getUserAttributes();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomeScreen()),
        (route) => false,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign in successful!'),
          duration: Duration(seconds: 2),
          backgroundColor:
              Colors.green, // Optional: customize color for success
        ),
      );
    } catch (e) {
      setState(() {
        isLoginFailed = true;
        isLoading = false;
      });
      print("Error during sign-in: $e");
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
              SizedBox(height: themeProperties.size.height * 0.20),
              _buildHeader(themeProperties),
              SizedBox(height: themeProperties.size.height * 0.05),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: themeProperties.size.width * 0.07),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: usernameController,
                      hintText: "Email",
                      errorText: _getErrorText(isEmailEmpty, isLoginFailed),
                      themeProperties: themeProperties,
                      onTap: () => setState(() {
                        isLoginFailed = false;
                        isEmailEmpty = false;
                        emailError = "";
                      }),
                    ),
                    SizedBox(height: themeProperties.size.height * 0.035),
                    _buildTextField(
                      controller: passwordController,
                      hintText: "Password",
                      errorText: isLoginFailed
                          ? "Incorrect login credentials or user does not exist"
                          : null,
                      themeProperties: themeProperties,
                      obscureText: true,
                      onTap: () => setState(() => isLoginFailed = false),
                    ),
                    SizedBox(height: themeProperties.size.height * 0.025),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildForgotPasswordButton(themeProperties),
                        isLoading
                            ? _buildLoadingIndicator(themeProperties)
                            : SignInButton(
                                size: themeProperties.size,
                                scColorInv: themeProperties.scColorInv,
                                txColorInv: themeProperties.txColorInv,
                                onTap: _handleValidation,
                              ),
                      ],
                    ),
                    SizedBox(height: themeProperties.size.height * 0.35),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(color: themeProperties.txColor),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => SignUpPage()));
                              },
                              style: const ButtonStyle(
                                  padding:
                                      WidgetStatePropertyAll(EdgeInsets.zero),
                                  tapTargetSize: MaterialTapTargetSize.padded,
                                  splashFactory: NoSplash.splashFactory),
                              child: Text(
                                "Sign up",
                                style: TextStyle(
                                    color: themeProperties.txColor,
                                    decoration: TextDecoration.underline),
                              ))
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

  String? _getErrorText(bool isEmailEmpty, bool isLoginFailed) {
    if (isEmailEmpty) return "Email cannot be empty";
    if (isLoginFailed) return "Incorrect login credentials";
    return null;
  }

  Widget _buildHeader(ThemeProperties themeProperties) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: themeProperties.size.width * 0.07),
        Text(
          "Login",
          style: TextStyle(
            color: themeProperties.txColor,
            fontSize: 44,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: themeProperties.size.width * 0.02),
        GestureDetector(
          onTap: (){
            Amplify.Auth.signOut();
          },
          child: Center(
            child: Icon(
              Icons.account_circle_outlined,
              color: themeProperties.txColor,
              size: 50,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required ThemeProperties themeProperties,
    String? errorText,
    bool obscureText = false,
    required VoidCallback onTap,
  }) {
    return TextField(
      controller: controller,
      onTap: onTap,
      obscureText: obscureText,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        border: const UnderlineInputBorder(borderSide: BorderSide()),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: themeProperties.txColor),
        ),
        hintText: hintText,
        errorText: errorText,
        hintStyle: GoogleFonts.roboto(
            textStyle: TextStyle(color: themeProperties.txColor)),
      ),
      cursorColor: themeProperties.txColor,
      showCursor: true,
      style: GoogleFonts.roboto(
          textStyle: TextStyle(color: themeProperties.txColor)),
    );
  }

  Widget _buildForgotPasswordButton(ThemeProperties themeProperties) {
    return TextButton(
      onPressed: () async {
        try {
          await _authProvider
              .initiateResetPassword(usernameController.text.trim());
          await showModalBottomSheet(
              context: context,
              builder: (_) => ResetPasswordModal(
                  data: usernameController.text.trim(),
                  username: usernameController.text.trim()));
        } catch (e) {
          setState(() {
            isLoginFailed = true;
            emailError = "Enter your email";
          });
        }
      },
      child: Text(
        "Forgot Password?",
        style: TextStyle(color: themeProperties.txColor),
      ),
    );
  }

  Widget _buildLoadingIndicator(ThemeProperties themeProperties) {
    return LoadingIndicator(
      indicatorType: Indicator.ballPulse,
      colors: [themeProperties.txColor],
      strokeWidth: 2,
    );
  }
}
