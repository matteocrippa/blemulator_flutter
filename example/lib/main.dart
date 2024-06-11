import 'package:blemulator_example/device_details/device_detail_view.dart';
import 'package:blemulator_example/devices_list/devices_bloc.dart';
import 'package:blemulator_example/devices_list/devices_list_view.dart';
import 'package:blemulator_example/repository/device_repository.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:flutter_ble_lib_ios_15/flutter_ble_lib.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  Fimber.plantTree(DebugTree());
  runApp(MyApp());
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      RepositoryProvider(create: (context) => DeviceRepository()),
      RepositoryProvider(create: (context) => BleManager()),
      BlocProvider(
        create: (context) => DevicesBloc(context.read(), context.read()),
      )
    ], child: _buildExample());
  }

  Widget _buildExample() {
    return MaterialApp(
      title: 'Blemulator example',
      theme: ThemeData(
        primaryColor: Color(0xFF0A3D91),
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Color(0xFFCC0000)),
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => DevicesListScreen(),
        '/details': (context) => DeviceDetailsView(),
      },
      navigatorObservers: [routeObserver],
    );
  }
}
