
import 'package:flutter/material.dart';
import 'Reminders/Reminder.dart';
import 'Reminders/ReminderItem.dart';
import 'Reminders/Repository.dart';
import 'package:intl/intl.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class RemindersWidget extends StatefulWidget {
  final Function setScene;
  final Function setupPeriodicReminder;
  final Function removePeriodicReminder;
  const RemindersWidget(this.setScene, this.setupPeriodicReminder, this.removePeriodicReminder, {Key? key}) : super(key: key);

  @override
  _ReminderListState createState() => _ReminderListState();
}

class _ReminderListState extends State<RemindersWidget> {
  final Repository repository = Repository();
  final TextEditingController _textFieldController = TextEditingController();
  DateTime _dateTime = DateTime.now();
  List<Reminder> _reminders = <Reminder>[];

  _ReminderListState() {
    _getRemindersFromRepository();
  }

  _getRemindersFromRepository() async {
    List<Reminder> reminders = await repository.getReminders();
    reminders.sort((a, b) => a.time.compareTo(b.time));

    setState(() {
      _reminders = reminders;
    });
  }

  removeReminder(Reminder reminder) {
    List<Reminder> reminders = _reminders;
    reminders.remove(reminder);

    setState(() {
      _reminders = reminders;
    });

    repository.saveReminders(_reminders);
    widget.removePeriodicReminder(reminder);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(20, 130, 20, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'My Reminders',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.2,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(0),
                      children: _reminders.map((Reminder reminder) {
                        return ReminderItem(
                          reminder: reminder,
                          onReminderChanged: _handleReminderChange,
                          setScene: widget.setScene,
                          removeReminder: removeReminder,
                          editReminder: _displayEditDialog,
                        );
                      }).toList(),
                    ),
                  ]
              ),
            ),
          ),

        ],
      ),

      floatingActionButton: FloatingActionButton(
          onPressed: () => _displayNewDialog(),
          tooltip: 'Add Reminder',
          backgroundColor: Colors.white,
          child: const Icon(
            Icons.add,
            color: Colors.blue,
          )),
    );
  }

  void _handleReminderChange(Reminder reminder) {
    setState(() {
      reminder.checked = !reminder.checked;
    });
    repository.saveReminders(_reminders);
    _getRemindersFromRepository();

    if (!reminder.checked) {
      widget.removePeriodicReminder(reminder);
    }
  }

  void _addReminderItem(String name, DateTime time) {
    Reminder reminder = Reminder(id: time.millisecondsSinceEpoch ~/ 10000, name: name, checked: true, dateAdded: DateTime.now(), time: time);
    setState(() {
      _reminders.add(reminder);
    });
    _textFieldController.clear();
    repository.saveReminders(_reminders);

    widget.setupPeriodicReminder(reminder);
  }

  void _editReminderItem(Reminder reminder, String name, DateTime time) {
    setState(() {
      reminder.name = name;
      reminder.time = time;
    });
    _textFieldController.clear();
    repository.saveReminders(_reminders);
  }

  Future<void> _displayNewDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a new reminder'),
          content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Select time"),
                const Padding(padding: EdgeInsets.all(4)),
                TimePickerSpinner(
                  is24HourMode: false,
                  normalTextStyle: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey
                  ),
                  highlightedTextStyle: const TextStyle(
                      fontSize: 18,
                      color: Colors.black
                  ),
                  itemHeight: 30,
                  isForce2Digits: true,
                  onTimeChange: (time) {
                    setState(() {
                      _dateTime = time;
                    });
                  },
                ),
                const Padding(padding: EdgeInsets.all(10)),
                TextField(
                  controller: _textFieldController,
                  decoration: const InputDecoration(hintText: 'Type your new reminder'),
                ),
              ]
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                Navigator.of(context).pop();
                _addReminderItem(_textFieldController.text, _dateTime);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _displayEditDialog(Reminder reminder) async {
    _textFieldController.text = reminder.name;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change a reminder'),
          content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Select time"),
                const Padding(padding: EdgeInsets.all(4)),
                TimePickerSpinner(
                  is24HourMode: false,
                  normalTextStyle: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey
                  ),
                  highlightedTextStyle: const TextStyle(
                      fontSize: 18,
                      color: Colors.black
                  ),
                  itemHeight: 30,
                  isForce2Digits: true,
                  onTimeChange: (time) {
                    setState(() {
                      _dateTime = time;
                    });
                  },
                ),
                const Padding(padding: EdgeInsets.all(10)),
                TextField(
                  controller: _textFieldController,
                  decoration: const InputDecoration(hintText: 'Type your new reminder'),
                ),
              ]
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                Navigator.of(context).pop();
                _editReminderItem(reminder, _textFieldController.text, _dateTime);
              },
            ),
          ],
        );
      },
    );
  }
}

