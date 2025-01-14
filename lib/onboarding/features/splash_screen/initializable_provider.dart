import 'package:moe/onboarding/model/initializable.dart';
import 'package:moe/onboarding/services/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

typedef Initializables = List<Initializable>;

class InitializableProvider extends SingleChildStatelessWidget {
  const InitializableProvider({
    this.child,
    super.key,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) => buildWithChild(context, child);

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    final get = context.read;

    return Provider<Initializables>(
      create: (_) => [
        get<SettingsService>(),
      ],
      child: child,
    );
  }
}
