import 'package:flutter/material.dart';
import 'package:moe/data/services/AWS/IoTLamda/data_from_table.dart';
import 'package:moe/data/services/AWS/IoTLamda/iot_data_model.dart';
import 'package:provider/provider.dart';

class DeviceProvider extends ChangeNotifier {
  final List<System> _devices = [];
  final List<SystemWebSocketManager> _webSocketManagers = [];
  int _averageBatteryPercentage = 0;

  System? getDeviceById(String id) {
    try {
      return _devices.firstWhere((device) => device.id == id);
    } catch (e) {
      return null; // Return null if no device found
    }
  }

  List<System> getAllSystems() {
    return _devices;
  }

  Future<void> addDevice(System device) async {
    _devices.add(device);
    var webSocketManager = SystemWebSocketManager(device, notifyListeners);
    _webSocketManagers.add(webSocketManager);
    await webSocketManager.connectWebSocket();
    notifyListeners();
  }

  int get averageBatteryPercentage => _averageBatteryPercentage;

  void calculateAverageBatteryPercentage() {
    List<System> systems = getAllSystems();
    double totalBatteryPercentage = 0.0;
    int batteryCount = 0;

    for (var system in systems) {
      for (var battery in system.batteries) {
        double? stateOfCharge = double.tryParse(battery.stateOfCharge);
        if (stateOfCharge != null) {
          totalBatteryPercentage += stateOfCharge;
          batteryCount++;
        }
      }
    }
    if (batteryCount > 0) {
      _averageBatteryPercentage =
          (totalBatteryPercentage / batteryCount).round().toInt();
    }
    notifyListeners();
  }

  List<System> get devices => _devices;

  @override
  void dispose() {
    for (var manager in _webSocketManagers) {
      manager.closeConnection();
    }
    super.dispose();
  }
}
