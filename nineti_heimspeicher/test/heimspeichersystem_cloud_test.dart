import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nineti_heimspeicher/src/heimspeichersystem_cloud.dart';
import 'package:nineti_heimspeicher/src/model/cloud_provisioning/cloud_provisioning.dart';
import 'package:rxdart/rxdart.dart';

class MockSender extends Mock {
  MockSender();

  void send(CloudProvisioningMessage message);
}

void main() {
  group('HeimspeicherSystemCloud', () {
    late PublishSubject<CloudProvisioningUpdate> receiver;
    late MockSender sender;
    late bool recieverCanceled;

    late HeimspeichersystemCloud cloud;

    setUp(() {
      sender = MockSender();
      recieverCanceled = false;
      receiver = PublishSubject<CloudProvisioningUpdate>(
        onCancel: () => recieverCanceled = true,
      );

      cloud = HeimspeichersystemCloud(
        receiveStream: receiver.stream,
        send: sender.send,
      );
    });

    test('can be instanciated', () {
      expect(
        cloud,
        isA<HeimspeichersystemCloud>(),
      );
    });

    group('ProvisionDevice', () {
      void verifyProvisioningDataSend(Uint8List data) {
        verify(
          () => sender.send(ProvisionDeviceWithCloudData(provisionData: data)),
        );
      }

      test('sends a ProvisionDeviceWithCloudData message with content', () {
        final data = Uint8List.fromList([1, 2, 3, 4]);
        cloud.provisiongDevice(data);

        verifyProvisioningDataSend(data);
      });
    });

    group('status', () {
      test('emits provisioningStatus updates from the receiveStream', () {
        expect(
          // Skip initial value
          cloud.status.skip(1),
          emitsInOrder([
            CloudProvisioningStatus.provisioning,
            CloudProvisioningStatus.provisioned,
            CloudProvisioningStatus.unprovisioned,
          ]),
        );

        receiver.add(CloudProvisioningStatus.provisioning);
        receiver.add(CloudProvisioningStatus.provisioned);
        receiver.add(CloudProvisioningStatus.unprovisioned);
      });
    });

    group('Close', () {
      test('cancels receiver Subscription', () async {
        await cloud.close();

        expect(
          recieverCanceled,
          true,
        );
      });
    });
  });
}
