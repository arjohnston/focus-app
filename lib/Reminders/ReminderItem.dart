import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'Reminder.dart';

class ReminderItem extends StatelessWidget {
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

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) {
      return const TextStyle(
          color: Color.fromARGB(255, 108, 108, 108)
      );
    }

    return const TextStyle(
      color: Color.fromARGB(255, 180, 180, 180),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: const ValueKey(0),

      // Left side
      startActionPane: ActionPane(
        extentRatio: 0.19,
        motion: const ScrollMotion(),
        children: [
          GestureDetector(
            onTap: () => setScene(0),
            child: Card(
                margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
                elevation: 3,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: const Icon(
                    Icons.hourglass_top,
                    color: Color.fromARGB(255, 4, 141, 218),
                  ),
                )
            ),
          ),
        ],
      ),

      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        extentRatio: 0.38,
        motion: const ScrollMotion(),
        children: [
          GestureDetector(
            onTap: () => editReminder(reminder),
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
            onTap: () => removeReminder(reminder),
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
          onTap: () => onReminderChanged(reminder),
          child: Card(
              margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
              elevation: 3,
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Image.asset(reminder.checked ? 'assets/images/checked.png' : 'assets/images/checked-empty.png'),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reminder.goal.isNotEmpty ? reminder.goal.toUpperCase() : 'GOAL',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 180, 180, 180),
                              fontSize: 10,
                            ),
                          ),
                          const Padding(padding: EdgeInsets.all(2)),
                          Text(
                            reminder.name,
                            style: _getTextStyle(reminder.checked),
                          )
                        ],
                      ),

                    ]
                ),
              )
          )
      ),
    );
  }
}
