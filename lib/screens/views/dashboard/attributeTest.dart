import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAttributesScreen extends StatefulWidget {
  @override
  _UserAttributesScreenState createState() => _UserAttributesScreenState();
}

class _UserAttributesScreenState extends State<UserAttributesScreen> {
  Map<String, String> userAttributes = {};
  bool isLoading = false;
  String errorMessage = '';

  /// Fetches user attributes (name and email) from SharedPreferences
  Future<void> fetchUserAttributes() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Fetch only name and email keys
      String? name = prefs.getString('name');
      String? email = prefs.getString('email');

      if (name == null || email == null) {
        throw Exception('User attributes (name or email) not found in SharedPreferences');
      }

      setState(() {
        userAttributes = {
          'name': name,
          'email': email,
        };
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to fetch user attributes: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Attributes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: isLoading ? null : fetchUserAttributes,
              child: isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text('Fetch User Attributes'),
            ),
            SizedBox(height: 20),
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            if (userAttributes.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: userAttributes.length,
                  itemBuilder: (context, index) {
                    String key = userAttributes.keys.elementAt(index);
                    String value = userAttributes[key] ?? 'N/A';
                    return ListTile(
                      title: Text(
                        key,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(value),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
