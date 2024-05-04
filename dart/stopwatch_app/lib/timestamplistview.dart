import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stopwatch_app/timestampwidget.dart';

class TimestampListView extends StatefulWidget {
  final bool hoursShown;

  TimestampListView({
    Key? key,
    this.durations = const [],
    this.hoursShown = false,
  }) : super(key: key);

  List<Duration> durations = [];
  @override
  State<TimestampListView> createState() => _TimestampListViewState();
}

class _TimestampListViewState extends State<TimestampListView> {
  final _controller = ScrollController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Timer(
        const Duration(milliseconds: 30),
        () => _controller.animateTo(_controller.position.maxScrollExtent,
            duration: const Duration(milliseconds: 150),
            curve: Curves.fastOutSlowIn));

    return ListView.separated(
      controller: _controller,
      itemBuilder: (context, index) => TimestampWidget(
        widget.durations[index],
        index,
        previousTime: index - 1 >= 0 ? widget.durations[index - 1] : null,
        hoursShown: widget.hoursShown,
      ),
      separatorBuilder: (context, index) => const Divider(),
      itemCount: widget.durations.length,
      padding: const EdgeInsets.all(16),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
    );
  }
}
