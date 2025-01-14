import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:moe/data/services/AWS/IoTLamda/iot_data_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SystemWebSocketManager {
  final System system;
  late WebSocketChannel channel;
  final VoidCallback notifyProvider;
  String _messageBuffer = ''; // Buffer to store incomplete messages
  SystemWebSocketManager(this.system , this.notifyProvider);

  Future<void> connectWebSocket() async {
    final uri = Uri.parse(
        'wss://ojil6u53db.execute-api.eu-central-1.amazonaws.com/production/?tableName=moe_${system.id}');
    channel = WebSocketChannel.connect(uri);

    final payload = {
      "action": "sendMessage",
      "body": {"tableName": "moe_${system.id}"}
    };
    final initialPayload = jsonEncode(payload);

    try {
      await channel.ready;
      print("Connection established for system ${system.id}");
      channel.sink.add(initialPayload);
      print("Initial payload sent: $initialPayload");

      _listenToStream();
    } on SocketException catch (e) {
      print("SocketException: ${e.toString()}");
      rethrow;
    } on WebSocketChannelException catch (e) {
      print('WebSocketChannelException: $e');
      rethrow;
    } catch (e) {
      print("Exception: ${e.toString()}");
      rethrow;
    }
  }

  void _listenToStream() {
    channel.stream.listen(
      (message) {
        print("Received message chunk for system ${system.id}: $message");
        _messageBuffer += message; // Append received chunk to buffer

        // Process the buffer
        _processBuffer();
      },
      onError: (error) {
        print("Error on WebSocket stream for system ${system.id}: $error");
      },
      onDone: () {
        // Automatically reconnect on close
        print(
            "WebSocket connection closed for system ${system.id}. Reconnecting...");
        connectWebSocket();
      },
      cancelOnError: true,
    );
  }

  void _processBuffer() {
    while (_messageBuffer.isNotEmpty) {
      try {
        // Try to decode the buffer content as JSON
        var decodedMessage = jsonDecode(_messageBuffer);

        // If JSON decoding is successful, clear the buffer and process the message
        print(
            "Received complete message for system ${system.id}: $decodedMessage");

        _messageBuffer = ''; // Clear the buffer after processing the message

        Map<String, dynamic> mapMessage = parseMessageToMap(decodedMessage);
        print(
            "+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=");
        print(mapMessage);
        print(
            "+=+=+=+=+=+=+=++=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=");

        _parseFromMap(mapMessage);
        // Now you can process the complete message
      } catch (e) {
        // If decoding fails, it means the message is still incomplete or malformed
        if (e is FormatException) {
          // Wait for more chunks before attempting to parse again
          print(
              "Incomplete message, buffering... Current buffer length: ${_messageBuffer.length}");
          break;
        } else {
          print("Error decoding message for system ${system.id}: $e");
          _messageBuffer = ''; // Clear the buffer to avoid future errors
          break;
        }
      }
    }
  }

  void parseAndDisplayData(dynamic message) {
    // Check if the message contains the expected data structure
    if (message != null && message['Data'] != null) {
      // Loop through the data entries
      for (var dataEntry in message['Data']) {
        String timestamp = dataEntry['Timestamp']?.toString() ?? 'N/A';
        print('Timestamp: $timestamp');
        print('Components:');

        // Loop through each component in the data entry
        for (var component in dataEntry['Components']) {
          String componentName =
              component['Component']?.toString() ?? 'Unknown';
          dynamic componentData = component['Data'];

          // Check if the Data is a string (i.e., JSON encoded)
          if (componentData is String) {
            // Decode the string data into JSON
            componentData = jsonDecode(componentData);
          }

          print('  Component: $componentName');

          // Parse the data of each component
          for (var data in componentData) {
            String stateOfCharge = (data['stateOfCharge'] != null)
                ? '${(data['stateOfCharge'] * 100).toString()}%'
                : 'N/A';
            String busPower = data['busPower']?.toString() ?? 'N/A';
            String pvVoltage = data['pvVoltage']?.toString() ?? 'N/A';
            String pvCurrent = data['pvCurrent']?.toString() ?? 'N/A';

            print('    State of Charge: $stateOfCharge');
            print('    Bus Power: $busPower W');
            print('    PV Voltage: $pvVoltage V');
            print('    PV Current: $pvCurrent A');
          }
        }
        print('\n'); // Newline for separation between entries
      }
    } else {
      print('Invalid message format');
    }
  }

  Map<String, dynamic> parseMessageToMap(dynamic message) {
    Map<String, dynamic> result = {};

    // Check if the message contains the expected data structure
    if (message != null && message['Data'] != null) {
      // Initialize a list to hold component data for each timestamp
      List<Map<String, dynamic>> componentsData = [];

      // Loop through the data entries
      for (var dataEntry in message['Data']) {
        String timestamp = dataEntry['Timestamp']?.toString() ?? 'N/A';
        result['Timestamp'] = timestamp; // Set the timestamp in the result map

        // Loop through each component in the data entry
        for (var component in dataEntry['Components']) {
          String componentName =
              component['Component']?.toString() ?? 'Unknown';
          dynamic componentData = component['Data'];

          // Decode the string data into JSON if it's encoded
          if (componentData is String) {
            componentData = jsonDecode(componentData);
          }

          // Map to store data for this component
          Map<String, dynamic> componentMap = {
            'Component': componentName,
            'stateOfCharge': 'N/A',
            'busPower': 'N/A',
            'pvVoltage': 'N/A',
            'pvCurrent': 'N/A',
          };

          // Parse the data of each component and store in componentMap
          for (var data in componentData) {
            // Check for stateOfCharge
            if (data.containsKey('stateOfCharge')) {
              componentMap['stateOfCharge'] =
                  ((data['stateOfCharge'] * 100).toString());
            }
            // Check for busPower
            if (data.containsKey('busPower')) {
              componentMap['busPower'] = data['busPower']?.toString() ?? 'N/A';
            }
            // Check for pvVoltage
            if (data.containsKey('pvVoltage')) {
              componentMap['pvVoltage'] =
                  data['pvVoltage']?.toString() ?? 'N/A';
            }
            // Check for pvCurrent
            if (data.containsKey('pvCurrent')) {
              componentMap['pvCurrent'] =
                  data['pvCurrent']?.toString() ?? 'N/A';
            }
          }

          // Add the component's data to the list
          componentsData.add(componentMap);
        }

        // Store the list of components in the result map
        result['Components'] = componentsData;
      }
    } else {
      // Handle invalid message format
      result['Error'] = 'Invalid message format';
    }

    return result; // Return the structured map
  }

  void _parseFromMap(Map<String, dynamic> map) {
    try {
      String timestamp = map['Timestamp'];
      print(timestamp);
      List<Map<String, dynamic>> listofComponents = map['Components'];
      listofComponents.forEach((component) {
        List<String> componentString = component['Component']!.split('_');
        switch (componentString[0]) {
          case 'Inverter':
            {
              _updateInverter(componentString[1], component['busPower']);
              print(
                  "Inverter ${componentString[1]} with bus power: ${component['busPower']}");
              notifyProvider();
            }
          case 'Battery':
            {
              _updateBattery(
                  componentString[1],
                  component['stateOfCharge'].toString().trim(),
                  component['busPower']);
              print(
                  "Battery ${componentString[1]} with bus power: ${component['busPower']} and state of charge ${component['stateOfCharge'].toString().trim()}%");
              notifyProvider();
            }
          case 'Solar':
            {
              _updateSolar(componentString[1], component['pvVoltage'],
                  component['pvCurrent'], component['busPower']);
              print(
                  "Solar ${componentString[1]} with bus power: ${component['busPower']} and pvVolt ${component['pvVoltage']} V and \n pvCurrent ${component['pvCurrent']} A");
              notifyProvider();
            }
        }
      });
    } catch (e) {
      print("Error parsing and updating values: ${e.toString()}");
    }
  }

  void _updateBattery(String batteryId, String newLevel, String newBusPower) {
    // Parse battery-related data
    // String newLevel = ((dataList['stateOfCharge']) ?? 'N/A');
    // String newBusPower = ((dataList['busPower'])?.toString() ?? 'N/A');
    system.updateBattery(batteryId, newLevel, newBusPower);
    print("Battery $batteryId level updated to: $newLevel");
  }

  void _updateSolar(String solarId, String newVoltage, String newCurrent,
      String newBusPower) {
    // Parse solar-related data
    // String newVoltage = (dataList['pvVoltage']?.toString() ?? 'N/A');
    // String newCurrent = (dataList['pvCurrent']?.toString() ?? 'N/A');
    // String newBusPower = ((dataList['busPower'])?.toString() ?? 'N/A');
    system.updateSolar(solarId, newVoltage, newCurrent, newBusPower);
    print("Solar $solarId voltage updated to: $newVoltage");
  }

  void _updateInverter(String inverterId, String newBusPower) {
    // Parse inverter-related data
    // String newBusPower = (dataList['busPower']?.toString() ?? 'N/A');
    system.updateInverter(newBusPower);
    print("Inverter power updated to: $newBusPower");
  }

  void closeConnection() {
    channel.sink.close();
    print("WebSocket connection closed for system ${system.id}.");
  }
}
