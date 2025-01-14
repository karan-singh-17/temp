import 'package:flutter/material.dart';

class ConnectionIndicatorSquare extends StatelessWidget {
  const ConnectionIndicatorSquare({required this.color, super.key});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.square,
      size: 20,
      color: color,
    );
  }
}
