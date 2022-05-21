import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'Task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final dynamic onTaskChanged;
  final dynamic setScene;
  final dynamic removeTask;
  final dynamic editTask;

  TaskItem({
    required this.task,
    required this.onTaskChanged,
    required this.setScene,
    required this.removeTask,
    required this.editTask,
  }) : super(key: ObjectKey(task));

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) {
      return const TextStyle(
        color: Color.fromARGB(255, 108, 108, 108),
        fontSize: 16
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
            onTap: () => editTask(task),
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
            onTap: () => removeTask(task),
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
        onTap: () => onTaskChanged(task),
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
                      child: Image.asset(task.checked ? 'assets/images/checked.png' : 'assets/images/checked-empty.png'),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(padding: EdgeInsets.all(2)),
                        Text(
                          task.name,
                          style: _getTextStyle(task.checked),
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
