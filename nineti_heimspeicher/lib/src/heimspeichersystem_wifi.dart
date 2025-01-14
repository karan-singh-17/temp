import 'dart:async';

import 'package:nineti_heimspeicher/nineti_heimspeicher.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

class HeimspeichersystemWiFi {
  final Duration _scanTimeout;
  final Logger _log = Logger();

  late final void Function(WiFiMessage) _send;

  final Stream<WiFiUpdate> _receiveStream;

  final BehaviorSubject<WiFiStatus> _status =
      BehaviorSubject<WiFiStatus>.seeded(WiFiStatus.unknown);

  final PublishSubject<List<WiFiScanEntry>> _scanResults =
      PublishSubject<List<WiFiScanEntry>>();

  late final StreamSubscription _receivedPackageSubscription;

  HeimspeichersystemWiFi({
    required Stream<WiFiUpdate> receiveStream,
    required void Function(WiFiMessage) send,
    Duration? scanTimeout,
  })  : _receiveStream = receiveStream,
        _send = send,
        _scanTimeout = scanTimeout ?? const Duration(seconds: 10) {
    _receivedPackageSubscription = _receiveStream.listen(_onReceive);
  }

  ValueStream<WiFiStatus> get status => _status.stream;

  Future<List<WiFiScanEntry>> scan() {
    _log.i('Scanning for WiFi networks');
    _send(ScanForWiFi());

    return _scanResults.first.timeout(_scanTimeout);
  }

  Future<void> connect(WiFiConnectParameter parameter) async {
    _log.i(
      "Connecting to WiFi with SSID: ${parameter.ssid}; has password: ${parameter.password == null ? false : parameter.password!.isNotEmpty}",
    );

    _send(parameter);
  }

  void disconnect() {
    _log.i("Requesting WiFi Disconnect");
    return _send(DisconnectWiFi());
  }

  Future<void> close() async {
    await _receivedPackageSubscription.cancel();
    _log.i("closed");
  }

  void _onReceive(WiFiUpdate update) {
    _log.d("Parsed package: $update");
    switch (update) {
      case WiFiStatus():
        _onWiFiStatus(update);
        break;
      case WifiScanResults():
        _onWiFiScanResults(update);
        break;
    }
  }

  void _onWiFiScanResults(WifiScanResults update) {
    _scanResults.add(update.entries);
  }

  void _onWiFiStatus(WiFiStatus currentStatus) {
    _status.add(currentStatus);
  }
}
