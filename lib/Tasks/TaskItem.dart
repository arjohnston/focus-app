import 'package:flutter/material.dart';

import 'Task.dart';

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
