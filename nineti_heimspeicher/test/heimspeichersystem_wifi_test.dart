import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nineti_heimspeicher/src/heimspeichersystem_wifi.dart';
import 'package:nineti_heimspeicher/src/model/model.dart';
import 'package:rxdart/rxdart.dart';

class MockSender extends Mock {
  MockSender();

  void send(WiFiMessage message);
}

void main() {
  group('HeimspeicherSystemWiFi', () {
    late bool receiverStreamCanceled = false;
    late PublishSubject<WiFiUpdate> receiver;
    late MockSender sender;

    late HeimspeichersystemWiFi sut;

    setUp(() {
      sender = MockSender();
      receiverStreamCanceled = false;
      receiver = PublishSubject<WiFiUpdate>(
          onCancel: () => receiverStreamCanceled = true);

      sut = HeimspeichersystemWiFi(
        receiveStream: receiver.stream,
        send: sender.send,
        scanTimeout: const Duration(milliseconds: 50),
      );
    });

    test('can be instanciated', () {
      expect(
        sut,
        isA<HeimspeichersystemWiFi>(),
      );
    });

    group('Status', () {
      test('is initially "unknown"', () {
        expect(
          sut.status,
          emits(WiFiStatus.unknown),
        );
      });

      test('emits Status updates from the receier', () {
        expect(
            // Skip initial value
            sut.status.skip(1),
            emitsInOrder([
              WiFiStatus.connecting,
              WiFiStatus.connected,
              WiFiStatus.disconnected,
            ]));

        receiver.add(WiFiStatus.connecting);
        receiver.add(WiFiStatus.connected);
        receiver.add(WiFiStatus.disconnected);
      });
    });

    group('Scan()', () {
      final scanEntries = [
        WiFiScanEntry(
            ssid: '1', signalStrength: 0, bssid: [], needsPassword: true),
        WiFiScanEntry(
            ssid: '2',
            signalStrength: 5,
            bssid: [1, 2, 3],
            needsPassword: false),
        WiFiScanEntry(
            ssid: '3',
            signalStrength: -15,
            bssid: [4, 5, 6],
            needsPassword: true),
      ];

      test('returns the scanResult from the receiver Stream', () async {
        Future.delayed(Duration(milliseconds: 10), () {
          receiver.add(WifiScanResults(entries: scanEntries));
        });

        expect(
          await sut.scan(),
          scanEntries,
        );
      });

      test('throws a TimeoutException when the answer takes too long',
          () async {
        expect(
          () async => await sut.scan(),
          throwsA(isA<TimeoutException>()),
        );
      });
    });

    group('Connect()', () {
      final connectParameter = WiFiConnectParameter(
        ssid: 'ssid',
        password: 'password',
      );

      void verifyConnectParameterSend(WiFiConnectParameter parameter) {
        verify(() => sender.send(parameter));
      }

      test('sends the connection Data', () async {
        await sut.connect(connectParameter);
        verifyConnectParameterSend(connectParameter);
      });
    });

    group('Disconnect()', () {
      void verifyDisconnectSend() {
        verify(() => sender.send(DisconnectWiFi()));
      }

      test('sends a disconnect request', () {
        sut.disconnect();
        verifyDisconnectSend();
      });
    });

    group('Close()', () {
      test('cancels the receiver StreamSubscription', () async {
        await sut.close();
        expect(receiverStreamCanceled, true);
      });
    });
  });
}
