import 'package:flutter/material.dart';

class TimestampWidget extends StatefulWidget {
  final Duration time;

  final int indexInList;
  final Duration? previousTime;

  final int shownIndex;
  final bool hoursShown;

  const TimestampWidget(
    this.time,
    this.indexInList, {
    this.previousTime,
    this.hoursShown = false,
    Key? key,
  })  : shownIndex = indexInList + 1,
        super(key: key);

  @override
  _TimestampWidgetState createState() => _TimestampWidgetState();
}

class _TimestampWidgetState extends State<TimestampWidget> {
  @override
  
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.shownIndex.toString(),
            style: TextStyle(
                fontSize: 16, color: Theme.of(context).colorScheme.secondary),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              widget.hoursShown
                  ? widget.time.toString().substring(0, 11)
                  : widget.time.toString().substring(2, 11),
              style: TextStyle(
                  fontSize: 22, color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
        if (widget.previousTime != null)
          Text(
            '+' +
                (widget.hoursShown
                    ? (widget.time - widget.previousTime!)
                        .toString()
                        .substring(0, 11)
                    : (widget.time - widget.previousTime!)
                        .toString()
                        .substring(2, 11)),
            style: TextStyle(
                fontSize: 16, color: Theme.of(context).colorScheme.secondary),
          )
        else
          Text(
            '+' +
                (widget.hoursShown
                    ? widget.time.toString().substring(0, 11)
                    : widget.time.toString().substring(2, 11)),
            style: TextStyle(
                fontSize: 16, color: Theme.of(context).colorScheme.secondary),
          ),
      ],
    );
  }
}
