import 'package:flutter/material.dart';
import 'package:blemulator_example/device_details/view/auto_test_view.dart';
import 'package:blemulator_example/device_details/view/manual_test_view.dart';

class DeviceDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Text('Device Details'),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.autorenew),
                text: 'Automatic',
              ),
              Tab(
                icon: Icon(Icons.settings),
                text: 'Manual',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AutoTestView(),
            ManualTestView(),
          ],
        ),
      ),
    );
  }
}
