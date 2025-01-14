import 'package:flutter/material.dart';

class ConnectionStatusWidget extends StatelessWidget {
  const ConnectionStatusWidget({
    required this.color,
    required this.text,
    super.key,
  });

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 25),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            color: color,
            size: 15,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
