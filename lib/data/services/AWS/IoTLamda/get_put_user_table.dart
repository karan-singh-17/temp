import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

// User model class
class User {
  const User(
      {required this.name,
      required this.email,
      required this.registeredSystems});

  final String name;
  final String email;
  final List<String> registeredSystems;
}

class GetPutUserTable {
  final String apiUrl =
      "https://240ko4d457.execute-api.eu-central-1.amazonaws.com/production/user_data";
  SharedPreferences? prefs;

  // Constructor to initialize SharedPreferences
  GetPutUserTable() {
    _initSharedPrefs();
  }

  // Initialize the SharedPreferences object
  Future<void> _initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  // Function to add a registered system to the table
  Future<void> putUserTableData(String systemID) async {
    if (prefs == null) {
      await _initSharedPrefs(); // Ensure prefs is initialized
    }

    String? email = prefs?.getString('email');
    if (email == null) {
      print('Error: Email not found in SharedPreferences');
      return;
    }

    try {
      // Request body
      final Map<String, dynamic> requestBody = {
        'email': email,
        'registered_system': systemID,
      };

      // Sending POST request to the AWS Lambda URL
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      // Handling response
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData['message']);
      } else {
        print('Error: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Exception occurred: $e');
    }
  }

  // Function to fetch user registered systems
  Future<List<String>?> fetchUserSystems() async {
    if (prefs == null) {
      await _initSharedPrefs(); // Ensure prefs is initialized
    }

    String? email = prefs?.getString('email');
    if (email == null) {
      print('Error: Email not found in SharedPreferences');
      return null;
    }

    try {
      // Build the full URL with the query parameter
      final url = Uri.parse('$apiUrl?email=$email');

      // Send GET request to the AWS Lambda function
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });

      // Handle the response
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        // Extract the system or device IDs
        List<String> deviceIds = [];
        if (jsonData['registered_systems'] != null) {
          for (var system in jsonData['registered_systems']) {
            deviceIds.add(system.toString());
          }
        }

        return deviceIds; // Return the list of device IDs
      } else {
        print("Failed to load user data. Status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print('Exception occurred: $e');
      return null;
    }
  }

  // New function to fetch user info and provide it to the provider
  Future<User?> fetchUserInfo() async {
    if (prefs == null) {
      await _initSharedPrefs(); // Ensure prefs is initialized
    }

    String? email = prefs?.getString('email');
    if (email == null) {
      print('Error: Email not found in SharedPreferences');
      return null;
    }

    try {
      // Build the full URL with the query parameter
      final url = Uri.parse('$apiUrl?email=$email');

      // Send GET request to fetch user info
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });

      // Handle the response
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        // Parse the user info from the response
        String name = jsonData['name'] ?? 'Unknown';
        String email = jsonData['email'] ?? '';
        List<String> registeredSystems =
            (jsonData['registered_systems'] as List<dynamic>)
                .map((system) => system.toString())
                .toList();

        // Return the User object
        return User(
          name: name,
          email: email,
          registeredSystems: registeredSystems,
        );
      } else {
        print("Failed to load user info. Status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print('Exception occurred: $e');
      return null;
    }
  }
}
