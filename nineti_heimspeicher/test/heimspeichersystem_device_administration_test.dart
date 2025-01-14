import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nineti_heimspeicher/src/heimspeichersystem_device_administration.dart';
import 'package:nineti_heimspeicher/src/model/model.dart';
import 'package:rxdart/rxdart.dart';

class MockSender extends Mock {
  MockSender();

  void send(DeviceAdministrationMessage message);
}

void main() {
  group('HeimspeicherSystemDeviceAdministration', () {
    late PublishSubject<DeviceAdministrationUpdate> receiver;
    late MockSender sender;

    late HeimspeichersystemDeviceAdministration sut;

    setUp(() {
      sender = MockSender();
      receiver = PublishSubject<DeviceAdministrationUpdate>();

      sut = HeimspeichersystemDeviceAdministration(
        receiveStream: receiver.stream,
        send: sender.send,
      );
    });

    test('can be instanciated', () {
      expect(
        sut,
        isA<HeimspeichersystemDeviceAdministration>(),
      );
    });

    group('DeviceState', () {
      test('is initially "unknown"', () {
        expect(
          sut.deviceState,
          emits(DeviceState.unknown),
        );
      });

      test('emits DeviceStateUpdates from the receiver', () {
        final states = [
          DeviceState.idle,
          DeviceState.unknown,
          DeviceState.installing,
        ];

        expect(
          sut.deviceState.skip(1),
          emitsInOrder(states),
        );

        receiver.addStream(Stream.fromIterable(states));
      });
    });

    group('CreateFirmwareUpgrade()', () {
      test('returns a FirmwareUpgrade with the bundle uri', () {
        final uri = 'http://example.com/bundle';
        final upgrade = sut.createFirmwareUgrade(uri);

        expect(
          upgrade.uri,
          uri,
        );
      });
    });

    group('GetSlotStates()', () {
      final slotStates = [
        FirmwareSlotInformation(
            hash: 'hash1', version: 'v1', status: SlotStatus.inactive),
        FirmwareSlotInformation(
            hash: 'hash2', version: 'v1', status: SlotStatus.active),
        FirmwareSlotInformation(
            hash: 'hash3', version: 'v1', status: SlotStatus.inactive),
      ];

      void verifySlotStatesRequested() {
        verify(() => sender.send(GetSlotStates()));
      }

      test('returns the slotStates from the receiver', () async {
        Future.delayed(Duration(milliseconds: 10), () {
          receiver.add(SlotStates(slots: slotStates));
        });

        expect(await sut.getSlotStates(), slotStates);
      });

      test('throws a TimeoutException if the answer takes too long', () async {
        expect(
          () async => await sut.getSlotStates(timeout: Duration.zero),
          throwsA(isA<TimeoutException>()),
        );
      });

      test('sends a SlotStates request', () async {
        try {
          await sut.getSlotStates(timeout: Duration.zero);
        } catch (_) {}

        verifySlotStatesRequested();
      });
    });

    group('RebootDevice', () {
      void verifySendsARebootDeviceMessage() {
        verify(() => sender.send(RebootDevice()));
      }

      test('sends a reboot message', () {
        sut.rebootDevice();
        verifySendsARebootDeviceMessage();
      });
    });
  });
}
