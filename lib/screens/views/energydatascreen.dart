import 'dart:convert';

import 'package:flutter/material.dart';


class EnergyDataScreen extends StatelessWidget {
  final Map<String, dynamic> batteryData;
  final Map<String, dynamic> mpptData;
  final Map<String, dynamic> inverterData;

  const EnergyDataScreen({
    super.key,
    required this.batteryData,
    required this.mpptData,
    required this.inverterData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Energy Data")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            _buildSection("Battery Data", batteryData),
            _buildSection("MPPT Data", mpptData),
            _buildSection("Inverter Data", inverterData),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Map<String, dynamic> data) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ...data.entries.map((entry) {
              // Decode the nested JSON string if necessary
              final value =
                  entry.value is String ? jsonDecode(entry.value) : entry.value;
              if (value is Map<String, dynamic>) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: value.entries.map((nestedEntry) {
                    return Text("${nestedEntry.key}: ${nestedEntry.value}");
                  }).toList(),
                );
              } else {
                return Text("${entry.key}: $value");
              }
            }),
          ],
        ),
      ),
    );
  }
}
