import 'package:flutter/material.dart';
import 'package:moe/domain/classes/utils.dart';

class AddProvider extends ChangeNotifier {
  late String system_id;
  late String name;
  late DeviceLocation location;
  late double azimuth;
  late double tilt;
  late String capacity;
  late int bat_no;
  late int pan_no;

  void setName(String value) {
    name = value;
    notifyListeners();
  }

  void setbatno(int value) {
    bat_no = value;
    notifyListeners();
  }

  void setpano(int value) {
    pan_no = value;
    notifyListeners();
  }
  void set_sys(String value) {
    system_id = value;
    notifyListeners();
  }

  void setLocation(DeviceLocation value) {
    location = value;
    notifyListeners();
  }

  void setAzimuth(double value) {
    azimuth = value;
    notifyListeners();
  }

  void setTilt(double value) {
    tilt = value;
    notifyListeners();
  }

  void setCapacity(String value) {
    capacity = value;
    notifyListeners();
  }
}
