import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'Goal.dart';

class GoalItem extends StatelessWidget {
  final Goal goal;
  final dynamic setScene;

  GoalItem({
    required this.goal,
    required this.setScene,
  }) : super(key: ObjectKey(goal));

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
      child: Card(
          margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
          elevation: 3,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: const Icon(
              Icons.radar,
              color: Color.fromARGB(255, 4, 141, 218),
            ),
          )
      ),

    );
  }
}