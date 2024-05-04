import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen>
    with AutomaticKeepAliveClientMixin {
  late Timer timer;
  Duration timeLeft = const Duration();
  bool isRunning = false;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), timerTick);
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Expanded(
            child: Center(
                child: Text(
          timeLeft.inHours >= 10
              ? timeLeft.toString().substring(0, 8)
              : timeLeft.toString().substring(0, 7),
          style: TextStyle(
              fontSize: 45, color: Theme.of(context).colorScheme.primary),
        ))),
        ElevatedButton(
            onPressed: () => showPicker(), child: const Text('Set Time')),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                iconSize: 36,
                color: Theme.of(context).colorScheme.primary,
                onPressed: !isRunning && timeLeft > Duration.zero
                    ? () {
                        setState(() {
                          timeLeft = Duration.zero;
                        });
                      }
                    : null,
                icon: const Icon(Icons.restart_alt)),
            IconButton(
              iconSize: 72,
              color: Theme.of(context).colorScheme.primary,
              onPressed: timeLeft > Duration.zero
                  ? () {
                      setState(() {
                        isRunning = !isRunning;
                      });
                    }
                  : null,
              icon: !isRunning
                  ? const Icon(Icons.play_circle)
                  : const Icon(Icons.stop_circle_outlined),
            ),
            IconButton(
                iconSize: 36,
                color: Theme.of(context).colorScheme.primary,
                onPressed: () {},
                icon: const Icon(Icons.music_note)),
          ],
        )
      ],
    );
  }

  void timerTick(Timer timer) {
    setState(() {
      if (isRunning) {
        if (timeLeft.inSeconds > 0) {
          timeLeft -= const Duration(seconds: 1);
        } else {
          isRunning = false;
          onTimerZero();
        }
      }
    });
  }

  showPicker() {
    var timeParts = timeLeft
        .toString()
        .substring(0, timeLeft.toString().indexOf('.'))
        .split(':');
    for (int i = 0; i < timeParts.length; i++) {
      debugPrint(timeParts[i]);
    }
    Picker(
        columnPadding: const EdgeInsets.all(12.0),
        adapter: NumberPickerAdapter(
          data: [
            NumberPickerColumn(
                begin: 0, end: 99, initValue: int.parse(timeParts[0])),
            NumberPickerColumn(
                begin: 0, end: 59, initValue: int.parse(timeParts[1])),
            NumberPickerColumn(
                begin: 0, end: 59, initValue: int.parse(timeParts[2])),
          ],
        ),
        delimiter: [],
        hideHeader: true,
        confirmText: 'Set',
        title: const Text('Set Duration'),
        onConfirm: (Picker picker, List<int> value) {
          timeLeft = Duration(
              hours: picker.getSelectedValues()[0],
              minutes: picker.getSelectedValues()[1],
              seconds: picker.getSelectedValues()[2]);
        }).showDialog(context);
  }

  @override
  bool get wantKeepAlive => true;

  void onTimerZero() {
    isRunning = false;

    _showDialog();
    //TODO: Play sound if user wants
    //TODO: Notify if user is not in app
  }

  Future<void> _showDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text('Timer Notification'),
            content: const Text('Timer has expired'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Dismiss'),
              )
            ]);
      },
    );
  }
}
