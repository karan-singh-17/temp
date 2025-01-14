import 'dart:async';

import 'package:moe/onboarding/app/view/after_device_connected_wrapper.dart';
import 'package:moe/onboarding/util/utils.dart';
import 'package:ble_connector/ble_connector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_indicator/loading_indicator.dart';

class ConnectToDevicePage extends StatefulWidget {
  const ConnectToDevicePage({
    required this.deviceInfo,
    super.key,
  });

  final BLEDeviceAdvertInfo deviceInfo;
  @override
  State<ConnectToDevicePage> createState() => _ConnectToDevicePageState();
}

class _ConnectToDevicePageState extends State<ConnectToDevicePage> {
  late final BLEDevice device;
  StreamSubscription? _subscription;
  static const l2CapSignatureOverhead = 12;

  @override
  void initState() {
    device = BLEDevice.fromAdvertisement(info: widget.deviceInfo)..connect();
    _subscription = device.connectionState.listen((d) async {
      if (d == BLEConnectionState.connected) {
        // Navigator.of(context).push(
        //   CupertinoPageRoute(
        //     builder: (_) => TemporaryScreen(),
        //   ),
        // );
        final navigator = Navigator.of(context);
        final rawMtu = await device.requestMtu() - 12;
        // Subtract the L2CAP signature overhead (android devices)
        final mtu = rawMtu - l2CapSignatureOverhead;

        //await Future.delayed(const Duration(seconds: 5));

        if (mounted) {
          Navigator.of(context).pushReplacement(
            CupertinoPageRoute(
              builder: (_) => AfterDeviceConnectedWrapper(
                chunkSize: mtu,
                device: device,
              ),
            ),
          );
        } else if (d == BLEConnectionState.disconnected ||
            d == BLEConnectionState.disconnecting) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ConnectionFailedScreen(),
            ),
          );

          await Future.delayed(const Duration(seconds: 5));

          if (mounted) {
            Navigator.of(context).pop();
          }
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: device.connectionState,
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return const Placeholder();
        }

        final data = snapshot.data!;

        return Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          backgroundColor:
              context.isDarkMode ? black : primaryLightBackgroundColor,
          floatingActionButton: Container(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width * 0.9,
                maxWidth: MediaQuery.of(context).size.width * 0.9,
              ),
              child: borderMainUiButton(() {
                device.disconnect();
                Navigator.pop(context);
              }, 'Stornieren', context.isDarkMode ? white : black,
                  context.isDarkMode ? white : black)),
          // appBar: AppBar(
          //   title: Text('Connecting to ${widget.deviceInfo.name}'),
          // ),

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
                'Connecting to ${widget.deviceInfo.name}',
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
      },
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
