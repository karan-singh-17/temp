import 'package:flutter/material.dart';

class RemoveBluetootDeviceButton extends StatelessWidget {
  const RemoveBluetootDeviceButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    void removeDevice() {
      // context.read<HeimspeicherSystem>().disconnectBTDevice();
    }

    return ElevatedButton(
      onPressed: () => removeDevice(),
      child: const Icon(Icons.delete),
    );
  }
}
