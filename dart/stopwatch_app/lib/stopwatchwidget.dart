import 'dart:async';

import 'package:flutter/material.dart';

class StopWatchWidget extends StatefulWidget {
  final Stopwatch stopwatch;
  final bool hoursShown;

  const StopWatchWidget(
    this.stopwatch, [
    this.hoursShown = false,
    Key? key,
  ]) : super(key: key);

  @override
  _StopWatchWidgetState createState() => _StopWatchWidgetState();
}

class _StopWatchWidgetState extends State<StopWatchWidget> {
  late Timer timer;

  _StopWatchWidgetState() {
    timer = Timer.periodic(const Duration(milliseconds: 30), callback);
  }

  void callback(Timer timer) {
    if (widget.stopwatch.isRunning) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var timerTextStyle =
        TextStyle(fontSize: 50, color: Theme.of(context).colorScheme.primary);
    return Text(
        widget.hoursShown
            ? widget.stopwatch.elapsed.toString().substring(0, 11)
            : widget.stopwatch.elapsed.toString().substring(2, 11),
        style: timerTextStyle);
  }
}
