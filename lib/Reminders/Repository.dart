import 'package:shared_preferences/shared_preferences.dart';

import 'Reminder.dart';

class Repository {
  String key = 'reminders';

  getReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final String? remindersString = prefs.getString(key);

    if (remindersString != null) {
      final List<Reminder> reminders = Reminder.decode(remindersString);

      return reminders;
    }

    return <Reminder>[];
  }

  saveTasks(List<Reminder> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = Reminder.encode(tasks);
    await prefs.setString(key, encodedData);
  }
}
