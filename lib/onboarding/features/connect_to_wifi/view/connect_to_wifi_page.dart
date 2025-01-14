import 'package:moe/onboarding/features/landing_page/view/wifi_connection_status_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nineti_heimspeicher/nineti_heimspeicher.dart';

import '../../../util/utils.dart';

class ConnectToWifiPage extends StatelessWidget {
  const ConnectToWifiPage({required this.wifi, super.key});

  final WiFiScanEntry wifi;

  @override
  Widget build(BuildContext context) {
    return ConnectToWiFiView(
      wifi: wifi,
    );
  }
}

class ConnectToWiFiView extends StatefulWidget {
  const ConnectToWiFiView({
    required this.wifi,
    super.key,
  });

  final WiFiScanEntry wifi;

  @override
  State<ConnectToWiFiView> createState() => _ConnectToWiFiViewState();
}

class _ConnectToWiFiViewState extends State<ConnectToWiFiView> {
  final TextEditingController _ssidController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ssidController.text = widget.wifi.ssid;
  }

  @override
  Widget build(BuildContext context) {
    Future<void> onConnect() async {
      final navigator = Navigator.of(context);

      final ssid = _ssidController.text;
      final password = _passwordController.text;

      await context
          .read<HeimspeicherSystem>()
          .connectToWifi(WiFiConnectParameter(ssid: ssid, password: password));

      navigator.pop();
    }

    return Scaffold(
      backgroundColor: context.isDarkMode ? black : primaryLightBackgroundColor,
      appBar: AppBar(
        backgroundColor:
            context.isDarkMode ? black : primaryLightBackgroundColor,
        titleSpacing: 0,
        title: Text(
          "Connect to WiFi",
          style: fontStyling(
            25.0,
            FontWeight.w500,
            context.isDarkMode ? white : black,
          ),
        ),
        /*actions: const [
          Icon(Icons.wifi),
          WifiConnectionStatusView(),
        ],*/
      ),
      body: Form(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextFormField(
                readOnly: true,
                controller: _ssidController,
                cursorColor:
                    !context.isDarkMode ? black : white, // Change cursor color
                style: TextStyle(
                  color: !context.isDarkMode
                      ? black
                      : white, // Change text entered color
                ),
                decoration: InputDecoration(
                  labelText: "SSID",
                  labelStyle: fontStyling(
                    15.0,
                    FontWeight.w500,
                    context.isDarkMode ? white : black,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: !context.isDarkMode
                            ? black
                            : white), // Change underline color when not focused
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: !context.isDarkMode
                            ? black
                            : white), // Change underline color when focused
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextFormField(
                controller: _passwordController,
                cursorColor:
                    !context.isDarkMode ? black : white, // Change cursor color
                style: TextStyle(
                  color: !context.isDarkMode
                      ? black
                      : white, // Change text entered color
                ),
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: fontStyling(
                    15.0,
                    FontWeight.w500,
                    context.isDarkMode ? white : black,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: !context.isDarkMode
                            ? black
                            : white), // Change underline color when not focused
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: !context.isDarkMode
                            ? black
                            : white), // Change underline color when focused
                  ),
                ),
              ),
            ),
            Container(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                child: borderMainUiButton(
                    onConnect,
                    "Connect",
                    !context.isDarkMode ? black : white,
                    !context.isDarkMode ? black : white))
          ],
        ),
      ),
    );
  }
}
