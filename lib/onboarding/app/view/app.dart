import 'package:moe/onboarding/features/initial_page.dart';
import 'package:moe/onboarding/features/search_bt_devices/view/search_device_page.dart';
import 'package:moe/onboarding/features/splash_screen/initializable_provider.dart';
import 'package:moe/onboarding/features/splash_screen/view/splash_screen.dart';
import 'package:moe/onboarding/services/navigation_service.dart';
import 'package:moe/onboarding/services/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:moe/screens/views/dashboard/dashboard_multiple.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardMultiple(),));
        return false;
      },
      child: ServiceProvider(
        child: InitializableProvider(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              appBarTheme: AppBarTheme(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              ),
              useMaterial3: true,
            ),
            home: SplashScreenPage(
              route: MaterialPageRoute(
                builder: (c) => InitialPage(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
