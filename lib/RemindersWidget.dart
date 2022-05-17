import 'package:flutter/material.dart';
import 'Reminders/Reminder.dart';
import 'Reminders/ReminderItem.dart';
import 'Reminders/Repository.dart';
import 'package:intl/intl.dart';

class RemindersWidget extends StatefulWidget {
  final Function setScene;
  const RemindersWidget(this.setScene, {Key? key}) : super(key: key);

  @override
  _ReminderListState createState() => _ReminderListState();
}

class _ReminderListState extends State<RemindersWidget> {
  final Repository repository = Repository();
  final TextEditingController _textFieldController = TextEditingController();
  List<Reminder> _reminders = <Reminder>[];

  _ReminderListState() {
    _getRemindersFromRepository();
  }

  _getRemindersFromRepository() async {
    List<Reminder> reminders = await repository.getReminders();
    reminders.sort((a, b) => a.dateAdded.compareTo(b.dateAdded));

    setState(() {
      _reminders = reminders;
    });
  }

  _getDate() {
    var now = DateTime.now();
    return DateFormat.yMMMMd().format(now);
  }

  removeReminder(Reminder reminder) {
    List<Reminder> reminders = _reminders;
    reminders.remove(reminder);

    setState(() {
      _reminders = reminders;
    });

    repository.saveReminders(_reminders);
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
                  children: [
                    const Text(
                      'My Reminders',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.2,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(3),
                    ),
                    Text(
                      _getDate(),
                      style: const TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.2,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                        width: 70,
                        height: 70,
                        child: DecoratedBox(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(35))
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  _reminders.where((t) => !t.checked).toList().length.toString(),
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 4, 141, 218),
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                  )
                              ),
                              Container(
                                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: Text(
                                      "/" + (_reminders.length).toString(),
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 4, 141, 218),
                                        fontSize: 14,
                                      )
                                  )
                              ),
                            ],
                          ),
                        )

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
                      }).where((t) => !t.reminder.checked).toList(),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                      child: _reminders.isNotEmpty && _reminders.where((t) => t.checked).toList().isNotEmpty
                          ? const Text(
                          'COMPLETED',
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.2,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          )
                      )
                          : null,
                    ),
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
                      }).where((t) => t.reminder.checked).toList(),
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
  }

  void _addReminderItem(String name) {
    setState(() {
      _reminders.add(Reminder(name: name, checked: false, dateAdded: DateTime.now()));
    });
    _textFieldController.clear();
    repository.saveReminders(_reminders);
  }

  void _editReminderItem(Reminder reminder, String name) {
    setState(() {
      reminder.name = name;
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
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Type your new reminder'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                Navigator.of(context).pop();
                _addReminderItem(_textFieldController.text);
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
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Type your reminder'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                Navigator.of(context).pop();
                _editReminderItem(reminder, _textFieldController.text);
              },
            ),
          ],
        );
      },
    );
  }
}

