import 'package:flutter/material.dart';

class CustomToggleSwitch extends StatefulWidget {
  const CustomToggleSwitch({super.key});

  @override
  _CustomToggleSwitchState createState() => _CustomToggleSwitchState();
}

class _CustomToggleSwitchState extends State<CustomToggleSwitch> {
  bool isLeftSelected = true;

  void toggleSwitch() {
    setState(() {
      isLeftSelected = !isLeftSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleSwitch,
      child: Container(
        width: 150,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xffE7E3CF),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left: isLeftSelected ? 0 : 75,
              right: isLeftSelected ? 75 : 0,
              child: Container(
                width: 75,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      'Richtung',
                      style: TextStyle(
                        color: isLeftSelected ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Neigung',
                      style: TextStyle(
                        color: isLeftSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
