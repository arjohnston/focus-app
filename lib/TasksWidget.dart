import 'package:flutter/material.dart';

class Task {
  Task({required this.name, required this.checked});
  final String name;
  bool checked;
}

class TaskItem extends StatelessWidget {
  TaskItem({
    required this.task,
    required this.onTaskChanged,
  }) : super(key: ObjectKey(task));

  final Task task;
  final dynamic onTaskChanged;

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: ListTile(
        onTap: () {
          onTaskChanged(task);
        },
        title: Text(task.name, style: _getTextStyle(task.checked)),
      )
    );
  }
}

class TasksWidget extends StatefulWidget {
  const TasksWidget({Key? key}) : super(key: key);

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TasksWidget> {
  final TextEditingController _textFieldController = TextEditingController();
  final List<Task> _tasks = <Task>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 120.0),
        children: _tasks.map((Task task) {
          return TaskItem(
            task: task,
            onTaskChanged: _handleTaskChange,
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _displayDialog(),
          tooltip: 'Add task',
          child: const Icon(Icons.add)),
    );
  }

  void _handleTaskChange(Task task) {
    setState(() {
      task.checked = !task.checked;
    });
  }

  void _addTaskItem(String name) {
    setState(() {
      _tasks.add(Task(name: name, checked: false));
    });
    _textFieldController.clear();
  }

  Future<void> _displayDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a new task item'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Type your new task'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                Navigator.of(context).pop();
                _addTaskItem(_textFieldController.text);
              },
            ),
          ],
        );
      },
    );
  }
}
