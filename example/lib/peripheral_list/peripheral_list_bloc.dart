import 'dart:async';
import 'package:blemulator_example/model/ble_peripheral.dart';
import 'package:blemulator_example/adapter/ble_adapter.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class PeripheralListBloc
    extends Bloc<PeripheralListEvent, PeripheralListState> {
  final BleAdapter _bleAdapter;
  StreamSubscription<BlePeripheral>? _blePeripheralsSubscription;

  PeripheralListBloc(this._bleAdapter) : super(PeripheralListState.initial());

  @override
  Stream<PeripheralListState> mapEventToState(
    PeripheralListEvent event,
  ) async* {
    if (event is StartPeripheralScan) {
      yield* _mapStartPeripheralScanToState(event);
    } else if (event is StopPeripheralScan) {
      yield* _mapStopPeripheralScanToState(event);
    } else if (event is NewPeripheralScan) {
      yield* _mapNewPeripheralScanToState(event);
    }
  }

  Stream<PeripheralListState> _mapStartPeripheralScanToState(
      StartPeripheralScan event) async* {
    await _cancelBlePeripheralSubscription();
    _blePeripheralsSubscription =
        _bleAdapter.blePeripherals.listen((BlePeripheral peripheral) {
      add(NewPeripheralScan(peripheral));
    });
    yield PeripheralListState(
        peripherals: state.peripherals, scanningEnabled: true);
  }

  Stream<PeripheralListState> _mapStopPeripheralScanToState(
      StopPeripheralScan event) async* {
    await _cancelBlePeripheralSubscription();
    yield PeripheralListState(
        peripherals: state.peripherals, scanningEnabled: false);
  }

  Stream<PeripheralListState> _mapNewPeripheralScanToState(
      NewPeripheralScan event) async* {
    var updatedPeripherals = state.peripherals;
    if (!updatedPeripherals.contains(event.peripheral)) {
      updatedPeripherals = List.from(state.peripherals);
      updatedPeripherals.add(event.peripheral);
    }
    yield PeripheralListState(
        peripherals: updatedPeripherals,
        scanningEnabled: state.scanningEnabled);
  }

  Future<void> _cancelBlePeripheralSubscription() async {
    await _blePeripheralsSubscription?.cancel();
  }

  @override
  Future<void> close() {
    _cancelBlePeripheralSubscription();
    return super.close();
  }
}
