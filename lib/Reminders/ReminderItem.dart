import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'Reminder.dart';

class ReminderItem extends StatefulWidget {
  // const ReminderItem({Key? key}) : super(key: key);

  final Reminder reminder;
  final dynamic onReminderChanged;
  final dynamic setScene;
  final dynamic removeReminder;
  final dynamic editReminder;

  ReminderItem({
    required this.reminder,
    required this.onReminderChanged,
    required this.setScene,
    required this.removeReminder,
    required this.editReminder,
  }) : super(key: ObjectKey(reminder));

  @override
  _ReminderItemState createState() => _ReminderItemState();
}

class _ReminderItemState extends State<ReminderItem> {
  bool isSwitched = false;

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) {
      return const TextStyle(
          color: Color.fromARGB(255, 180, 180, 180)
      );
    }

    return const TextStyle(
      color: Color.fromARGB(255, 108, 108, 108),
    );
  }

  @override
  Widget build(BuildContext context) {


    return Slidable(
      key: const ValueKey(0),
      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        extentRatio: 0.38,
        motion: const ScrollMotion(),
        children: [
          GestureDetector(
            onTap: () => widget.editReminder(widget.reminder),
            child: Card(
                margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
                elevation: 3,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: const Icon(
                    Icons.edit,
                    color: Color.fromARGB(255, 4, 141, 218),
                  ),
                )
            ),
          ),
          GestureDetector(
            onTap: () => widget.removeReminder(widget.reminder),
            child: Card(
                margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
                elevation: 3,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: const Icon(
                    Icons.delete_outlined,
                    color: Color.fromARGB(255, 225, 69, 97),
                  ),
                )
            ),
          ),
        ],
      ),

      // The child of the Slidable is what the user sees when the
      // component is not dragged.
      child: GestureDetector(
          onTap: () => widget.onReminderChanged(widget.reminder),
          child: Card(
              margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
              elevation: 3,
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                (widget.reminder.time.hour > 12 ? widget.reminder.time.hour % 12 : widget.reminder.time.hour).toString() + ":" + (widget.reminder.time.minute < 10 ? "0" + widget.reminder.time.minute.toString() : widget.reminder.time.minute.toString()),
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                (widget.reminder.time.hour < 12 ? "  AM" : "  PM"),
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 110, 110, 110),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const Padding(padding: EdgeInsets.all(2)),
                          Text(
                            widget.reminder.name,
                            style: _getTextStyle(widget.reminder.checked),
                          )
                        ],
                      ),
                      Switch(
                        value: widget.reminder.checked,
                        onChanged: (value) {
                          widget.onReminderChanged(widget.reminder);
                        },
                        activeTrackColor: Colors.lightGreenAccent,
                        activeColor: Colors.green,
                      ),
                    ]
                ),
              )
          )
      ),
    );
  }
}
