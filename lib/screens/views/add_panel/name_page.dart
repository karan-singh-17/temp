import 'package:flutter/material.dart';
import 'package:moe/domain/providers/add_provider.dart';
import 'package:moe/screens/views/add_panel/location_page.dart';
import 'package:moe/screens/widgets/buttons.dart';
import 'package:moe/screens/widgets/custom_text_field.dart';

import 'package:provider/provider.dart';

import '../../../domain/classes/utils.dart';

class name_page extends StatefulWidget {
  String sys_id;
  int bat_no;
  int pan_no;
  name_page({super.key , required this.sys_id , required this.pan_no , required this.bat_no});

  @override
  State<name_page> createState() => _name_pageState();
}

class _name_pageState extends State<name_page> {
  TextEditingController name_cont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AddProvider addProvider = Provider.of<AddProvider>(context);
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    var scColor = isDarkMode ? ScaffoldColor().dark : ScaffoldColor().light;
    var scColorInv = isDarkMode ? ScaffoldColor().light : ScaffoldColor().dark;
    var txColor = isDarkMode ? TextColor().dark : TextColor().light;
    var txColorInv = isDarkMode ? TextColor().light : TextColor().dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: scColor,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
        child: GestureDetector(
          onTap: () {
            addProvider.set_sys(widget.sys_id);
            addProvider.setName(name_cont.text);
            addProvider.setbatno(widget.bat_no);
            addProvider.setpano(widget.pan_no);
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const location_page()));
          },
          child: NextButtonBarComponent(
              size: size, scColorInv: scColorInv, txColorInv: txColorInv),
        ),
      ),
      appBar: AppBar(
        backgroundColor: scColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 19,
            color: txColor,
          ),
        ),
        leadingWidth: 50,
      ),

      /*InkWell(
            onTap: () {
              if (name_cont.text.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => location_page(
                            name: name_cont.text,
                          )),
                );
              }
            },
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 8),
              decoration: isDarkMode
                  ? ThemeClass.darkContainerDecoration
                  : ThemeClass.lightContainerDecoration,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Nächste",
                    style: TextStyle(
                      color: isDarkMode ? txColor : txColorInv,
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/next_icon.svg',
                    color: isDarkMode
                        ? ThemeClass.darkSvgColor
                        : ThemeClass.lightSvgColor,
                  ),
                ],
              ),
            ),
          ),*/

      body: Padding(
        padding: const EdgeInsets.only(left: 22.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Text(
                "HINZUFÜGEN",
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: txColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
              ),
              Text(
                "Wie soll die Anlage heißen?",
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                maxLines: 3,
                style: TextStyle(
                  color: txColor,
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              custom_text_field(
                txt_cont: name_cont,
                label: "Name",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
