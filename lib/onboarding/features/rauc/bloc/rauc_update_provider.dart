import 'package:moe/onboarding/features/rauc/bloc/rauc_update_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nineti_heimspeicher/nineti_heimspeicher.dart';
import 'package:provider/single_child_widget.dart';

class RaucUpgradeProvider extends SingleChildStatelessWidget {
  const RaucUpgradeProvider({
    this.child,
    super.key,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) => buildWithChild(context, child);

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return BlocProvider(
      create: (_) => RaucUpgradeBloc(
        createRaucUpdate:
            context.read<HeimspeicherSystem>().createFirmwareUpgrade,
        operationState: context.read<HeimspeicherSystem>().deviceState,
      ),
      child: child,
    );
  }
}
