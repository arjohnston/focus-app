import 'package:flutter/material.dart';
import 'Goals/Goal.dart';
import 'Goals/GoalItem.dart';
import 'Goals/GoalsRepository.dart';
import 'Tasks/Task.dart';
import 'Tasks/TaskItem.dart';
import 'Tasks/Repository.dart';
import 'package:intl/intl.dart';

class GoalsWidget extends StatefulWidget {
  final Function setScene;
  const GoalsWidget(this.setScene, {Key? key}) : super(key: key);

  @override
  _GoalListState createState() => _GoalListState();
}

class _GoalListState extends State<GoalsWidget> {
  final GoalsRepository repository = GoalsRepository();
  final TextEditingController _taskTextFieldController = TextEditingController();
  final TextEditingController _goalTextFieldController = TextEditingController();

  List<Task> _tasks = <Task>[];
  List<Goal> _goals = <Goal>[];

  _GoalListState() {
    _getGoalsFromRepository();
  }

  _getGoalsFromRepository() async {
    List<Goal> goals = await repository.getGoals();
    goals.sort((a, b) => a.dateAdded.compareTo(b.dateAdded));

    setState(() {
      _goals = goals;
    });
  }

  removeGoal(Goal goal) {
    List<Goal> goals = _goals;
    goals.remove(goal);

    setState(() {
      _goals = goals;
    });

    repository.saveGoals(_goals);
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
                      'My Goals',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.2,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(3),
                    ),
                    Text(
                      'Create long-term goals',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.2,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      )
                    )
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
                                  _goals.where((t) => !t.checked).toList().length.toString(),
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 4, 141, 218),
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                  )
                              ),
                              Container(
                                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: Text(
                                      "/" + (_goals.length).toString(),
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
                          onGoalChanged: _handleGoalChange,
                          setScene: widget.setScene,
                          removeGoal: removeGoal,
                          editGoal: _displayEditDialog,
                        );
                      }).where((t) => !t.goal.checked).toList(),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                      child: _goals.isNotEmpty && _goals.where((t) => t.checked).toList().isNotEmpty
                          ? const Text(
                          'COMPLETED',
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.2,
                            fontSize: 14,
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
                          onGoalChanged: _handleGoalChange,
                          setScene: widget.setScene,
                          removeGoal: removeGoal,
                          editGoal: _displayEditDialog,
                        );
                      }).where((g) => g.goal.checked).toList(),
                    ),
                  ]
              ),
            ),
          ),

        ],
      ),

      floatingActionButton: FloatingActionButton(
          onPressed: () => _displayNewDialog(),
          tooltip: 'Add goal',
          backgroundColor: Colors.white,
          child: const Icon(
            Icons.add,
            color: Colors.blue,
          )),
    );
  }

  void _handleGoalChange(Goal goal) {
    setState(() {
      goal.checked = !goal.checked;
    });
    repository.saveGoals(_goals);
    _getGoalsFromRepository();
  }

  void _addGoalItem(String name, String task) {
    setState(() {
      _goals.add(Goal(name: name, task: task, checked: false, dateAdded: DateTime.now()));
    });
    _taskTextFieldController.clear();
    repository.saveGoals(_goals);
  }

  void _editGoalItem(Goal goal, String name) {
    setState(() {
      goal.name = name;
    });
    _goalTextFieldController.clear();
    repository.saveGoals(_goals);
  }

  Future<void> _displayNewDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget> [
              TextFormField(
                controller: _goalTextFieldController,
                decoration: const InputDecoration(hintText: 'Create a new goal'),
              ),
              TextFormField(
                controller: _taskTextFieldController,
                decoration: const InputDecoration(hintText: 'Description'),
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                Navigator.of(context).pop();
                _addGoalItem(_taskTextFieldController.text,_goalTextFieldController.text );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _displayEditDialog(Goal goal) async {
    _goalTextFieldController.text = goal.name;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change a goal item'),
          content: TextField(
            controller: _goalTextFieldController,
            decoration: const InputDecoration(hintText: 'Type your goal'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                Navigator.of(context).pop();
                _editGoalItem(goal, _goalTextFieldController.text);
              },
            ),
          ],
        );
      },
    );
  }
}
