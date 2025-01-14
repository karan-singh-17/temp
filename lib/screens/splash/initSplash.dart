// import 'package:flutter/material.dart';
// import 'package:moe/data/services/AWS/aws_services.dart';
// import 'package:moe/domain/classes/utils.dart';
// import 'package:moe/screens/views/authentication/login.dart';
// import 'package:moe/screens/views/dashboard/dashboard.dart';

// class SplashInitialization extends StatefulWidget {
//   const SplashInitialization({super.key});

//   @override
//   State<SplashInitialization> createState() => _SplashInitializationState();
// }

// class _SplashInitializationState extends State<SplashInitialization> {
//   AWSServices authService = AWSServices();
//   bool isAuthenticated = false;

//   @override
//   void initState() {
//     super.initState();
//     setState(() {
//       isAuthenticated = authService.isAuthenticated();
//     });
//     isAuthenticated
//         ? Navigator.of(context).pushAndRemoveUntil(
//             MaterialPageRoute(builder: (_) => const DashboardScreen()),
//             (Route<dynamic> route) => false,
//           )
//         : Navigator.of(context).pushAndRemoveUntil(
//             MaterialPageRoute(builder: (_) => const LoginPage()),
//             (Route<dynamic> route) => false,
//           );
//   }

//   @override
//   Widget build(BuildContext context) {
//     ThemeProperties themeProperties = ThemeProperties(context: context);

//     return Scaffold(
//       backgroundColor: themeProperties.scColor,
//       body: SizedBox(
//           width: double.infinity,
//           height: double.infinity,
//           child: Center(
//             child: Image.asset(themeProperties.isDarkMode
//                 ? 'assets/MOEDark.png'
//                 : 'assets/MOELight.png'),
//           )),
//     );
//   }
// }
