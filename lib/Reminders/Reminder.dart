import 'dart:convert';

class Reminder {
  String name;
  String goal = '';
  bool checked;
  DateTime dateAdded;

  Reminder({
    required this.name,
    required this.checked,
    required this.dateAdded,
    goal,
  }) {
    this.goal = goal ?? '';
  }

  factory Reminder.fromJson(Map<String, dynamic> jsonData) {
    return Reminder(
      name: jsonData['name'],
      goal: jsonData['goal'],
      checked: jsonData['checked'],
      dateAdded: DateTime.parse(jsonData['dateAdded']),
    );
  }

  static Map<String, dynamic> toMap(Reminder reminder) => {
    'name': reminder.name,
    'goal': reminder.goal,
    'checked': reminder.checked,
    'dateAdded': reminder.dateAdded.toIso8601String(),
  };

  static String encode(List<Reminder> reminders) => json.encode(
    reminders
        .map<Map<String, dynamic>>((task) => Reminder.toMap(task))
        .toList(),
  );

  static List<Reminder> decode(String reminders) =>
      (json.decode(reminders) as List<dynamic>)
          .map<Reminder>((item) => Reminder.fromJson(item))
          .toList();
}