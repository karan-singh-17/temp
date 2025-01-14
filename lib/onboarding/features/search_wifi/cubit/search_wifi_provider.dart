import 'package:moe/onboarding/features/search_wifi/cubit/search_wifi_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

class SearchWiFiCubitProvider extends SingleChildStatelessWidget {
  const SearchWiFiCubitProvider({
    this.child,
    super.key,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) => buildWithChild(context, child);

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return BlocProvider(
      create: (_) => SearchWifiCubit(
        heimspeicher: context.read(),
      )..scanForWifi(),
      child: child,
    );
  }
}
