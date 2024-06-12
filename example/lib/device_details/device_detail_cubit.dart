import 'package:blemulator_example/model/ble_device.dart';
import 'package:blemulator_example/model/debug_log.dart';
import 'package:blemulator_example/test_scenarios/test_scenarios.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_ble_lib_ios_15/flutter_ble_lib.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeviceDetailsState {
  final BleDevice? device;
  final List<DebugLog> logs;

  DeviceDetailsState({
    required this.device,
    required this.logs,
  });

  DeviceDetailsState copyWith({
    BleDevice? device,
    PeripheralConnectionState? connectionState,
    List<DebugLog>? logs,
  }) {
    return DeviceDetailsState(
      device: device ?? this.device,
      logs: logs ?? this.logs,
    );
  }
}

class DeviceDetailsCubit extends Cubit<DeviceDetailsState> {
  final BleManager _bleManager;

  late final Logger log;
  late final Logger logError;

  DeviceDetailsCubit(this._bleManager)
      : super(DeviceDetailsState(device: null, logs: []));

  Future<void> disconnect() async {
    _clearLogs();
    await disconnectManual();
    emit(DeviceDetailsState(device: null, logs: []));
  }

  Future<void> disconnectManual() async {
    final device = state.device;
    if (device != null && await device.peripheral.isConnected()) {
      _log('DISCONNECTING...');
      await device.peripheral.disconnectOrCancelConnection();
      _log('Disconnected!');
      emit(state.copyWith(
          connectionState: PeripheralConnectionState.disconnected));
    }
  }

  void readRssi() async {
    _clearLogs();
    var bleDevice = state.device;
    if (bleDevice != null) {
      await PeripheralTestOperations(
              _bleManager, bleDevice.peripheral, _log, _logError)
          .testReadingRssi();
    }
  }

  void requestMtu() async {
    _clearLogs();
    var state = this.state;
    var bleDevice = state.device;
    if (bleDevice != null) {
      await PeripheralTestOperations(
              _bleManager, bleDevice.peripheral, _log, _logError)
          .testRequestingMtu();
    }
  }

  void discovery() async {
    _clearLogs();
    var state = this.state;
    var bleDevice = state.device;
    if (bleDevice != null) {
      await PeripheralTestOperations(
              _bleManager, bleDevice.peripheral, _log, _logError)
          .discovery();
    }
  }

  void fetchConnectedDevices() async {
    _clearLogs();
    await PeripheralTestOperations(
            _bleManager, state.device!.peripheral, log, logError)
        .fetchConnectedDevice();
  }

  void fetchKnownDevices() async {
    _clearLogs();
    if (state.device != null) {
      await PeripheralTestOperations(
              _bleManager, state.device!.peripheral, log, logError)
          .fetchKnownDevice();
    }
  }

  void connectToDevice(BleDevice bleDevice) async {
    _clearLogs();
    emit(state.copyWith(device: bleDevice));
    await connect();
  }

  void readCharacteristicForPeripheral() async {
    _clearLogs();
    var state = this.state;
    var bleDevice = state.device;
    if (bleDevice != null) {
      await PeripheralTestOperations(
              _bleManager, bleDevice.peripheral, _log, _logError)
          .readCharacteristicForPeripheral();
    }
  }

  void readCharacteristicForService() async {
    _clearLogs();
    var state = this.state;
    var bleDevice = state.device;
    if (bleDevice != null) {
      await PeripheralTestOperations(
              _bleManager, bleDevice.peripheral, _log, _logError)
          .readCharacteristicForService();
    }
  }

  void readCharacteristicDirectly() async {
    _clearLogs();
    var state = this.state;
    var bleDevice = state.device;
    if (bleDevice != null) {
      await PeripheralTestOperations(
              _bleManager, bleDevice.peripheral, _log, _logError)
          .readCharacteristic();
    }
  }

