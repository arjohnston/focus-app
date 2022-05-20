import 'package:flutter/material.dart';
import 'Goals/Goal.dart';
import 'Goals/GoalsRepository.dart';
import 'Tasks/Task.dart';
import 'Tasks/TaskItem.dart';
import 'Tasks/Repository.dart';
import 'package:intl/intl.dart';
import 'Goals/GoalItem.dart';

class GoalsWidget extends StatefulWidget {
  final Function setScene;
  const GoalsWidget(this.setScene, {Key? key}) : super(key: key);

  @override
  _GoalListState createState() => _GoalListState();
}

class _GoalListState extends State<GoalsWidget> {
  final Repository repository = Repository(); // task repository
  final GoalsRepository goalsRepository = GoalsRepository();
  final TextEditingController _textFieldController = TextEditingController();

  List<Task> _tasks = <Task>[];
  List<Goal> _goals = <Goal>[];

  _GoalListState() {
    _getGoalsFromRepository();
  }

  _getGoalsFromRepository() async {
    List<Goal> goals = await goalsRepository.getGoals();
    goals.sort();

    setState(() {
      _goals = goals;
    });
  }

  _getDate() {
    var now = DateTime.now();
    return DateFormat.yMMMMd().format(now);
  }

  // removeTask(Task task) {
  //   List<Task> tasks = _tasks;
  //   tasks.remove(task);
  //
  //   setState(() {
  //     _tasks = tasks;
  //   });
  //
  //   repository.saveTasks(_tasks);
  // }

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
                      'My Goals',
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
                                  _tasks.where((t) => !t.checked).toList().length.toString(),
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 4, 141, 218),
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                  )
                              ),
                              Container(
                                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: Text(
                                      "/" + (_tasks.length).toString(),
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
                      children: _goals.map((Goal goal) {
                        return GoalItem(
                          goal: goal,
                          setScene: widget.setScene,
                        );
                      }).toList(),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                      child: _tasks.isNotEmpty && _tasks.where((t) => t.checked).toList().isNotEmpty
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
                      children: _goals.map((Goal goal) {
                        return GoalItem(
                          goal: goal,
                          setScene: widget.setScene,
                        );
                      }).toList(),
                    ),
                  ]
              ),
            ),
          ),

        ],
      ),

      // floatingActionButton: FloatingActionButton(
      //     onPressed: () => _displayNewDialog(),
      //     tooltip: 'Add task',
      //     backgroundColor: Colors.white,
      //     child: const Icon(
      //       Icons.add,
      //       color: Colors.blue,
      //     )),
    );
  }

  // void _handleTaskChange(Task task) {
  //   setState(() {
  //     task.checked = !task.checked;
  //   });
  //   repository.saveTasks(_tasks);
  //   _getTasksFromRepository();
  // }

  void _addTaskItem(String name, String goal) {
    setState(() {
      _tasks.add(Task(name: name, checked: false, goal: goal, dateAdded: DateTime.now()));
    });
    _textFieldController.clear();
    repository.saveTasks(_tasks);
  }

  void _editTaskItem(Task task, String name) {
    setState(() {
      task.name = name;
    });
    _textFieldController.clear();
    repository.saveTasks(_tasks);
  }

  // Future<void> _displayNewDialog() async {
  //   return showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Add a new task item'),
  //         content: TextField(
  //           controller: _textFieldController,
  //           decoration: const InputDecoration(hintText: 'Type your new task'),
  //
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('Add'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               _addTaskItem(_textFieldController.text,_textFieldController.text );
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Future<void> _displayEditDialog(Task task) async {
    _textFieldController.text = task.name;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change a task item'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Type your task'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                Navigator.of(context).pop();
                _editTaskItem(task, _textFieldController.text);
              },
            ),
          ],
        );
      },
    );
  }
}