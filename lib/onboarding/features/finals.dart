import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moe/onboarding/app/view/after_device_connected_wrapper.dart';
import 'package:moe/onboarding/util/utils.dart';
import 'package:ble_connector/ble_connector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:nineti_heimspeicher/nineti_heimspeicher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/services/AWS/IoTLamda/get_put_user_table.dart';
import '../../screens/views/dashboard/dashboard_multiple.dart';
import 'cloud_provisioning/domain/fetch_provisioning_package.dart';

class Review_Exit extends StatefulWidget {
  WiFiConnectParameter param;
  final BLEDevice device;
  Review_Exit({super.key , required this.param , required this.device});

  @override
  State<Review_Exit> createState() => _Review_ExitState();
}

class _Review_ExitState extends State<Review_Exit> {
  String status = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prov_Stuff();
  }

  prov_Stuff() async{
    setState(() {
      status = "Connecting to Wifi";
    });

    await context.read<HeimspeicherSystem>().connectToWifi(widget.param);

    if(context.read<HeimspeicherSystem>().wifiStatusStream.value.toString() != "Connected"){

    }else{
      setState(() {
        status = "Provisioning...";
      });

      singleFunctionCloudProvisioning(context, widget.device);
    }
  }

  void singleFunctionCloudProvisioning(
      BuildContext context, BLEDevice device) async {
    final provisioningPackager = ProvisioningPackager();
    final GetPutUserTable userApi = GetPutUserTable();
    String isDownloading = 'Downloading...';

    try {
      // Fetch provisioning package
      await provisioningPackager
          .fetchProvisioningPackage(device.id.replaceAll(":", "_"));
      SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      final filePath = sharedPreferences.getString('provisioningPath');
      if (filePath == null) {
        throw Exception('Provisioning path not found in shared preferences.');
      }
      final provisioningPackage = File(filePath);

      isDownloading = 'Successfully downloaded. Provisioning in progress...';

      // Read data from the provisioning package
      final provisioningData = provisioningPackage.readAsBytesSync();

      // Provision cloud connection
      final heimspeicher = context.read<HeimspeicherSystem>();
      heimspeicher.provisionCloudConnection(provisioningData);

      // Update the user table
      final String systemID = device.id.replaceAll(":", "_");
      await userApi.putUserTableData(systemID);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cloud provisioning complete.'),
        ),
      );

      Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (_) => TemporaryScreen(),
        ),
      );

      await Future.delayed(const Duration(seconds: 5));

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardMultiple(),
        ),
            (route) => false,
      );
    } catch (e) {
      // Handle errors
      isDownloading = 'Failed to download or provision: ${e.toString()}';
      Fluttertoast.showToast(msg: e.toString());

      Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (_) => ConnectionFailedScreen(),
        ),
      );

      await Future.delayed(const Duration(seconds: 5));

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardMultiple(),
        ),
            (route) => false,
      );

      //return;
    }

    // Optionally display the status
    final status =
        context.read<HeimspeicherSystem>().cloudProvisioningStatus.valueOrNull;
    print('Provisioning status: ${status ?? 'NO DATA'}');

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: context.isDarkMode ? black : primaryLightBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
          ),
          Center(
            child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.6,
                child: Center(
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballTrianglePathColoredFilled,
                    colors: [
                      DarkMode(context).isDarkMode
                          ? TextColor().dark
                          : TextColor().light
                    ],
                  ),
                )),
          ),
          Text(
            status,
            style: fontStyling(
              16.0,
              FontWeight.w400,
              context.isDarkMode ? white : black,
            ),
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
      // body: ListView(
      //   children: [
      //     Card(
      //       child: ListTile(
      //         title: Text(data.toString()),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}

class TemporaryScreen extends StatelessWidget {
  const TemporaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: context.isDarkMode ? black : primaryLightBackgroundColor,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top + 40,
            ),
            SvgPicture.asset(context.isDarkMode
                ? "assets/images/deviceaddscreenappiconfordarkmode.svg"
                : "assets/images/deviceaddscreenappiconforlightmode.svg"),
            Expanded(
              child: SvgPicture.asset(context.isDarkMode
                  ? "assets/images/deviceconnectedtickfordarkmode.svg"
                  : "assets/images/deviceconnectedtickforlightmode.svg"),
            ),
            Text(
              "Erfolgreich Gerät verbunden",
              style: fontStyling(
                25.0,
                FontWeight.w700,
                context.isDarkMode ? white : black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}

class ConnectionFailedScreen extends StatelessWidget {
  const ConnectionFailedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: context.isDarkMode ? black : primaryLightBackgroundColor,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top + 40,
            ),
            SvgPicture.asset(context.isDarkMode
                ? "assets/images/deviceaddscreenappiconfordarkmode.svg"
                : "assets/images/deviceaddscreenappiconforlightmode.svg"),
            const SizedBox(
              height: 40,
            ),
            Expanded(
              child: SvgPicture.asset(context.isDarkMode
                  ? "assets/images/deviceconnectionunsuccessiconfordarkmode.svg"
                  : "assets/images/deviceconnectionunsuccessiconforlightmode.svg"),
            ),
            const SizedBox(
              height: 40,
            ),
            Text("Gerät nicht verbunden",
                style: fontStyling(
                  25.0,
                  FontWeight.w700,
                  context.isDarkMode ? white : black,
                )),
            const SizedBox(
              height: 40,
            ),
            solidColorMainUiButton(
                    () async {},
                "Erneut versuchen",
                context.isDarkMode ? white : black,
                context.isDarkMode ? black : white),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
