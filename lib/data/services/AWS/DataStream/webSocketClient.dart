import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:web_socket_channel/web_socket_channel.dart';

Future<String?> websocket() async {
  final uri = Uri.parse(
      'wss://ojil6u53db.execute-api.eu-central-1.amazonaws.com/production/?tableName=EnergyData_v3');
  final channel = WebSocketChannel.connect(uri);

  final payload = jsonEncode({
    'action': 'sendMessage',
    'body': jsonEncode({'tableName': 'EnergyData_v3'}),
  });

  try {
    await channel.ready;
    print("Connection established");
    channel.sink.add(payload);
    print("Payload sent: $payload");

    // Completer to wait for the data response
    final completer = Completer<String?>();

    // Listen for incoming messages
    channel.stream.listen(
      (onData) {
        print("Received data: ${onData.toString()}");
        if (!completer.isCompleted) {
          completer.complete(onData.toString());
        }
      },
      onError: (error) {
        print("Error received: $error");
        if (!completer.isCompleted) {
          completer.completeError(error);
        }
      },
      onDone: () {
        print("WebSocket connection closed.");
        if (!completer.isCompleted) {
          completer.complete();
        }
      },
    );

    return await completer.future;
  } on SocketException catch (e) {
    print("SocketException: ${e.toString()}");
    return null;
  } on WebSocketChannelException catch (e) {
    print('WebSocketChannelException: $e');
    return null;
  } catch (e) {
    print("Exception: ${e.toString()}");
    return null;
  }
}
