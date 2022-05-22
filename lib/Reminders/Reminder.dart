import 'dart:convert';
import 'package:uuid/uuid.dart';

class Reminder {
  String name;
  bool checked;
  DateTime dateAdded;
  DateTime time;
  int id;

  Reminder({
    required this.name,
    required this.checked,
    required this.dateAdded,
    required this.time,
    required this.id
  });

  factory Reminder.fromJson(Map<String, dynamic> jsonData) {
    return Reminder(
      id: jsonData['id'],
      name: jsonData['name'],
      time: DateTime.parse(jsonData['time']),
      checked: jsonData['checked'],
      dateAdded: DateTime.parse(jsonData['dateAdded']),
    );
  }

  static Map<String, dynamic> toMap(Reminder reminder) => {
    'id': reminder.id,
    'name': reminder.name,
    'time': reminder.time.toIso8601String(),
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