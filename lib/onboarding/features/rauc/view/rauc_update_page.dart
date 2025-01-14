import 'package:moe/onboarding/features/rauc/bloc/rauc_update_bloc.dart';
import 'package:moe/onboarding/features/rauc/bloc/rauc_update_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:nineti_heimspeicher/nineti_heimspeicher.dart';

class RaucUpdatePage extends StatelessWidget {
  const RaucUpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const RaucUpgradeProvider(
      child: RaucUpdateView(),
    );
  }
}

class RaucUpdateView extends StatefulWidget {
  const RaucUpdateView({
    super.key,
  });

  @override
  State<RaucUpdateView> createState() => _RaucUpdateViewState();
}

class _RaucUpdateViewState extends State<RaucUpdateView> {
  final TextEditingController _raucUriController = TextEditingController();
  final slotStates = <FirmwareSlotInformation>[];

  @override
  void initState() {
    super.initState();
    _raucUriController.text = 'http://10.13.37.2:8000/update.raucb';
  }

  @override
  Widget build(BuildContext context) {
    Future<void> fetchSlotStates() async {
      setState(() {
        slotStates.clear();
      });

      final states =
          await context.read<HeimspeicherSystem>().getFirmwareSlotInformation();

      setState(() {
        slotStates.addAll(states);
      });
    }

    return BlocBuilder<RaucUpgradeBloc, RaucUpgradeState>(
        builder: (context, state) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('RAUC Update'),
          ),
          floatingActionButton: state.updateTriggered
              ? state.updateDone
                  ? Column(
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const RebootDeviceButton(),
                        const SizedBox(
                          width: 8,
                          height: 8,
                        ),
                        FetchSlotStateButton(onPressed: fetchSlotStates),
                      ],
                    )
                  : null
              : Column(
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    StartUpdateButton(
                      raucUriController: _raucUriController,
                    ),
                    const SizedBox(
                      width: 8,
                      height: 8,
                    ),
                    FetchSlotStateButton(onPressed: fetchSlotStates),
                  ],
                ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Text('Operation State: ${state.deviceState}'),
              ),
              Card(
                child: Text('Slot States:\n${slotStates.join('\n\n')}'),
              ),
              if (state.updateTriggered)
                Card(
                  child: Text(state.toString()),
                ),
              if (!state.updateTriggered)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _raucUriController,
                      decoration: const InputDecoration(
                        labelText: "RAUC update URI",
                      ),
                    ),
                  ),
                ),
            ],
          ));
    });
  }
}

class RebootDeviceButton extends StatelessWidget {
  const RebootDeviceButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    void rebootDevice() {
      context.read<HeimspeicherSystem>().rebootDevice();
    }

    return FloatingActionButton.extended(
      onPressed: rebootDevice,
      label: const Text("Reboot Device"),
    );
  }
}

class FetchSlotStateButton extends StatelessWidget {
  const FetchSlotStateButton({
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed, label: const Text("Slot Status"),
      // child: const Icon(Icons.refresh),
    );
  }
}

class StartUpdateButton extends StatelessWidget {
  const StartUpdateButton({
    required TextEditingController raucUriController,
    super.key,
  }) : _raucUriController = raucUriController;

  final TextEditingController _raucUriController;

  @override
  Widget build(BuildContext context) {
    Future<void> startUpdate() async {
      final uri = _raucUriController.text;

      context.read<RaucUpgradeBloc>().add(StartRaucUpdateEvent(uri: uri));

      Logger().i("Starting RAUC Update with URI: $uri");
    }

    return FloatingActionButton.extended(
      onPressed: startUpdate,
      label: const Text("Start Update"),
    );
  }
}
