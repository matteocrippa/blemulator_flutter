import 'package:blemulator_example/device_details/device_detail_cubit.dart';
import 'package:flutter/material.dart';
import 'package:blemulator_example/device_details/view/button_view.dart';
import 'package:blemulator_example/device_details/view/logs_container_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AutoTestView extends StatelessWidget {
  AutoTestView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: _createAutoTestControlPanel(context),
            ),
          ),
          Expanded(
            flex: 9,
            child: LogsContainerView(),
          )
        ],
      ),
    );
  }

  Widget _createAutoTestControlPanel(BuildContext context) {
    return Row(
      children: [
        ButtonView('Start Auto Test', action: () => _startAutoTest(context)),
      ],
    );
  }

  void _startAutoTest(BuildContext context) {
    context.read<DeviceDetailsCubit>().startAutoTest();
  }
}
