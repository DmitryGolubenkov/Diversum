import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stopwatch_app/stopwatchwidget.dart';
import 'package:stopwatch_app/timestamplistview.dart';

class StopWatchScreen extends StatefulWidget {
  const StopWatchScreen({Key? key}) : super(key: key);

  @override
  State<StopWatchScreen> createState() => _StopWatchScreenState();
}

class _StopWatchScreenState extends State<StopWatchScreen>
    with AutomaticKeepAliveClientMixin<StopWatchScreen> {
  final stopwatch = Stopwatch();
  List<Duration> timestamps = [];
  bool _showHours = false;

  late Timer timer;

  _StopWatchScreenState() {
    timer = Timer.periodic(const Duration(minutes: 10), callback);
  }

  void callback(Timer timer) {
    if (stopwatch.elapsed.inMinutes > 45) {
      setState(() {
        _showHours = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        //Time text
        Expanded(
          child: Center(
            child: StopWatchWidget(stopwatch, _showHours),
          ),
        ),
        //Timestamp list
        Expanded(
          child: TimestampListView(
            durations: timestamps,
            hoursShown: _showHours,
          ),
        ),

        //Buttons Row
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //Reset button
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: stopwatch.isRunning
                    ? null
                    : () {
                        setState(() {
                          stopwatch.reset();
                          timestamps.clear();
                          _showHours = false;
                        });
                      },
                icon: Icon(
                  Icons.replay,
                  color: !stopwatch.isRunning
                      ? Theme.of(context).primaryColor
                      : null,
                  size: 36,
                ),
                disabledColor: Theme.of(context).disabledColor,
              ),
              //Start / stop button
              IconButton(
                iconSize: 72,
                padding: EdgeInsets.zero,
                onPressed: () {
                  setState(() {
                    if (!stopwatch.isRunning) {
                      stopwatch.start();
                    } else {
                      stopwatch.stop();
                    }
                  });
                },
                icon: Icon(
                  //Show icon depending on stopwatch state
                  !stopwatch.isRunning
                      ? Icons.play_circle
                      : Icons.stop_circle_outlined,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              //Timestamp Button
              IconButton(
                disabledColor: Theme.of(context).disabledColor,
                padding: EdgeInsets.zero,
                onPressed: stopwatch.isRunning
                    ? () {
                        setState(() {
                          timestamps.add(stopwatch.elapsed);
                        });
                      }
                    : null,
                icon: Icon(
                  Icons.alarm,
                  color: stopwatch.isRunning
                      ? Theme.of(context).primaryColor
                      : null,
                  size: 36,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