  void writeCharacteristicForPeripheral() async {
    _clearLogs();
    var state = this.state;
    var bleDevice = state.device;
    if (bleDevice != null) {
      await PeripheralTestOperations(
              _bleManager, bleDevice.peripheral, _log, _logError)
          .writeCharacteristicForPeripheral();
    }
  }

  void writeCharacteristicForService() async {
    _clearLogs();
    var state = this.state;
    var bleDevice = state.device;
    if (bleDevice != null) {
      await PeripheralTestOperations(
              _bleManager, bleDevice.peripheral, _log, _logError)
          .writeCharacteristicForService();
    }
  }

  void writeCharacteristicDirectly() async {
    _clearLogs();
    var state = this.state;
    var bleDevice = state.device;
    if (bleDevice != null) {
      await PeripheralTestOperations(
              _bleManager, bleDevice.peripheral, _log, _logError)
          .writeCharacteristic();
    }
  }

  void monitorCharacteristicForPeripheral() async {
    _clearLogs();
    var state = this.state;
    var bleDevice = state.device;
    if (bleDevice != null) {
      await PeripheralTestOperations(
              _bleManager, bleDevice.peripheral, _log, _logError)
          .monitorCharacteristicForPeripheral();
    }
  }

  void monitorCharacteristicForService() async {
    _clearLogs();
    var state = this.state;
    var bleDevice = state.device;
    if (bleDevice != null) {
      await PeripheralTestOperations(
              _bleManager, bleDevice.peripheral, _log, _logError)
          .monitorCharacteristicForService();
    }
  }

  void monitorCharacteristicDirectly() async {
    _clearLogs();
    var state = this.state;
    var bleDevice = state.device;
    if (bleDevice != null) {
      await PeripheralTestOperations(
              _bleManager, bleDevice.peripheral, _log, _logError)
          .monitorCharacteristic();
    }
  }

  void disableBluetooth() async {
    _clearLogs();
    await _bleManager.disableRadio();
    _log('Bluetooth disabled');
  }

  void enableBluetooth() async {
    _clearLogs();
    await _bleManager.enableRadio();
    _log('Bluetooth enabled');
  }

  void fetchBluetoothState() async {
    _clearLogs();
    var state = await _bleManager.bluetoothState();
    _log('Bluetooth state: $state');
  }

  Future<void> connect() async {
    _clearLogs();
    final bleDevice = state.device;
    if (bleDevice != null) {
      await _bleManager.stopPeripheralScan();

      var peripheral = bleDevice.peripheral;

      peripheral
          .observeConnectionState(
        emitCurrentValue: true,
        completeOnDisconnect: true,
      )
          .listen((connectionState) {
        _log('Observed new connection state: \n$connectionState');
        emit(state.copyWith(connectionState: connectionState));
      });

      _log('Connecting to ${peripheral.name}');
      await peripheral.connect();
      _log('Connected!');
      emit(
          state.copyWith(connectionState: PeripheralConnectionState.connected));
    }
  }

  void startAutoTest() async {
    _clearLogs();
    final bleDevice = state.device;
    if (bleDevice != null) {
      Fimber.d('got bleDevice: $bleDevice');
      Fimber.d('The device is connected: ${bleDevice.isConnected}');
      if (bleDevice.isConnected == false) {
        await connect();
      }
    }
  }

  void _clearLogs() {
    final state = this.state;
    emit(state.copyWith(logs: null));
  }

  void _log(String text) {
    var now = DateTime.now();
    var log = DebugLog(
        '${now.hour}:${now.minute}:${now.second}.${now.millisecond}', text);
    Fimber.d(text);
    var state = this.state;
    var logs = List<DebugLog>.from(state.logs)..insert(0, log);
    emit(state.copyWith(logs: logs));
  }

  void _logError(String text) {
    var now = DateTime.now();
    var log = DebugLog(
        '${now.hour}:${now.minute}:${now.second}.${now.millisecond}',
        'ERROR: ${text.toUpperCase()}');
    Fimber.e(text);
    var state = this.state;
    var logs = List<DebugLog>.from(state.logs)..insert(0, log);
    emit(state.copyWith(logs: logs));
  }
}
