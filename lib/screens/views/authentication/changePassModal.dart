import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moe/domain/classes/utils.dart';
import 'package:moe/screens/widgets/buttons.dart';

class ChangePasswordModal extends StatefulWidget {
  const ChangePasswordModal({super.key});

  @override
  State<ChangePasswordModal> createState() => _ChangePasswordModalState();
}

class _ChangePasswordModalState extends State<ChangePasswordModal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController reenterPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool isPassValid = true;
  bool isValidEntriesName = true;
  bool isValidEntriesOld = true;
  bool isValidEntriesNew = true;
  bool isValidEntriesReenter = true;

  bool isPasswordValid(String password) {
    final passwordRegExp =
        RegExp(r'^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9]).{8,}$');
    return passwordRegExp.hasMatch(password);
  }

  bool validPassword(String password) {
    if (!isPasswordValid(password)) {
      setState(() {
        isPassValid = false;
      });
      return false;
    } else {
      setState(() {
        isPassValid = true;
      });
      return true;
    }
  }

  void validEntries() {
    setState(() {
      isValidEntriesName = nameController.text.isNotEmpty;
      isValidEntriesOld = oldPasswordController.text.isNotEmpty;
      isValidEntriesNew = isPasswordValid(newPasswordController.text);
      isValidEntriesReenter =
          newPasswordController.text == reenterPasswordController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProperties themeProperties = ThemeProperties(context: context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: themeProperties.size.height * 0.55,
          color: themeProperties.scColor,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Reset your password to continue",
                  maxLines: 2,
                  style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                          color: themeProperties.txColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 20)),
                ),
                TextFormField(
                    controller: nameController,
                    onChanged: (value) {},
                    onTap: () {
                      setState(() {
                        isValidEntriesName = true;
                      });
                    },
                    decoration: InputDecoration(
                        alignLabelWithHint: true,
                        border: const UnderlineInputBorder(
                            borderSide: BorderSide()),
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: themeProperties.txColor)),
                        hintText: "Name",
                        errorText:
                            isValidEntriesName ? null : "Field cannot be empty",
                        focusColor: themeProperties.txColor,
                        hintStyle: GoogleFonts.roboto(
                            textStyle:
                                TextStyle(color: themeProperties.txColor))),
                    cursorColor: themeProperties.txColor,
                    showCursor: true,
                    style: GoogleFonts.roboto(
                        textStyle: TextStyle(color: themeProperties.txColor))),
                TextFormField(
                    controller: oldPasswordController,
                    onTap: () {
                      setState(() {
                        isValidEntriesOld = true;
                      });
                    },
                    onChanged: (value) {},
                    decoration: InputDecoration(
                        alignLabelWithHint: true,
                        border: const UnderlineInputBorder(
                            borderSide: BorderSide()),
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: themeProperties.txColor)),
                        hintText: "Old Password",
                        errorText:
                            isValidEntriesOld ? null : "Field cannot be empty",
                        focusColor: themeProperties.txColor,
                        hintStyle: GoogleFonts.roboto(
                            textStyle:
                                TextStyle(color: themeProperties.txColor))),
                    cursorColor: themeProperties.txColor,
                    showCursor: true,
                    obscureText: true,
                    style: GoogleFonts.roboto(
                        textStyle: TextStyle(color: themeProperties.txColor))),
                TextFormField(
                    controller: newPasswordController,
                    onChanged: (value) {
                      validPassword(value);
                    },
                    decoration: InputDecoration(
                        alignLabelWithHint: true,
                        border: const UnderlineInputBorder(
                            borderSide: BorderSide()),
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: themeProperties.txColor)),
                        hintText: "New Password",
                        focusColor: themeProperties.txColor,
                        errorText: isPassValid
                            ? null
                            : 'Password must be at least 8 characters long, include an uppercase letter, a special character and a number.',
                        errorMaxLines: 2,
                        hintStyle: GoogleFonts.roboto(
                            textStyle:
                                TextStyle(color: themeProperties.txColor))),
                    cursorColor: themeProperties.txColor,
                    showCursor: true,
                    obscureText: true,
                    style: GoogleFonts.roboto(
                        textStyle: TextStyle(color: themeProperties.txColor))),
                TextFormField(
                    controller: reenterPasswordController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                        alignLabelWithHint: true,
                        border: const UnderlineInputBorder(
                            borderSide: BorderSide()),
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: themeProperties.txColor)),
                        hintText: "Re-enter New Password",
                        focusColor: themeProperties.txColor,
                        errorText: newPasswordController.text !=
                                reenterPasswordController.text
                            ? 'Passwords do not match'
                            : null,
                        hintStyle: GoogleFonts.roboto(
                            textStyle:
                                TextStyle(color: themeProperties.txColor))),
                    cursorColor: themeProperties.txColor,
                    showCursor: true,
                    obscureText: true,
                    style: GoogleFonts.roboto(
                        textStyle: TextStyle(color: themeProperties.txColor))),
                const SizedBox(),
                GestureDetector(
                  onTap: () {
                    validEntries();
                    if (_formKey.currentState!.validate() &&
                        isValidEntriesName &&
                        isValidEntriesOld &&
                        isValidEntriesNew &&
                        isValidEntriesReenter) {
                      final List<String> results = [
                        newPasswordController.text,
                        nameController.text
                      ];
                      Navigator.of(context).pop(results);
                    } else {
                      // Show error message
                    }
                  },
                  child: NextButtonBarComponent(
                      size: themeProperties.size,
                      scColorInv: themeProperties.scColorInv,
                      txColorInv: themeProperties.txColorInv),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
