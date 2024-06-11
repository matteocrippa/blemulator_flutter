import 'package:blemulator_example/device_details/device_detail_cubit.dart';
import 'package:blemulator_example/device_details/device_details_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogsContainerView extends StatelessWidget {
  LogsContainerView();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4.0))),
      child: SizedBox.expand(
        child: Column(
          children: <Widget>[
            Flexible(
              child: BlocBuilder<DeviceDetailsCubit, DeviceDetailsState>(
                builder: (context, state) => _buildLogs(context, state.logs),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogs(BuildContext context, List<DebugLog> logs) {
    return ListView.builder(
      itemCount: logs.length,
      shrinkWrap: true,
      itemBuilder: (buildContext, index) => Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
            bottom: BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  logs[index].time,
                  style: TextStyle(fontSize: 9),
                ),
              ),
              Flexible(
                child: Text(logs[index].content,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: TextStyle(fontSize: 13)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
