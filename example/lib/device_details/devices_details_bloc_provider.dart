import 'package:flutter/widgets.dart';
import 'package:blemulator_example/repository/device_repository.dart';
import 'package:flutter_ble_lib_ios_15/flutter_ble_lib.dart';
import 'device_details_bloc.dart';

class DeviceDetailsBlocProvider extends InheritedWidget {
  final DeviceDetailsBloc deviceDetailsBloc;

  DeviceDetailsBlocProvider({
    Key? key,
    DeviceDetailsBloc? deviceDetailsBloc,
    required Widget child,
  })  : deviceDetailsBloc = deviceDetailsBloc ??
            DeviceDetailsBloc(DeviceRepository(), BleManager()),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(DeviceDetailsBlocProvider oldWidget) {
    return deviceDetailsBloc != oldWidget.deviceDetailsBloc;
  }

  static DeviceDetailsBloc of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<DeviceDetailsBlocProvider>();
    assert(result != null, 'No DeviceDetailsBlocProvider found in context');
    return result!.deviceDetailsBloc;
  }
}
