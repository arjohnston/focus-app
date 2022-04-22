import 'dart:convert';

class Reminder {
  final String name;

  Reminder({
    required this.name,
  });

  factory Reminder.fromJson(Map<String, dynamic> jsonData) {
    return Reminder(
      name: jsonData['name'],
    );
  }

  static Map<String, dynamic> toMap(Reminder reminder) => {
    'name': reminder.name,
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