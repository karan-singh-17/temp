import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moe/amplifyconfiguration.dart';
import 'package:moe/bootstrap.dart';
import 'package:moe/data/services/AWS/amplify/amplifyFlows.dart';
import 'package:moe/data/services/AWS/aws_services.dart';
import 'package:moe/data/services/NavigationServices.dart';
import 'package:moe/onboarding/app/view/app.dart';
import 'package:moe/screens/views/addmodulescreen/AddModuleScreen.dart';
import 'package:moe/screens/views/authentication/login.dart';
import 'package:moe/screens/views/dashboard/dashboard_multiple.dart';
import 'package:moe/screens/views/home.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {


  WidgetsFlutterBinding.ensureInitialized();
  await _configureAmplify();
  bootstrap(() => const MyApp());
}

Future<void> _configureAmplify() async {
  try {
    // Add Auth plugin
    Amplify.addPlugin(AmplifyAuthCognito());
    // Configure Amplify
    await Amplify.configure(
        amplifyconfig); // amplifyconfig is in amplifyconfiguration.dart
    print('Amplify configured successfully');
  } catch (e) {
    print('Failed to configure Amplify: $e');
  }
}

class MyApp extends StatefulWidget {
  // final CognitoUserSession? session;

  const MyApp({
    super.key,

  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool? isLoggedIn; // Nullable until the value is loaded

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _updateSystemUIOverlayStyle();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool loggedIn = prefs.getBool("isFinalLoggedIn") ?? false;
    prefs.reload();
    setState(() {
      isLoggedIn = loggedIn; // Update state with login status
    });
    if (isLoggedIn != null && isLoggedIn!) {
      final UserAuthProvider amplifyProvider = UserAuthProvider();
      await amplifyProvider.getUserAttributes();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    _updateSystemUIOverlayStyle();
  }
  // Future<void> _checkLoginStatus() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final bool loggedIn = prefs.getBool("isFinalLoggedIn") ?? false;
  //   prefs.reload();
  //   setState(() {
  //     isLoggedIn = loggedIn; // Update state with login status
  //   });
  //   if(isLoggedIn!){
  //     final UserAuthProvider amplifyProvider = UserAuthProvider();
  //     await amplifyProvider.getUserAttributes();
  //   }
  // }

  void _updateSystemUIOverlayStyle() {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final bool isDarkMode = brightness == Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor:
            isDarkMode ? const Color(0xff3D3D3E) : const Color(0xffE7E3CF)));
  }

  @override
  Widget build(BuildContext context) {
    final UserAuthProvider userAuthProvider = UserAuthProvider();

    return MaterialApp(
      routes: {
        '/dashboard': (context) => DashboardMultiple(),
        '/addModule': (context) => AddModuleScreen(
          selec_id: ModalRoute.of(context)?.settings.arguments as String? ?? '',
        ),
        '/onboard_app': (context) => App()
      },
      debugShowCheckedModeBanner: false,
      title: "MOE by Nineti",
      navigatorKey: NavigationService.navigatorKey,
      home: isLoggedIn == null
          ? const Center(child: CircularProgressIndicator()) // Show loading
          : AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.slowMiddle,
        switchOutCurve: Curves.slowMiddle,
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        },
        child: isLoggedIn! ? HomeScreen() : LoginPage(),
      ),
      theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
    );
  }
}
