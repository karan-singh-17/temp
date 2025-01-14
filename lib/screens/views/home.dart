import 'package:flutter/material.dart';
import 'package:moe/data/services/AWS/aws_services.dart';
import 'package:moe/domain/viewmodels/navBarController.dart';
import 'package:moe/screens/views/dashboard/DashboardScreen.dart';
import 'package:moe/screens/views/dashboard/dashboard_multiple.dart';
import 'package:moe/screens/views/devices.dart';
import 'package:moe/screens/views/profile.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // final AWSServices authProvider =
    //     Provider.of<AWSServices>(context, listen: true);
    final NavBarController navBarController = NavBarController();
    return Scaffold(
        body: IndexedStack(
         index: navBarController.currentIndex,
          children: const [DashboardMultiple(), ProfileScreen()],
    ));
  }
}
