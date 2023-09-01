import 'package:fitb_pantry_app/src/core/services/di.dart';
import 'package:fitb_pantry_app/src/feature/exapmle/presentation/bloc/example_bloc.dart';
import 'package:fitb_pantry_app/src/feature/order/presentation/bloc/order_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProviderScope extends StatelessWidget {
  const ProviderScope({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ExampleBloc(),
        ),
        BlocProvider(
          create: (context) => OrderBloc(repository: sl()),
        ),
      ],
      child: child,
    );
  }
}
