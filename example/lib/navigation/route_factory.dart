import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RouteFactory {
  static MaterialPageRoute build<T extends BlocBase<dynamic>>(
    T bloc,
    Widget view,
  ) {
    return MaterialPageRoute(
      builder: (_) => BlocProvider<T>(
        create: (_) => bloc,
        child: view,
      ),
    );
  }
}
