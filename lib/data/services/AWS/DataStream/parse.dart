import 'dart:convert';

const String jsonString = '''
[{"Battery": {"Data": "{"Battery1": {"SOC": "99%", "Power": "102W"}, "Battery2": {"SOC": "48%", "Power": "1492W"}}"}}, {"MPPT": {"Data": "{"MPPT1": {"Power": "58W", "Current": "2.40A", "Voltage": "40V"}, "MPPT2": {"Power": "54W", "Current": "1.80A", "Voltage": "40V"}}"}}, {"Inverter": {"Data": "{"Power": "-598W", "Current": "-5.70A", "Voltage": "220V"}"}}]
''';

final List<dynamic> parsedData = jsonDecode(jsonString);
final Map<String, dynamic> batteryData =
    jsonDecode(parsedData[0]['Battery']['Data']);
final Map<String, dynamic> mpptData = jsonDecode(parsedData[1]['MPPT']['Data']);
final Map<String, dynamic> inverterData =
    jsonDecode(parsedData[2]['Inverter']['Data']);
