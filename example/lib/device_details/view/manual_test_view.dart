import 'package:blemulator_example/device_details/device_detail_cubit.dart';
import 'package:flutter/material.dart';
import 'package:blemulator_example/device_details/view/button_view.dart';
import 'package:blemulator_example/device_details/view/logs_container_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManualTestView extends StatelessWidget {
  ManualTestView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(children: <Widget>[
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            child: _createControlPanel(context),
          ),
        ),
        Expanded(
          flex: 7,
          child: LogsContainerView(),
        )
      ]),
    );
  }

  void _connect(BuildContext context) {
    context.read<DeviceDetailsCubit>().connect();
  }

  void _disconnect(BuildContext context) {
    context.read<DeviceDetailsCubit>().disconnectManual();
  }

  void _readRssi(BuildContext context) {
    context.read<DeviceDetailsCubit>().readRssi();
  }

  void _requestMtu(BuildContext context) {
    context.read<DeviceDetailsCubit>().requestMtu();
  }

  void _discovery(BuildContext context) {
    context.read<DeviceDetailsCubit>().discovery();
  }

  void _fetchConnectedDevices(BuildContext context) {
    context.read<DeviceDetailsCubit>().fetchConnectedDevices();
  }

  void _fetchKnownDevices(BuildContext context) {
    context.read<DeviceDetailsCubit>().fetchKnownDevices();
  }

  void _readCharacteristicForPeripheral(BuildContext context) {
    context.read<DeviceDetailsCubit>().readCharacteristicForPeripheral();
  }

  void _readCharacteristicForService(BuildContext context) {
    context.read<DeviceDetailsCubit>().readCharacteristicForService();
  }

  void _readCharacteristicDirectly(BuildContext context) {
    context.read<DeviceDetailsCubit>().readCharacteristicDirectly();
  }

  void _writeCharacteristicForPeripheral(BuildContext context) {
    context.read<DeviceDetailsCubit>().writeCharacteristicForPeripheral();
  }

  void _writeCharacteristicForService(BuildContext context) {
    context.read<DeviceDetailsCubit>().writeCharacteristicForService();
  }

  void _writeCharacteristicDirectly(BuildContext context) {
    context.read<DeviceDetailsCubit>().writeCharacteristicDirectly();
  }

  void _monitorCharacteristicForPeripheral(BuildContext context) {
    context.read<DeviceDetailsCubit>().monitorCharacteristicForPeripheral();
  }

  void _monitorCharacteristicForService(BuildContext context) {
    context.read<DeviceDetailsCubit>().monitorCharacteristicForService();
  }

  void _monitorCharacteristicDirectly(BuildContext context) {
    context.read<DeviceDetailsCubit>().monitorCharacteristicDirectly();
  }

  void _disableBluetooth(BuildContext context) {
    context.read<DeviceDetailsCubit>().disableBluetooth();
  }

  void _enableBluetooth(BuildContext context) {
    context.read<DeviceDetailsCubit>().enableBluetooth();
  }

  void _fetchBluetoothState(BuildContext context) {
    context.read<DeviceDetailsCubit>().fetchBluetoothState();
  }

  Column _createControlPanel(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            children: <Widget>[
              ButtonView('Connect', action: () => _connect(context)),
              ButtonView('Disconnect', action: () => _disconnect(context)),
              ButtonView('Connected devices',
                  action: () => _fetchConnectedDevices(context)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            children: <Widget>[
              ButtonView('Read Rssi', action: () => _readRssi(context)),
              ButtonView('Request MTU', action: () => _requestMtu(context)),
              ButtonView('Known devices',
                  action: () => _fetchKnownDevices(context)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            children: <Widget>[
              ButtonView('Discovery', action: () => _discovery(context)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            children: <Widget>[
              ButtonView('Write to temp config via peripheral',
                  action: () => _writeCharacteristicForPeripheral(context)),
              ButtonView('Read temp via peripheral',
                  action: () => _readCharacteristicForPeripheral(context)),
              ButtonView('Monitor temp via peripheral',
                  action: () => _monitorCharacteristicForPeripheral(context)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            children: <Widget>[
              ButtonView('Write to temp config via service',
                  action: () => _writeCharacteristicForService(context)),
              ButtonView('Read temp via service',
                  action: () => _readCharacteristicForService(context)),
              ButtonView('Monitor temp via service',
                  action: () => _monitorCharacteristicForService(context)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            children: <Widget>[
              ButtonView('Write to temp config directly',
                  action: () => _writeCharacteristicDirectly(context)),
              ButtonView('Read temp directly',
                  action: () => _readCharacteristicDirectly(context)),
              ButtonView('Monitor temp directly',
                  action: () => _monitorCharacteristicDirectly(context)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            children: <Widget>[
              ButtonView('Monitor temp',
                  action: () => _monitorCharacteristicForPeripheral(context)),
              ButtonView('Turn on temp',
                  action: () => _writeCharacteristicForPeripheral(context)),
              ButtonView('Read temp',
                  action: () => _readCharacteristicForPeripheral(context)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            children: <Widget>[
              ButtonView('Enable bluetooth',
                  action: () => _enableBluetooth(context)),
              ButtonView('Disable bluetooth',
                  action: () => _disableBluetooth(context)),
              ButtonView('Fetch BT State',
                  action: () => _fetchBluetoothState(context)),
            ],
          ),
        ),
      ],
    );
  }
}
