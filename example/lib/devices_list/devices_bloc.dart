import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:blemulator_example/model/ble_device.dart';
import 'package:blemulator_example/repository/device_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ble_lib_ios_15/flutter_ble_lib.dart';
import 'package:blemulator/blemulator.dart';
import 'package:blemulator_example/example_peripherals/sensor_tag.dart';

class DevicesBloc extends Cubit<List<BleDevice>> {
  late StreamSubscription<ScanResult> _scanSubscription;
  late StreamSubscription<BleDevice> _devicePickerSubscription;

  final DeviceRepository _deviceRepository;
  final BleManager _bleManager;

  DevicesBloc(this._deviceRepository, this._bleManager) : super([]) {
    Blemulator().addSimulatedPeripheral(SensorTag());
    Blemulator().addSimulatedPeripheral(SensorTag(id: 'different id'));
    Blemulator()
        .addSimulatedPeripheral(SensorTag(id: 'yet another different id'));
    Blemulator().simulate();

    init();
  }

  void select(BleDevice bleDevice) {
    _deviceRepository.pickDevice(bleDevice);
  }

  void dispose() {
    Fimber.d('cancel _devicePickerSubscription');
    _devicePickerSubscription.cancel();
    _scanSubscription.cancel();
  }

  void init() {
    Fimber.d('Init devices bloc');
    emit([]);
    _bleManager
        .createClient(
            restoreStateIdentifier: 'example-restore-state-identifier',
            restoreStateAction: (peripherals) {
              for (var peripheral in peripherals) {
                Fimber.d('Restored peripheral: ${peripheral.name}');
              }
            })
        .then((_) => startScan())
        .catchError((e) => Fimber.d('Couldn\'t create BLE client', ex: e));
  }

  void startScan() {
    Fimber.d('Ble client created');
    _scanSubscription =
        _bleManager.startPeripheralScan().listen((ScanResult scanResult) {
      var bleDevice = BleDevice.notConnected(scanResult.peripheral.name,
          scanResult.peripheral.identifier, scanResult.peripheral);
      if (scanResult.advertisementData.localName != null &&
          !state.contains(bleDevice)) {
        Fimber.d('found new device ${scanResult.advertisementData.localName}'
            ' ${scanResult.peripheral.identifier}');
        emit(List<BleDevice>.from(state)..add(bleDevice));
      }
    });
  }

  Future<void> refresh() async {
    await _scanSubscription.cancel();
    await _bleManager.stopPeripheralScan();
    emit([]);
    startScan();
  }
}
