import 'package:shared_preferences/shared_preferences.dart';

import 'Reminder.dart';

class Repository {
  String key = 'reminders';

  getReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final String? remindersString = prefs.getString(key);

    if (remindersString != null) {
      try {
        final List<Reminder> reminders = Reminder.decode(remindersString);

        return reminders;
      } on Exception {
        await prefs.clear();
      }
    }

    return <Reminder>[];
  }

  saveReminders(List<Reminder> reminders) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final String encodedData = Reminder.encode(reminders);
      await prefs.setString(key, encodedData);
    } on Exception {
      await prefs.clear();
    }
  }
}
