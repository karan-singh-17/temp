import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ValueStreamBuilder<T> extends StatelessWidget {
  const ValueStreamBuilder({
    required this.stream,
    required this.builder,
    super.key,
  });

  final ValueStream<T> stream;
  final Widget Function(BuildContext, AsyncSnapshot<T>) builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      initialData: stream.value,
      stream: stream,
      builder: builder,
    );
  }
}
