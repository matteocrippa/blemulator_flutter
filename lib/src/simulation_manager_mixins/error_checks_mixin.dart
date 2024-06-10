part of internal;

mixin ErrorChecksMixin on SimulationManagerBase {
  Future<void> _checkPeripheral(String identifier) async {
    if (_peripherals[identifier] == null) {
      return Future.error(
        SimulatedBleError(
          BleErrorCode.DeviceNotFound,
          'Peripheral $identifier not found',
        ),
      );
    }
  }

  Future<void> _errorIfConnected(String identifier) async {
    await _checkPeripheral(identifier);
    if (_peripherals[identifier]!.isConnected()) {
      return Future.error(
        SimulatedBleError(
          BleErrorCode.DeviceAlreadyConnected,
          'Peripheral $identifier is already connected',
        ),
      );
    }
  }

  Future<void> _errorIfNotConnected(String identifier) async {
    await _checkPeripheral(identifier);
    if (!_peripherals[identifier]!.isConnected()) {
      return Future.error(
        SimulatedBleError(
          BleErrorCode.DeviceNotConnected,
          'Peripheral $identifier is not connected',
        ),
      );
    }
  }

  Future<void> _errorIfDisconnected(String identifier) async {
    await _checkPeripheral(identifier);
    if (!_peripherals[identifier]!.isConnected()) {
      return Future.error(
        SimulatedBleError(
          BleErrorCode.DeviceDisconnected,
          'Peripheral $identifier has disconnected',
        ),
      );
    }
  }

  Future<void> _errorIfPeripheralNull(SimulatedPeripheral peripheral) async {}

  Future<void> _errorIfDiscoveryNotDone(SimulatedPeripheral peripheral) async {
    if (!peripheral.discoveryDone) {
      return Future.error(
        SimulatedBleError(
          BleErrorCode.CharacteristicsNotDiscovered,
          'Discovery was not done on peripheral ${peripheral.id}',
        ),
      );
    }
  }

  Future<void> _errorIfUnknown(String identifier) async {
    if (_peripherals[identifier] == null) {
      return Future.error(
        SimulatedBleError(
          BleErrorCode.DeviceNotFound,
          'Unknown peripheral identifier $identifier',
        ),
      );
    }
  }

  Future<void> _errorIfCannotConnect(String identifier) async {
    final canConnect =
        await _peripherals[identifier]?.onConnectRequest() ?? false;
    if (!canConnect) {
      return Future.error(
        SimulatedBleError(
          BleErrorCode.DeviceConnectionFailed,
          'Connection to peripheral $identifier was denied',
        ),
      );
    }
  }

  Future<void> _errorIfCharacteristicIsNull(
    SimulatedCharacteristic characteristic,
    String characteristicId,
  ) async {}

  Future<void> _errorIfCharacteristicNotReadable(
      SimulatedCharacteristic characteristic) async {
    if (!characteristic.isReadable) {
      return Future.error(
        SimulatedBleError(
          BleErrorCode.CharacteristicReadFailed,
          'Characteristic is not readable',
        ),
      );
    }
  }

  Future<void> _errorIfCharacteristicNotWritableWithResponse(
      SimulatedCharacteristic characteristic) async {
    if (!characteristic.isWritableWithResponse) {
      return Future.error(
        SimulatedBleError(
          BleErrorCode.CharacteristicWriteFailed,
          'Characteristic is not writable with response',
        ),
      );
    }
  }

  Future<void> _errorIfCharacteristicNotWritableWithoutResponse(
      SimulatedCharacteristic characteristic) async {
    if (!characteristic.isWritableWithoutResponse) {
      return Future.error(
        SimulatedBleError(
          BleErrorCode.CharacteristicWriteFailed,
          'Characteristic is not writable without response',
        ),
      );
    }
  }

  Future<void> _errorIfCharacteristicNotNotifiable(
      SimulatedCharacteristic characteristic) async {
    if (!characteristic.isIndicatable && !characteristic.isNotifiable) {
      return Future.error(
        SimulatedBleError(
          BleErrorCode.CharacteristicNotifyChangeFailed,
          'Characteristic ${characteristic.uuid} is neither indicatable, '
          'nor notifiable',
        ),
      );
    }
  }

  Future<void> _errorIfDescriptorNotFound(
    SimulatedDescriptor descriptor, {
    required String descriptorUuid,
    required int descriptorId,
  }) async {}

  Future<void> _errorIfDescriptorNotWritable(
      SimulatedDescriptor descriptor) async {
    if (!descriptor.writable) {
      return Future.error(
        SimulatedBleError(
          BleErrorCode.DescriptorWriteFailed,
          'Write to descriptor ${descriptor.uuid} is not allowed',
        ),
      );
    }
  }

  Future<void> _errorIfDescriptorNotReadable(
      SimulatedDescriptor descriptor) async {
    if (!descriptor.readable) {
      return Future.error(
        SimulatedBleError(
          BleErrorCode.DescriptorReadFailed,
          'Read from descriptor ${descriptor.uuid} is not allowed',
        ),
      );
    }
  }
}
