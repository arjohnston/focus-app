import 'package:shared_preferences/shared_preferences.dart';

import 'Goal.dart';

class Repository {
  String key = 'goals';

  getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? goalsString = prefs.getString(key);

    if (goalsString != null) {
      try {
        final List<Goal> goals = Goal.decode(goalsString);

        return goals;
      } on Exception {
        await prefs.clear();
      }

    }

    return <Goal>[];
  }

  saveGoals(List<Goal> tasks) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final String encodedData = Goal.encode(tasks);
      await prefs.setString(key, encodedData);

    } on Exception {
      await prefs.clear();
    }
  }
}
