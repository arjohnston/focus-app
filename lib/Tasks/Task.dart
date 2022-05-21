import 'dart:convert';

class Task {
  String name;
  // String goal = '';
  bool checked;
  DateTime dateAdded;

  Task({
    required this.name,
    required this.checked,
    required this.dateAdded,
  }) {
    // this.goal = goal ?? '';
  }

  factory Task.fromJson(Map<String, dynamic> jsonData) {
    return Task(
      name: jsonData['name'],
      // goal: jsonData['goal'],
      checked: jsonData['checked'],
      dateAdded: DateTime.parse(jsonData['dateAdded']),
    );
  }

  static Map<String, dynamic> toMap(Task task) => {
    'name': task.name,
    // 'goal': task.goal,
    'checked': task.checked,
    'dateAdded': task.dateAdded.toIso8601String(),
  };

  static String encode(List<Task> tasks) => json.encode(
    tasks
        .map<Map<String, dynamic>>((task) => Task.toMap(task))
        .toList(),
  );

  static List<Task> decode(String tasks) =>
      (json.decode(tasks) as List<dynamic>)
          .map<Task>((item) => Task.fromJson(item))
          .toList();
}