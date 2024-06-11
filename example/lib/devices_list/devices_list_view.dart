import 'package:blemulator_example/devices_list/devices_bloc.dart';
import 'package:blemulator_example/devices_list/hex_painter.dart';
import 'package:blemulator_example/model/ble_device.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DevicesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth devices'),
      ),
      body: BlocBuilder<DevicesBloc, List<BleDevice>>(
        builder: (context, devices) {
          return RefreshIndicator(
            onRefresh: () => context.read<DevicesBloc>().refresh(),
            child: DevicesList(devices),
          );
        },
      ),
    );
  }
}

class DevicesList extends StatelessWidget {
  final List<BleDevice> devices;

  const DevicesList(this.devices);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey[300],
        height: 0,
        indent: 0,
      ),
      itemCount: devices.length,
      itemBuilder: (context, i) {
        final bleDevice = devices[i];
        return ListTile(
          leading: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: _buildAvatar(context, bleDevice),
          ),
          title: Text(bleDevice.name),
          trailing: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Icon(Icons.chevron_right, color: Colors.grey),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                bleDevice.id.toString(),
                style: TextStyle(fontSize: 10),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              )
            ],
          ),
          onTap: () => _onDeviceTap(context, bleDevice),
          contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 12),
        );
      },
    );
  }

  static void _onDeviceTap(BuildContext context, BleDevice bleDevice) {
    print('clicked device: ${bleDevice.name}');
    context.read<DevicesBloc>().devicePicker.add(bleDevice);
  }

  static Widget _buildAvatar(BuildContext context, BleDevice device) {
    switch (device.category) {
      case DeviceCategory.sensorTag:
        return CircleAvatar(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/ti_logo.png'),
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        );
      case DeviceCategory.hex:
        return CircleAvatar(
          child: CustomPaint(
            painter: HexPainter(),
            size: Size(20, 24),
          ),
          backgroundColor: Colors.black,
        );
      case DeviceCategory.other:
      default:
        return CircleAvatar(
          child: Icon(Icons.bluetooth),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
        );
    }
  }
}
