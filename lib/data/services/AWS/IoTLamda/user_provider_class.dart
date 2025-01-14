import 'package:flutter/material.dart';
import 'package:moe/data/services/AWS/IoTLamda/get_put_user_table.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  // Initialize the user in the provider
  void setUser(User user) {
    _user = user;
    notifyListeners(); // Notify listeners of the change
  }

  // Method to initialize user by calling the GetPutUserTable class
  Future<void> initUser() async {
    GetPutUserTable api = GetPutUserTable();
    User? user = await api.fetchUserInfo();

    if (user != null) {
      setUser(user); // Set the user in the provider
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      _prefs.setString("name", user.name);
      _prefs.setString("email", user.email);
      await _prefs.reload();
    }
  }
}
