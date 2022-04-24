import 'package:shared_preferences/shared_preferences.dart';

import 'Task.dart';

class Repository {
  String key = 'tasks';

  getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksString = prefs.getString(key);

    if (tasksString != null) {
      try {
        final List<Task> tasks = Task.decode(tasksString);

        return tasks;
      } on Exception {
        await prefs.clear();
      }

    }

    return <Task>[];
  }

  saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final String encodedData = Task.encode(tasks);
      await prefs.setString(key, encodedData);

    } on Exception {
      await prefs.clear();
    }
  }
}
