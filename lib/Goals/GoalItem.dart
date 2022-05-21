import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'Goal.dart';
import '/Tasks/Task.dart';

class GoalItem extends StatelessWidget {
  final Goal goal;
  final dynamic onGoalChanged;
  final dynamic setScene;
  final dynamic removeGoal;
  final dynamic editGoal;

  GoalItem({
    required this.goal,
    required this.onGoalChanged,
    required this.setScene,
    required this.removeGoal,
    required this.editGoal,
  }) : super(key: ObjectKey(goal));

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) {
      return const TextStyle(
          color: Color.fromARGB(255, 108, 108, 108)
      );
    }

    return const TextStyle(
      color: Color.fromARGB(255, 180, 180, 180)
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
            onTap: () => editGoal(goal),
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
            onTap: () => removeGoal(goal),
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
          onTap: () => onGoalChanged(goal),
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
                        child: Image.asset(goal.checked ? 'assets/images/checked.png' : 'assets/images/checked-empty.png'),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            goal.task.isNotEmpty ? goal.task.toUpperCase() : 'GOAL',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 4, 141, 218),
                              fontSize: 14,
                            ),
                          ),
                          const Padding(padding: EdgeInsets.all(2)),
                          Text(
                            goal.name,
                            style: _getTextStyle(goal.checked),
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