import 'package:flutter/material.dart';
import 'Tasks/Task.dart';
import 'Tasks/TaskItem.dart';
import 'Tasks/Repository.dart';

class TasksWidget extends StatefulWidget {
  const TasksWidget({Key? key}) : super(key: key);

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TasksWidget> {
  final Repository repository = Repository();
  final TextEditingController _textFieldController = TextEditingController();
  List<Task> _tasks = <Task>[];

  _TaskListState() {
    _getTasksFromRepository();
  }

  _getTasksFromRepository() async {
    List<Task> tasks = await repository.getTasks();

    setState(() {
      _tasks = tasks;
    });
  }

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
          backgroundColor: Colors.white,
          child: const Icon(
            Icons.add,
            color: Colors.blue,
          )),
    );
  }

  void _handleTaskChange(Task task) {
    setState(() {
      task.checked = !task.checked;
    });
    repository.saveTasks(_tasks);
  }

  void _addTaskItem(String name) {
    setState(() {
      _tasks.add(Task(name: name, checked: false));
    });
    _textFieldController.clear();
    repository.saveTasks(_tasks);
  }

  Future<void> _displayDialog() async {
    return showDialog<void>(
      context: context,
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
