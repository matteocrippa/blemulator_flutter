part of internal;

mixin PeripheralScanningMixing on SimulationManagerBase {
  final List<StreamSubscription> _scanSubscriptions = [];

  Future<void> _startDeviceScan() async {
    for (var peripheral in _peripherals.values) {
      _scanSubscriptions.add(
        peripheral.onScan(allowDuplicates: true).listen((scanResult) {
          _bridge.publishScanResult(scanResult);
        }),
      );
    }
  }

  Future<void> _stopDeviceScan() async {
    for (var subscription in _scanSubscriptions) {
      await subscription.cancel();
    }
    _scanSubscriptions.clear();
  }
}
