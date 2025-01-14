import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../domain/classes/utils.dart';

class Add_Shelly extends StatefulWidget {
  const Add_Shelly({super.key});

  @override
  State<Add_Shelly> createState() => _Add_ShellyState();
}

class _Add_ShellyState extends State<Add_Shelly> {
  Map<String, dynamic> devices = {};
  List<String> selectedDevices = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchDevices();
  }

  Future<void> _fetchDevices() async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final appUrl = prefs.getString('user_api_url');
      final token = prefs.getString('shelly_token');
      final savedDevicesJson = prefs.getString('selected_devices');

      List<String> savedDeviceIds = [];
      if (savedDevicesJson != null) {
        final savedDevices = jsonDecode(savedDevicesJson) as List<dynamic>;
        savedDeviceIds =
            savedDevices.map((device) => device['id'] as String).toList();
      }

      if (appUrl == null || token == null) {
        throw Exception("App URL or token not found in shared preferences.");
      }

      final response = await http.get(
        Uri.parse('$appUrl/interface/device/get_all_lists'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(Duration(seconds: 60));

      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['isok'] == true) {
          final allDevices = data['data']['devices'] as Map<String, dynamic>;

          final filteredDevices = Map.fromEntries(
            allDevices.entries
                .where((device) => !savedDeviceIds.contains(device.key)),
          );

          setState(() {
            devices = filteredDevices;
          });
        } else {
          throw Exception("API returned an error.");
        }
      } else {
        throw Exception("Failed to fetch devices: ${response.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _saveSelectedDevices() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Retrieve the existing devices list or initialize it as an empty list
      final String? savedDevicesJson = prefs.getString('selected_devices');
      List<Map<String, String>> savedDevices = [];

      if (savedDevicesJson != null) {
        savedDevices = List<Map<String, String>>.from(
          jsonDecode(savedDevicesJson),
        );
      }

      // Add the newly selected devices to the saved devices list
      for (String deviceId in selectedDevices) {
        final deviceName = devices[deviceId]['name'];

        // Avoid duplicate entries
        if (!savedDevices.any((device) => device['id'] == deviceId)) {
          savedDevices.add({
            'id': deviceId,
            'name': deviceName,
          });
        }
      }

      // Save the updated list back to SharedPreferences
      await prefs.setString('selected_devices', jsonEncode(savedDevices));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Devices saved successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving devices: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? black : white,
      body: isLoading
          ? Column(
              children: [
                headerDesign(),
                const Center(child: CircularProgressIndicator()),
              ],
            )
          : devices.isEmpty
              ? Column(
                  children: [
                    headerDesign(),
                    SizedBox(height: 50,),
                    Center(child: Text("No devices found." , style: TextStyle(color: isDarkMode ? white : black),)),
                  ],
                )
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 19, vertical: 15),
                  child: Column(
                    children: [
                      headerDesign(),
                      Expanded(
                        child: ListView.builder(
                          itemCount: devices.length,
                          itemBuilder: (context, index) {
                            final deviceId = devices.keys.elementAt(index);
                            final deviceName = devices[deviceId]['name'];

                            return CheckboxListTile(
                              activeColor: white,
                              checkColor: black,
                              tileColor: containerBlack,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              title: Text(
                                deviceName,
                                style: fontStyling(17.0, FontWeight.w400,
                                    primaryLightBackgroundColor),
                              ),
                              value: selectedDevices.contains(deviceId),
                              onChanged: (isSelected) {
                                setState(() {
                                  if (isSelected == true) {
                                    selectedDevices.add(deviceId);
                                  } else {
                                    selectedDevices.remove(deviceId);
                                  }
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: BottomAppBar(
        color: isDarkMode ? black : white,
        elevation: 10,
        child: Container(
          color: isDarkMode ? black : white,
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: containerBlack, // Button background color
                minimumSize:
                    Size(MediaQuery.of(context).size.width, 50), // Full width
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                if (selectedDevices.isNotEmpty) {
                  await _saveSelectedDevices();
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("No devices selected.")),
                  );

                  print(devices);
                }
              },
              child: Text(
                "Add",
                style: fontStyling(20.0, FontWeight.w500, white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget headerDesign() {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return SafeArea(
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              color: isDarkMode ? white : black,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            "ADD SHELLY",
            style: TextStyle(
              fontSize: 26.0,
              fontWeight: FontWeight.w700,
              color: isDarkMode ? white : black,
            ),
          ),
        ],
      ),
    );
  }
}
