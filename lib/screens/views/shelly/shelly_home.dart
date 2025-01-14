import 'dart:convert'; // For JSON decoding
import 'package:crypto/crypto.dart'; // For SHA1 encoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moe/screens/views/shelly/add_shelly.dart';
import 'package:moe/screens/views/shelly/shelly_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/classes/utils.dart';

class Shelly_Home extends StatefulWidget {
  const Shelly_Home({super.key});

  @override
  State<Shelly_Home> createState() => _Shelly_HomeState();
}

class _Shelly_HomeState extends State<Shelly_Home> {
  String? shellyToken;
  String? shelly_email;
  String? shelly_password;
  Map<String, dynamic> devices = {};
  String? userApiUrl;
  bool isLoading = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    check_login();
    _checkToken();
    fetchDevices();
  }

  Future<void> check_login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? email = prefs.getString("shelly_email");
    String? password = prefs.getString("shelly_password");

    if (password == null || email == null || password.isEmpty ||
        email.isEmpty) {
      return;
    } else {
      try {
        final hashedPassword = sha1.convert(utf8.encode(password)).toString();
        String encodedEmail = Uri.encodeComponent(email);

        print(Uri.parse(
            "https://shelly-22-eu.shelly.cloud/auth/login?email=$encodedEmail&password=$hashedPassword&var=2"));
        final response = await http.post(Uri.parse(
            "https://shelly-22-eu.shelly.cloud/auth/login?email=$encodedEmail&password=$hashedPassword&var=2"));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          if (data["isok"] == true) {
            final token = data["data"]["token"];
            final apiUrl = data["data"]["user_api_url"];

            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString("shelly_token", token);
            await prefs.setString("user_api_url", apiUrl);
            await prefs.setString("shelly_email", email);
            await prefs.setString("shelly_password", password);

            setState(() {
              shellyToken = token;
              userApiUrl = apiUrl;
              shelly_password = password;
              shelly_email = email;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Login successful!")),
            );
          } else {
            throw Exception("Login failed. Please check your credentials.");
          }
        } else {
          throw Exception("Failed to connect to the server.");
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }
  Future<void> fetchDevices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if devices are saved
    String? devicesString = prefs.getString('selected_devices');
    print(devicesString);

    if (devicesString != null && devicesString.isNotEmpty) {
      try {
        // Attempt to decode the JSON string
        final List<dynamic> decodedDevices = jsonDecode(devicesString);

        Map<String, dynamic> devicesMap = {};
        for (var device in decodedDevices) {
          if (device is Map<String, dynamic>) {
            String id = device['id'];
            devicesMap[id] = device;
          }
        }

        setState(() {
          devices = devicesMap;
        });
      } catch (e) {
        // Handle JSON decoding errors
        setState(() {
          devices = {};
        });
        print("Error decoding JSON: $e");
      }
    } else {
      setState(() {
        devices = {};
      });
    }
  }



  Future<void> _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      shellyToken = prefs.getString("shelly_token");
      userApiUrl = prefs.getString("user_api_url");
      shelly_email = prefs.getString("shelly_email");
      shelly_password = prefs.getString("shelly_password");
      isLoading = false;
    });
  }

  Future<void> _login(String email, String password) async {
    try {
      final hashedPassword = sha1.convert(utf8.encode(password)).toString();
      String encodedEmail = Uri.encodeComponent(email);

      print(Uri.parse(
          "https://shelly-22-eu.shelly.cloud/auth/login?email=$encodedEmail&password=$hashedPassword&var=2"));
      final response = await http.post(Uri.parse(
          "https://shelly-22-eu.shelly.cloud/auth/login?email=$encodedEmail&password=$hashedPassword&var=2"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["isok"] == true) {
          final token = data["data"]["token"];
          final apiUrl = data["data"]["user_api_url"];

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("shelly_token", token);
          await prefs.setString("user_api_url", apiUrl);
          await prefs.setString("shelly_email", email);
          await prefs.setString("shelly_password", password);

          setState(() {
            shellyToken = token;
            userApiUrl = apiUrl;
            shelly_password = password;
            shelly_email = email;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login successful!")),
          );
        } else {
          throw Exception("Login failed. Please check your credentials.");
        }
      } else {
        throw Exception("Failed to connect to the server.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Check if user is logged in
    if (shelly_email == null || shelly_password == null || shellyToken == null || shellyToken!.isEmpty) {
      return _buildLoginScreen();
    } else {
      //_login(shelly_email!, shelly_password!);
      return _buildMainScreen();
    }
  }

  Widget _buildLoginScreen() {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? ScaffoldColor().dark : ScaffoldColor().light,
      body: Padding(
        padding: const EdgeInsets.only(left: 18.0 , right: 18 , top: 16 , bottom: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              headerDesign_login(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.2,),
              Text("LOGIN TO SHELLY ACCOUNT" , style: fontStyling(20.0, FontWeight.w600,
                  isDarkMode ? primaryLightBackgroundColor : black),),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
              TextField(
                controller: emailController,
                style: fontStyling(13.0, FontWeight.w500,
                    isDarkMode ? primaryLightBackgroundColor : black),
                decoration: InputDecoration(labelText: "Email" , labelStyle: fontStyling(15.0, FontWeight.w500,
                    isDarkMode ? primaryLightBackgroundColor : black)),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: "Password" , labelStyle: fontStyling(15.0, FontWeight.w500,
                    isDarkMode ? primaryLightBackgroundColor : black)),
                style: fontStyling(13.0, FontWeight.w500,
                    isDarkMode ? primaryLightBackgroundColor : black),
                obscureText: true,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: containerBlack, // Button background color
                    minimumSize:
                    Size(MediaQuery.of(context).size.width, 50), // Full width
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                ),
                onPressed: () {
                  _login(emailController.text, passwordController.text);
                },
                child: Text("Login" , style: TextStyle(color: white),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainScreen() {
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? ScaffoldColor().dark : ScaffoldColor().light,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headerDesign(),
            const SizedBox(height: 20),
            Text(
              "Devices (${devices.length})",
              style: fontStyling(
                20.0,
                FontWeight.w500,
                isDarkMode ? white : black,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: devices.isEmpty
                  ? const Center(
                child: Text(
                  "No devices found.",
                  style: TextStyle(fontSize: 16),
                ),
              )
                  : ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  final deviceId = devices.keys.elementAt(index);
                  final device = devices[deviceId];

                  return InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Shelly_Details(id: deviceId , name: device['name'],)));
                    },
                    child: Card(
                      color: isDarkMode
                          ? Colors.grey[800]
                          : Colors.grey[200],
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: Icon(
                          Icons.device_hub,
                          color: isDarkMode ? white : black,
                        ),
                        title: Text(
                          device['name'] ?? "Unknown",
                          style: fontStyling(
                            18.0,
                            FontWeight.w600,
                            isDarkMode ? white : black,
                          ),
                        ),
                        subtitle: Text(
                          "ID: $deviceId",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
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
            "SHELLY DEVICE",
            style: TextStyle(
              fontSize: 26.0,
              fontWeight: FontWeight.w700,
              color: isDarkMode ? white : black,
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Add_Shelly())).then((_){
                fetchDevices();
              });
            },
            child: Icon(
              Icons.add_circle_outline,
              color: isDarkMode ? white : black,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
  Widget headerDesign_login() {
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
            "SHELLY DEVICE",
            style: TextStyle(
              fontSize: 26.0,
              fontWeight: FontWeight.w700,
              color: isDarkMode ? white : black,
            ),
          ),
          const Spacer(),
          // InkWell(
          //   onTap: (){
          //     Navigator.push(context, MaterialPageRoute(builder: (context) => Add_Shelly())).then((_){
          //       fetchDevices();
          //     });
          //   },
          //   child: Icon(
          //     Icons.add_circle_outline,
          //     color: isDarkMode ? white : black,
          //     size: 30,
          //   ),
          // ),
        ],
      ),
    );
  }
}
