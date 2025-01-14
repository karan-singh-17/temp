import 'package:flutter/material.dart';
import 'package:moe/domain/classes/utils.dart';

void showNoInternetBanner(BuildContext context) {
  final ThemeProperties themeProperties = ThemeProperties(context: context);
  ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
    content: Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.notification_important_rounded,
            color: themeProperties.txColorInv,
          ),
          Text(
            "No internet connection",
            style: TextStyle(color: themeProperties.txColorInv),
          )
        ],
      ),
    ),
    actions: [
      TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
          },
          child: Text(
            "Dismiss",
            style: TextStyle(color: themeProperties.txColorInv),
          ))
    ],
    backgroundColor: themeProperties.scColorInv,
  ));
}
