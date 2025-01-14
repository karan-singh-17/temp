import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:moe/data/services/AWS/amplify/amplifyFlows.dart';
import 'package:moe/domain/classes/utils.dart';
import 'package:moe/screens/views/authentication/login.dart';
import 'package:moe/screens/widgets/buttons.dart';

class ConfirmRegistrationModal extends StatefulWidget {
  const ConfirmRegistrationModal({super.key, required this.username});
  final String username;

  @override
  State<ConfirmRegistrationModal> createState() =>
      _ConfirmRegistrationModalState();
}

class _ConfirmRegistrationModalState extends State<ConfirmRegistrationModal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController verificationCodeController = TextEditingController();

  bool isValidEntriesVerification = true;
  String verificationError = "";
  bool isLoading = false;
  final UserAuthProvider userAuthProvider = UserAuthProvider();

  @override
  Widget build(BuildContext context) {
    final ThemeProperties themeProperties = ThemeProperties(context: context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: themeProperties.size.height * 0.563,
          decoration: BoxDecoration(color: themeProperties.scColor),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: themeProperties.size.height * 0.025),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Verify your email",
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          color: themeProperties.txColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    Text(
                      "A verification code has been sent to your email.",
                      maxLines: 2,
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          color: themeProperties.txColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: themeProperties.size.height * 0.2,
                  child: Center(
                    child: Stack(
                      children: [
                        TextFormField(
                          controller: verificationCodeController,
                          onTap: () {
                            setState(() {
                              isValidEntriesVerification = true;
                              verificationError = "";
                            });
                          },
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            border: const UnderlineInputBorder(
                                borderSide: BorderSide()),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: themeProperties.txColor),
                            ),
                            hintText: "Verification Code",
                            errorText: isValidEntriesVerification
                                ? null
                                : verificationError,
                            focusColor: themeProperties.txColor,
                            hintStyle: GoogleFonts.roboto(
                              textStyle:
                                  TextStyle(color: themeProperties.txColor),
                            ),
                          ),
                          cursorColor: themeProperties.txColor,
                          showCursor: true,
                          style: GoogleFonts.roboto(
                            textStyle:
                                TextStyle(color: themeProperties.txColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: themeProperties.size.height * 0.175),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      verificationError = "";
                      isLoading = true;
                    });
                    try {
                      await userAuthProvider.confirmUser(
                          username: widget.username,
                          confirmationCode: verificationCodeController.text);
                    } catch (e) {
                      if (e is InvalidLambdaResponseException) {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => LoginPage()),
                            (Route route) => false);
                      } else {
                        setState(() {
                          verificationError = "Error verifying code";
                          isValidEntriesVerification = false;
                          isLoading = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(e.toString()),
                          backgroundColor: Colors.red[400],
                        ));
                        print(e.toString());
                      }
                    } finally {
                      setState(() {
                        verificationError = "";
                        isLoading = false;
                      });
                    }
                    // Simulate a verification logic
                  },
                  child: isLoading
                      ? _buildLoadingIndicator(themeProperties)
                      : NextButtonBarComponent(
                          size: themeProperties.size,
                          scColorInv: themeProperties.scColorInv,
                          txColorInv: themeProperties.txColorInv,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
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
