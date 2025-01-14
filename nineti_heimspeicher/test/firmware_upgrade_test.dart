import 'package:flutter_test/flutter_test.dart';
import 'package:nineti_heimspeicher/nineti_heimspeicher.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  group('FirmwareUpgrade', () {
    test('dummy', () {
      expect(1, 1);
    });

    final String uri = 'uri';
    late FirmwareUpgrade raucUpdate;
    late PublishSubject<DeviceAdministrationUpdate> deviceAdminUpdate;
    late BehaviorSubject<DeviceState> deviceState;
    late PublishSubject<DeviceAdministrationMessage> sendMessages;
    late void Function(DeviceAdministrationMessage) send;

    void setUpBTCommunication() {
      deviceAdminUpdate = PublishSubject<DeviceAdministrationUpdate>();
      deviceState = BehaviorSubject<DeviceState>.seeded(
        DeviceState.unknown,
      );

      sendMessages = PublishSubject<DeviceAdministrationMessage>();
      send = (deviceAdministrationMessage) {
        sendMessages.add(deviceAdministrationMessage);
      };
    }

    void setOperationalState(DeviceState operation) {
      deviceState.add(
        DeviceState.idle,
      );
    }

    setUp(() async {
      setUpBTCommunication();

      raucUpdate = FirmwareUpgrade(
        uri: uri,
        deviceState: deviceState.stream,
        receiveStream: deviceAdminUpdate.stream,
        send: send,
      );

      setOperationalState(DeviceState.idle);
    });

    test('can be instanciated', () {
      expect(
        raucUpdate,
        isA<FirmwareUpgrade>(),
      );
    });

    group('startFirmwareUpdate()', () {
      test('Requests Start of FirmwareUpdate', () async {
        expect(sendMessages.stream, emits(InstallBundle(uri: uri)));
        await raucUpdate.startFirmwareUpdate();

        // give Stream time to process
        await Future.delayed(Duration(milliseconds: 10));
      });

      test('throws StateError when update is requested twice', () async {
        await raucUpdate.startFirmwareUpdate();

        expect(
          () async => await raucUpdate.startFirmwareUpdate(),
          throwsStateError,
        );
      });

      test(
          'throws StateError when update is requested in operational State "unknown"',
          () async {
        deviceState.add(DeviceState.unknown);

        expect(
          () async => await raucUpdate.startFirmwareUpdate(),
          throwsStateError,
        );
      });
    });

    group('reset()', () {
      test('creates another RaucUpdate instance with same uri that can update',
          () async {
        await raucUpdate.startFirmwareUpdate();

        final newRaucUpdate = raucUpdate.reset();

        setOperationalState(DeviceState.idle);
        // Give object time to process new operational state
        await Future.delayed(Duration(milliseconds: 10));

        expect(
          newRaucUpdate.uri,
          raucUpdate.uri,
        );

        expect(
          sendMessages.stream,
          emits(InstallBundle(uri: newRaucUpdate.uri)),
        );

        expect(
          () async => await newRaucUpdate.startFirmwareUpdate(),
          returnsNormally,
        );
      });
    });

    group('update process', () {
      test('receives progressupdate State', () {
        expect(
          // Skip 'initial' state
          raucUpdate.state.skip(1),
          emits(
            FirmwareUpgradeState(
              progress: 0.5,
              status: 'installing',
              errorMessage: null,
            ),
          ),
        );

        final progressUpdate =
            ProgressUpdate(progress: 0.5, status: 'installing');

        deviceAdminUpdate.add(progressUpdate);
      });

      test('receives error State', () {
        expect(
          // Skip 'initial' state
          raucUpdate.state.skip(1),
          emits(
            FirmwareUpgradeState(
              progress: 0,
              status: 'idle',
              errorMessage: 'error',
            ),
          ),
        );

        final update = DeviceAdministrationError(message: 'error');

        deviceAdminUpdate.add(update);
      });

      test('receives completed state and closes the stream', () {
        expect(
          raucUpdate.state.skip(2),
          emitsInOrder([
            FirmwareUpgradeState(
              progress: 0,
              status: 'UNKNOWN',
              resultCode: 5,
            ),
            // emitsDone,
          ]),
        );

        final update = ProgressUpdate(
          progress: 0,
          status: 'UNKNOWN',
          resultCode: 5,
        );

        deviceAdminUpdate.add(update);
      });
    });
  });
}
