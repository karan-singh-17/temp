import 'package:ble_connector/ble_connector.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moe/onboarding/features/connect_to_wifi/view/connect_to_wifi_page.dart';
import 'package:moe/onboarding/features/finals.dart';
import 'package:moe/onboarding/features/search_wifi/cubit/search_wifi_cubit.dart';
import 'package:moe/onboarding/features/search_wifi/cubit/search_wifi_provider.dart';
import 'package:moe/onboarding/util/utils.dart';
import 'package:moe/onboarding/util/value_stream_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nineti_heimspeicher/nineti_heimspeicher.dart';

class SearchWiFiPage extends StatelessWidget {
  final BLEDevice device;
  SearchWiFiPage({super.key , required this.device});

  @override
  Widget build(BuildContext context) {
    return SearchWiFiCubitProvider(
      child: SearchWiFiView(device: device,),
    );
  }
}

class SearchWiFiView extends StatelessWidget {
  BLEDevice device;
  SearchWiFiView({super.key , required this.device});

  @override
  Widget build(BuildContext context) {
    void onSelectWifi(WiFiScanEntry wifi) {
      // return Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (_) => ConnectToWifiPage(wifi: wifi),
      //   ),
      // );

      final TextEditingController passwordController = TextEditingController();
      bool isError = false;

      showModalBottomSheet(
        backgroundColor: context.isDarkMode ? black : primaryLightBackgroundColor,
        context: context,
        isScrollControlled:
            true, // Ensures the bottom sheet adjusts for the keyboard
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                  top: 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Enter Password",
                      style: fontStyling(
                        16.0,
                        FontWeight.w700,
                        context.isDarkMode ? white : black,
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      style: fontStyling(
                        16.0,
                        FontWeight.w500,
                        context.isDarkMode ? white : black,
                      ),
                      obscureText: false, // Hides the text input
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: fontStyling(
                        16.0,
                        FontWeight.w700,
                        context.isDarkMode ? white : black,
                      ),
                        border: OutlineInputBorder(),
                        errorText:
                            isError ? "Incorrect Password. Try again." : null,
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        String enteredPassword = passwordController.text.trim();
                        WiFiConnectParameter param = new WiFiConnectParameter(ssid: wifi.ssid, password: enteredPassword);
                        print("dsads");
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Review_Exit(param: param, device: device)));
                        //context.read<HeimspeicherSystem>().connectToWifi(param);
                        //Navigator.pop(context);
                      },
                      child: Text("Connect"),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }

    return ValueStreamBuilder(
        stream: context.read<HeimspeicherSystem>().wifiStatusStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Placeholder();
          }

          final wiFiStatus = snapshot.data!;

