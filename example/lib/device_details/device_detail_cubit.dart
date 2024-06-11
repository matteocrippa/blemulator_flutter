import 'package:blemulator_example/device_details/device_details_bloc.dart';
import 'package:blemulator_example/model/ble_device.dart';
import 'package:blemulator_example/repository/device_repository.dart';
import 'package:blemulator_example/test_scenarios/test_scenarios.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_ble_lib_ios_15/flutter_ble_lib.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeviceDetailsState {
  final BleDevice? device;
  final PeripheralConnectionState connectionState;
  final List<DebugLog> logs;

  DeviceDetailsState({
    required this.device,
    required this.connectionState,
    required this.logs,
  });

  DeviceDetailsState copyWith({
    BleDevice? device,
    PeripheralConnectionState? connectionState,
    List<DebugLog>? logs,
  }) {
    return DeviceDetailsState(
      device: device ?? this.device,
      connectionState: connectionState ?? this.connectionState,
      logs: logs ?? this.logs,
    );
  }

  @override
  List<Object?> get props => [device, connectionState, logs];
}

class DeviceDetailsError {
  final String message;

  DeviceDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}

class DeviceDetailsCubit extends Cubit<DeviceDetailsState> {
  final BleManager _bleManager;
  final DeviceRepository _deviceRepository;

  late final Logger log;
  late final Logger logError;

  DeviceDetailsCubit(this._deviceRepository, this._bleManager)
      : super(DeviceDetailsState(
            connectionState: PeripheralConnectionState.disconnected,
            device: null,
            logs: [])) {
    var device = _deviceRepository.pickedDevice.valueOrNull;
    var connectionState = device?.isConnected ?? false
        ? PeripheralConnectionState.connected
        : PeripheralConnectionState.disconnected;
    emit(DeviceDetailsState(
        device: device, connectionState: connectionState, logs: []));
  }

  void init() {
    _bleManager.stopPeripheralScan();
  }

  Future<void> disconnect() async {
    _clearLogs();
    await disconnectManual();
    _deviceRepository.pickDevice(null);
    emit(DeviceDetailsState(
        connectionState: PeripheralConnectionState.disconnected,
        device: null,
        logs: []));
  }

  Future<void> disconnectManual() async {
    var state = this.state;
    var device = state.device;
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
    var state = this.state;
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
    // _log('Connected devices: ${connectedDevices.length}');
    // for (var device in connectedDevices) {
    //   _log('Device: ${device.name}');
    // }
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
    _deviceRepository.pickDevice(bleDevice);
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
    var state = this.state;
    var bleDevice = state.device;
    if (bleDevice != null) {
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
    var state = this.state;
    var bleDevice = state.device;
    if (bleDevice != null) {
      Fimber.d('got bleDevice: $bleDevice');
      Fimber.d('The device is connected: ${bleDevice.isConnected}');
      if (bleDevice.isConnected == false) {
        await connect();
      }
    }
  }

  void _clearLogs() {
    var state = this.state;
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
