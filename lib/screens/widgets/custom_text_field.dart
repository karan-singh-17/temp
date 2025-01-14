import 'package:flutter/material.dart';

import '../../domain/classes/utils.dart';

class custom_text_field extends StatelessWidget {
  TextEditingController txt_cont;
  String label;
  custom_text_field({super.key , required this.txt_cont , required this.label});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    var scColor = isDarkMode ? ScaffoldColor().dark : ScaffoldColor().light;
    var scColorInv = isDarkMode ? ScaffoldColor().light : ScaffoldColor().dark;
    var txColor = isDarkMode ? TextColor().dark : TextColor().light;
    var txColorInv = isDarkMode ? TextColor().light : TextColor().dark;
    final size = MediaQuery.of(context).size;

    return Container(
      child: TextField(
        style: TextStyle(
            color: txColor
        ),
        cursorColor: txColor,
        controller: txt_cont,
        decoration: InputDecoration(
          labelText: label,
          alignLabelWithHint: true,
        ),
      ),
    );
  }
}