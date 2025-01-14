import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moe/data/services/AWS/aws_services.dart';
import 'package:moe/domain/classes/utils.dart';
import 'package:moe/screens/views/add_panel/name_page.dart';
import 'package:moe/screens/views/addmodulescreen/AddModuleScreen.dart';
import 'package:moe/screens/widgets/customNavBar.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeProperties themeProperties = ThemeProperties(context: context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: themeProperties.size.height * 0.1,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            "IHRE EINRICHTUNG",
            style: GoogleFonts.robotoFlex(
                textStyle: TextStyle(
                    fontSize: 26,
                    color: themeProperties.txColor,
                    fontWeight: FontWeight.bold)),
          ),
        ),
        backgroundColor: themeProperties.scColor,
        actions: [
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                child: IconButton(
                  onPressed: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (_) => const AddModuleScreen()));
                  },
                  icon: Icon(
                    Icons.add,
                    color: themeProperties.txColor,
                    size: 30,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      backgroundColor: themeProperties.scColor,
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: themeProperties.size.width * 0.35,
              height: themeProperties.size.height * 0.25,
              child: SvgPicture.asset(
                'assets/svg/no-connection.svg',
                color: themeProperties.txColor.withOpacity(0.25),
              ),
            ),
            Text(
              "KEINE GERÄTE ANGEMELDET",
              style: GoogleFonts.robotoFlex(
                  color: themeProperties.txColor.withOpacity(0.3),
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
            )
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