          return BlocBuilder<SearchWifiCubit, SearchWifiState>(
              builder: (context, state) {
            return Scaffold(
                backgroundColor:
                    context.isDarkMode ? black : primaryLightBackgroundColor,
                // appBar: AppBar(
                //   titleSpacing: 0,
                //   backgroundColor:
                //       context.isDarkMode ? black : primaryLightBackgroundColor,
                //   title: Text(
                //     'Search WiFi',
                //     style: fontStyling(
                //       25.0,
                //       FontWeight.w500,
                //       context.isDarkMode ? white : black,
                //     ),
                //   ),
                //   bottom: wiFiStatus != WiFiStatus.scanning
                //       ? null
                //       : PreferredSize(
                //           preferredSize: const Size(double.infinity, 5),
                //           child: LinearProgressIndicator(
                //             backgroundColor: context.isDarkMode ? white : black,
                //           ),
                //         ),
                // ),
                bottomNavigationBar: Container(
                  height: MediaQuery.of(context).size.height * 0.09,
                  width: MediaQuery.of(context).size.width * 0.09,
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  child: InkWell(
                    onTap: () async {
                      print(wiFiStatus);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: context.isDarkMode ? white : black,
                          borderRadius: BorderRadius.circular(40)),
                      child: Center(
                        child: Text(
                          "weiter",
                          style: fontStyling(
                            16.0,
                            FontWeight.w700,
                            !context.isDarkMode ? white : black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                body: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  height: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).padding.top + 40,
                        ),
                        SvgPicture.asset(context.isDarkMode
                            ? "assets/images/deviceaddscreenappiconfordarkmode.svg"
                            : "assets/images/deviceaddscreenappiconforlightmode.svg"),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                        ),
                        Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text: "WLAN-Netzwerk auswählen\n",
                                    style: fontStyling(
                                      22.0,
                                      FontWeight.w800,
                                      context.isDarkMode ? white : black,
                                    )),
                                TextSpan(
                                  text: "\n",
                                ),
                                TextSpan(
                                    text: "WLAN-Netzwerk auswählen, um sich zu\n",
                                    style: fontStyling(
                                      14.0,
                                      FontWeight.w400,
                                      context.isDarkMode ? white : black,
                                    )),
                                TextSpan(
                                    text: "verbinden oder manuell hinzuzufügen.",
                                    style: fontStyling(
                                      14.0,
                                      FontWeight.w400,
                                      context.isDarkMode ? white : black,
                                    )),
                              ],
                            ),
                            textAlign: TextAlign.center),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Verfügbares Netzwerk",
                                style: fontStyling(
                                  16.0,
                                  FontWeight.w500,
                                  context.isDarkMode ? white : black,
                                )),
                            InkWell(
                                onTap: () {
                                  context
                                      .read<HeimspeicherSystem>()
                                      .scanForWifi();
                                },
                                child: Icon(
                                  Icons.refresh,
                                  color: context.isDarkMode ? white : black,
                                  size: 35,
                                ))
                          ],
                        ),
                        Container(
                            //color: (wiFiStatus.toString() == "Connected") ? Colors.amberAccent : Colors.blue,
                            height: 240,
                            alignment: Alignment.topCenter,
                            width: double.infinity,
                            child: ListView(
                              children: state.foundWiFis
                                  .map(
                                    (wifi) => GestureDetector(
                                      onTap: () => onSelectWifi(wifi),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, right: 5, bottom: 5),
                                        child: Container(
                                          padding: const EdgeInsets.all(15),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: containerBlack,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(
                                                Icons.wifi,
                                                color: white,
                                                size: 28,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets.only(
                                                      left: 14),
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    wifi.ssid,
                                                    style: fontStyling(
                                                      18.0,
                                                      FontWeight.w400,
                                                      white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // wifi.needsPassword
                                              //     ? Icon(
                                              //         Icons.lock,
                                              //         color: white,
                                              //       )
                                              //     : Icon(
                                              //         Icons.lock_open,
                                              //         color: white,
                                              //       )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            )),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                        ),
                        Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text: "Erfolgreich verbunden\n",
                                    style: fontStyling(
                                      20.0,
                                      FontWeight.w800,
                                      context.isDarkMode ? white : black,
                                    )),
                                TextSpan(
                                    text:
                                        "Um eine Verbindung herzustellen, stellen Sie bitte\n",
                                    style: fontStyling(
                                      14.0,
                                      FontWeight.w400,
                                      context.isDarkMode ? white : black,
                                    )),
                                TextSpan(
                                    text:
                                        "sicher,dass Ihr WLAN eingeschaltet ist.",
                                    style: fontStyling(
                                      14.0,
                                      FontWeight.w400,
                                      context.isDarkMode ? white : black,
                                    )),
                              ],
                            ),
                            textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                )
                // SafeArea(
                //   top: true,
                //   minimum: const EdgeInsets.only(top: 15),
                //   child: ListView(
                //     children: state.foundWiFis
                //         .map(
                //           (wifi) => GestureDetector(
                //             onTap: () => onSelectWifi(wifi),
                //             child: Padding(
                //               padding: const EdgeInsets.only(
                //                   left: 10, right: 10, top: 13),
                //               child: Container(
                //                 padding: const EdgeInsets.all(20),
                //                 width: double.infinity,
                //                 decoration: BoxDecoration(
                //                   color: containerBlack,
                //                   borderRadius: BorderRadius.circular(10),
                //                 ),
                //                 child: Row(
                //                   mainAxisAlignment:
                //                       MainAxisAlignment.spaceBetween,
                //                   children: [
                //                     Icon(
                //                       Icons.wifi,
                //                       color: white,
                //                       size: 28,
                //                     ),
                //                     Expanded(
                //                       child: Container(
                //                         padding: const EdgeInsets.only(left: 14),
                //                         alignment: Alignment.topLeft,
                //                         child: Text(
                //                           wifi.ssid,
                //                           style: fontStyling(
                //                             20.0,
                //                             FontWeight.w400,
                //                             white,
                //                           ),
                //                         ),
                //                       ),
                //                     ),
                //                     wifi.needsPassword
                //                         ? Icon(
                //                             Icons.lock,
                //                             color: white,
                //                           )
                //                         : Icon(
                //                             Icons.lock_open,
                //                             color: white,
                //                           )
                //                   ],
                //                 ),
                //               ),
                //             ),
                //           ),
                //         )
                //         .toList(),
                //   ),
                // ),
                );
          });
        });
  }
}
