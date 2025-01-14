import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moe/domain/classes/utils.dart';
import 'package:moe/domain/providers/add_provider.dart';
import 'package:moe/screens/views/add_panel/review_page.dart';
import 'package:moe/screens/widgets/buttons.dart';
import 'package:provider/provider.dart';

class Capacity extends StatefulWidget {
  const Capacity({super.key});

  @override
  State<Capacity> createState() => _CapacityState();
}

class _CapacityState extends State<Capacity> {
  TextEditingController? capacityController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final AddProvider addProvider = Provider.of<AddProvider>(context);
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    var scColor = isDarkMode ? ScaffoldColor().dark : ScaffoldColor().light;
    var scColorInv = isDarkMode ? ScaffoldColor().light : ScaffoldColor().dark;
    var txColor = isDarkMode ? TextColor().dark : TextColor().light;
    var txColorInv = isDarkMode ? TextColor().light : TextColor().dark;
    final size = MediaQuery.of(context).size;

    bool _isInputNumeric(String input) {
      // Check if the input contains only numbers
      return RegExp(r'^[0-9]+$').hasMatch(input);
    }

    return Scaffold(
        backgroundColor: scColor,
        appBar: AppBar(
          toolbarHeight: size.height * 0.0912,
          backgroundColor: scColor,
          leading: IconButton(
            iconSize: 32,
            onPressed: Navigator.of(context).pop,
            icon: const Icon(
              Icons.chevron_left_rounded,
              size: 28,
            ),
            color: txColor,
          ),
        ),
        body: Container(
            padding: const EdgeInsets.all(18),
            height: double.infinity,
            width: double.infinity,
            child: SingleChildScrollView(
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "HINZUFÜGEN",
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontStyle: FontStyle.normal,
                                letterSpacing: 0.2,
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                                color: txColor)),
                      ),
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      SizedBox(
                        height: size.height * 0.15,
                        child: Text(
                          "Wie hoch ist die maximale Erzeugungskapazität?",
                          textAlign: TextAlign.left,
                          maxLines: 3,
                          style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 28,
                                  color: txColor)),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.15,
                        child: Center(
                          child: TextField(
                            controller: capacityController,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                capacityController?.text = value;
                              });
                            },
                            autofocus: true,
                            decoration: InputDecoration(
                                alignLabelWithHint: true,
                                border: const UnderlineInputBorder(
                                    borderSide: BorderSide()),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: txColor)),
                                hintText: " Kapazität",
                                focusColor: txColor,
                                hintStyle: GoogleFonts.roboto(
                                    textStyle: TextStyle(color: txColor))),
                            cursorColor: txColor,
                            showCursor: true,
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(color: txColor)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.37,
                      ),
                      GestureDetector(
                        onTap: () {
                          if(capacityController!.text.isNotEmpty){
                            if(_isInputNumeric(capacityController!.text)){
                              addProvider.setCapacity(capacityController!.text);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => const review_page()));
                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Please enter correctly.'),
                                duration: Duration(seconds: 5),
                              ));
                            }
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Please enter correctly.'),
                              duration: Duration(seconds: 5),
                            ));
                          }
                        },
                        child: NextButtonBarComponent(
                            size: size,
                            scColorInv: scColorInv,
                            txColorInv: txColorInv),
                      )
                    ]),
              ),
            )));
  }
}
