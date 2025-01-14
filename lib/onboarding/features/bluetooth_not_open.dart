import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moe/domain/helper/DeviceDarkAndLightModeDetector.dart';
import 'package:moe/onboarding/features/search_bt_devices/view/search_device_page.dart';

import '../../domain/classes/utils.dart';
import '../../screens/views/shelly/shelly_home.dart';

class Bluetooth_Close extends StatefulWidget {
  const Bluetooth_Close({super.key});

  @override
  State<Bluetooth_Close> createState() => _Bluetooth_CloseState();
}

class _Bluetooth_CloseState extends State<Bluetooth_Close> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor : context.isDarkMode ? black : primaryLightBackgroundColor,

      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.09,
        width: MediaQuery.of(context).size.width * 0.09,
        padding: EdgeInsets.only(left: 20 , right: 20 , top: 10 , bottom: 10),
        child: InkWell(
          onTap: () async{
            (await FlutterBluePlus.isOn)
                ? Navigator.push(context,
                MaterialPageRoute(builder: (context) => SearchDevicePage()))
                : ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Bluetooth is still not turned on") , duration: Duration(seconds: 5)),);
          },
          child: Container(
            decoration: BoxDecoration(
                color: context.isDarkMode ? white : black,
                borderRadius: BorderRadius.circular(40)
            ),
            child: Center(
              child: Text("schalten Sie Bluetooth ein" , style: fontStyling(16.0, FontWeight.w700, !context.isDarkMode ? white : black,),),
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
                height: MediaQuery.of(context).size.height * 0.06,
              ),
          
              Text("Bluetooth-Finder" , style: fontStyling(18.0, FontWeight.w800, context.isDarkMode ? white : black,)),
          
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
          
              Container(
                  padding: EdgeInsets.only(left: 10 , right: 10),
                  child: Image.asset(!context.isDarkMode ? "assets/images/Group 378.png" : "assets/images/Group 378 light.png")
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
          
              Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: "schalten Sie Bluetooth ein\n",
                          style: fontStyling(24.0, FontWeight.w800, context.isDarkMode ? white : black,)
                      ),
                      TextSpan(
                        text: "\n",
                      ),
                      TextSpan(
                          text: "Um Ihr tragbares Gerät mit der App zu verbinden, stellen\n",
                          style: fontStyling(12.0, FontWeight.w400, context.isDarkMode ? white : black,)
                      ),
                      TextSpan(
                          text: "Sie sicher, dass Ihr Bluetooth eingeschaltet ist",
                          style: fontStyling(12.0, FontWeight.w400, context.isDarkMode ? white : black,)
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center
              ),
            ],
          ),
        ),
      ),

    );
  }
}
