import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moe/data/services/AWS/IoTLamda/user_provider_class.dart';
import 'package:moe/data/services/AWS/amplify/amplifyFlows.dart';
import 'package:moe/data/services/AWS/aws_services.dart';
import 'package:moe/domain/classes/utils.dart';
import 'package:moe/screens/views/authentication/changePassModal.dart';
import 'package:moe/screens/views/authentication/login.dart';
import 'package:moe/screens/views/authentications/ChangePasswordScreen.dart';
import 'package:moe/screens/widgets/customNavBar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? name;
  String? email;
  final UserAuthProvider userAuthProvider = UserAuthProvider();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    userProvider.initUser();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      name = _prefs.getString("name");
      email = _prefs.getString("email");
    });
    // setState(() {
    //   img =
    // });
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: true);
    // AWSServices awsServices = Provider.of<AWSServices>(context);
    List<ProfileTileListObj> profileTileList = [
      ProfileTileListObj(
          icon: Icons.account_circle,
          tileName: "Kennwort ändern".toUpperCase(),
          onTapCallback: () async {
            // await awsServices.resetPassword(email!);
          }),
      ProfileTileListObj(
          icon: Icons.format_quote_rounded,
          tileName: "FAQ",
          onTapCallback: () {}),
      ProfileTileListObj(
          icon: Icons.gavel_rounded,
          tileName: "RECHTLICHES",
          onTapCallback: () {}),
      ProfileTileListObj(
          icon: Icons.logout_rounded,
          tileName: "Abmeldung".toUpperCase(),
          onTapCallback: () async {
            await userAuthProvider.signOutCurrentUser();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => LoginPage()),
              (route) {
                return false;
              },
            );
          })
    ];

    ThemeProperties themeProperties = ThemeProperties(context: context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: themeProperties.size.height * 0.1,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            "PROFIL",
            style: GoogleFonts.robotoFlex(
                textStyle: TextStyle(
                    fontSize: 26,
                    color: themeProperties.txColor,
                    fontWeight: FontWeight.bold)),
          ),
        ),
        backgroundColor: themeProperties.scColor,
        // actions: [
        //   Center(
        //     child: Container(
        //       padding: EdgeInsets.symmetric(horizontal: 10),
        //       child: Center(
        //         child: IconButton(
        //           onPressed: () {
        //             Navigator.of(context)
        //                 .push(MaterialPageRoute(builder: (_) => name_page()));
        //           },
        //           icon: Icon(
        //             Icons.add,
        //             color: themeProperties.txColor,
        //             size: 30,
        //           ),
        //         ),
        //       ),
        //     ),
        //   )
        // ],
      ),
      backgroundColor: themeProperties.scColor,
      body: Container(
        padding: EdgeInsets.all(16),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                CircleAvatar(
                  foregroundImage: Image.asset(
                    "assets/images/profile_placeholder_dark.png",
                  ).image,
                  radius: 50,
                  backgroundColor: themeProperties.scColorInv,
                ),
                SizedBox(
                  width: themeProperties.size.width * 0.05,
                ),
                Expanded( // Add Expanded to give the Column flexible space
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userProvider.user?.name ?? " ",
                        style: GoogleFonts.roboto(
                          color: themeProperties.txColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                      ),
                      Text(
                        userProvider.user?.email ?? " ",
                        style: GoogleFonts.roboto(
                          color: themeProperties.txColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: themeProperties.size.height * 0.1,
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) => ProfileScreenTile(
                  themeProperties: themeProperties,
                  icon: profileTileList[index].icon,
                  tileName: profileTileList[index].tileName,
                  onTap: profileTileList[index].onTapCallback,
                ),
                itemCount: profileTileList.length,
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}

class ProfileScreenTile extends StatelessWidget {
  const ProfileScreenTile(
      {super.key,
      required this.themeProperties,
      required this.icon,
      required this.tileName,
      required this.onTap});

  final IconData icon;
  final String tileName;
  final ThemeProperties themeProperties;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: ListTile(
        onTap: () {
          onTap();
        }, // Directly assign the onTap callback here
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: themeProperties.scColorInv,
          child: Icon(
            icon,
            color: themeProperties.txColorInv,
            size: 30,
          ),
        ),
        contentPadding: EdgeInsets.all(8),
        horizontalTitleGap: 20,
        title: Text(
          tileName,
          style: GoogleFonts.roboto(
              color: themeProperties.txColor,
              fontSize: 16,
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}

class ProfileTileListObj {
  const ProfileTileListObj(
      {required this.icon,
      required this.tileName,
      required this.onTapCallback});
  final IconData icon;
  final String tileName;
  final VoidCallback onTapCallback;
}
