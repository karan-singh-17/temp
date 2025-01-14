import 'dart:convert';

class Battery {
  final String id;
  String stateOfCharge; // Represented as a string
  String busPower;

  Battery({
    required this.id,
    required this.stateOfCharge,
    required this.busPower,
  });

  factory Battery.fromJson(Map<String, dynamic> json) {
    return Battery(
      id: json['Component'], // Assuming Component ID is used as ID
      stateOfCharge:
          json['stateOfCharge']?.toString() ?? '0.0', // Convert to string
      busPower: json['busPower']?.toString() ?? '0.0', // Convert to string
    );
  }
}

class Inverter {
  final String id;
  String busPower;

  Inverter({
    required this.id,
    required this.busPower,
  });

  factory Inverter.fromJson(Map<String, dynamic> json) {
    return Inverter(
      id: json['Component'],
      busPower: json['busPower']?.toString() ?? '0.0', // Convert to string
    );
  }
}

class Solar {
  final String id;
  String pvVoltage;
  String pvCurrent;
  String busPower;

  Solar({
    required this.id,
    required this.pvVoltage,
    required this.pvCurrent,
    required this.busPower,
  });

  factory Solar.fromJson(Map<String, dynamic> json) {
    return Solar(
      id: json['Component'],
      pvVoltage: json['pvVoltage']?.toString() ?? '0.0', // Convert to string
      pvCurrent: json['pvCurrent']?.toString() ?? '0.0', // Convert to string
      busPower: json['busPower']?.toString() ?? '0.0', // Convert to string
    );
  }
}

class System {
  final String id;
  final List<Battery> batteries;
  final Inverter inverter; // Single instance
  final List<Solar> solarPanels;

  System({
    required this.id,
    required this.batteries,
    required this.inverter,
    required this.solarPanels,
  });

  // Update or add a new battery entry
  void updateBattery(String batteryId, String newLevel, String newBusPower) {
    final battery = batteries.firstWhere(
      (b) => b.id == batteryId,
      orElse: () =>
          Battery(id: batteryId, stateOfCharge: '0.0', busPower: '0.0'),
    );

    if (!batteries.contains(battery)) {
      batteries.add(battery);
    }

    battery.stateOfCharge = newLevel;
    battery.busPower = newBusPower;
  }

  // Update or add a new solar panel entry
  void updateSolar(String solarId, String newVoltage, String newCurrent,
      String newBusPower) {
    final solar = solarPanels.firstWhere(
      (s) => s.id == solarId,
      orElse: () => Solar(
          id: solarId, pvVoltage: '0.0', pvCurrent: '0.0', busPower: '0.0'),
    );

    if (!solarPanels.contains(solar)) {
      solarPanels.add(solar);
    }

    solar.pvVoltage = newVoltage;
    solar.pvCurrent = newCurrent;
    solar.busPower = newBusPower;
  }

  void updateInverter(String newBusPower) {
    inverter.busPower = newBusPower;
  }

  // Parse the system data from the raw JSON message
  static System fromJson(Map<String, dynamic> json) {
    List<Battery> batteries = [];
    List<Solar> solarPanels = [];
    Inverter? inverter;

    for (var component in json['Components']) {
      String componentId = component['Component'];

      if (componentId.startsWith('Battery')) {
        batteries.add(Battery.fromJson(jsonDecode(component['Data'])[0]));
      } else if (componentId.startsWith('Solar')) {
        solarPanels.add(Solar.fromJson(jsonDecode(component['Data'])[0]));
      } else if (componentId.startsWith('Inverter')) {
        inverter = Inverter.fromJson(jsonDecode(component['Data'])[0]);
      }
    }

    return System(
      id: json['Timestamp'],
      batteries: batteries,
      inverter: inverter!,
      solarPanels: solarPanels,
    );
  }
}
