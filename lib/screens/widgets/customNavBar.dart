import 'dart:io';

import 'package:flutter/material.dart';

import 'package:moe/domain/classes/utils.dart';
import 'package:moe/domain/viewmodels/navBarController.dart';
import 'package:moe/screens/views/dashboard/DashboardScreen.dart';
import 'package:moe/screens/views/dashboard/dashboard_multiple.dart';
import 'package:moe/screens/views/devices.dart';
import 'package:moe/screens/views/profile.dart';
import 'package:provider/provider.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  final List<IconData> _icons = [
    Icons.home_outlined,
    Icons.account_circle_rounded,
  ];

  final List<Widget> _pages = [
    const DashboardMultiple(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    NavBarController bottomNavController =
    Provider.of<NavBarController>(context, listen: true);
    final ThemeProperties themeProperties = ThemeProperties(context: context);
    var scColor = isDarkMode ? ScaffoldColor().dark : ScaffoldColor().light;
    var txColor = isDarkMode ? TextColor().dark : TextColor().light;

    return LayoutBuilder(
      builder: (context, constraints) {
        double iconSize = constraints.maxWidth * 0.08;

        return BottomAppBar(
          height: MediaQuery.of(context).size.height * 0.06, // Keep this height to avoid icon cropping
          color: scColor,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(color: scColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(_icons.length, (index) {
                return IconButton(
                  iconSize: iconSize,
                  alignment: Alignment.topCenter, // Align icons to the top
                  padding: EdgeInsets.zero, // Remove extra padding
                  splashColor: txColor.withOpacity(0.2),
                  onPressed: () {
                    bottomNavController.setIndex(index);
                    Navigator.of(context).pushAndRemoveUntil(
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                        _pages[bottomNavController.currentIndex],
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                          (route) => false,
                    );
                  },
                  icon: Icon(
                    _icons[index],
                    color: index == bottomNavController.currentIndex
                        ? themeProperties.txColor
                        : themeProperties.txColor.withOpacity(0.2),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
