import 'dart:async';
import 'package:blemulator_example/adapter/ble_adapter.dart';
import 'package:blemulator_example/model/ble_peripheral.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';
import 'package:flutter_ble_lib_ios_15/flutter_ble_lib.dart';

class PeripheralDetailsBloc
    extends Bloc<PeripheralDetailsEvent, PeripheralDetailsState> {
  final BleAdapter _bleAdapter;
  final BlePeripheral _chosenPeripheral;

  PeripheralDetailsBloc(this._bleAdapter, this._chosenPeripheral)
      : super(PeripheralDetailsState(peripheral: _chosenPeripheral)) {
    _initialize();
  }

  void _initialize() async {
    try {
      final bleServices = await _bleAdapter
          .discoverAndGetServicesCharacteristics(_chosenPeripheral.id);
      add(ServicesFetchedEvent(bleServices));
    } on BleError catch (e) {
      // Handle the error.
      // Possible causes: peripheral got disconnected or Bluetooth has been turned off.
      // Handling it the same way as disconnection.
      print('Error discovering services: $e');
    }
  }

  @override
  Stream<PeripheralDetailsState> mapEventToState(
    PeripheralDetailsEvent event,
  ) async* {
    if (event is ServicesFetchedEvent) {
      yield _mapServicesFetchedEventToState(event);
    } else if (event is ServiceViewExpandedEvent) {
      yield _mapServiceViewExpandedEventToState(event);
    }
  }

  PeripheralDetailsState _mapServicesFetchedEventToState(
    ServicesFetchedEvent event,
  ) {
    return PeripheralDetailsState(
      peripheral: state.peripheral,
      bleServiceStates: event.services
          .map((service) => BleServiceState(service: service, expanded: false))
          .toList(),
    );
  }

  PeripheralDetailsState _mapServiceViewExpandedEventToState(
    ServiceViewExpandedEvent event,
  ) {
    var newBleServiceStates =
        List<BleServiceState>.from(state.bleServiceStates);

    newBleServiceStates[event.expandedViewIndex] = BleServiceState(
        service: state.bleServiceStates[event.expandedViewIndex].service,
        expanded: !state.bleServiceStates[event.expandedViewIndex].expanded);

    return PeripheralDetailsState(
      peripheral: state.peripheral,
      bleServiceStates: newBleServiceStates,
    );
  }
}
