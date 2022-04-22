import 'dart:convert';

class Task {
  final String name;
  bool checked;

  Task({
    required this.name,
    required this.checked,
  });

  factory Task.fromJson(Map<String, dynamic> jsonData) {
    return Task(
      name: jsonData['name'],
      checked: jsonData['checked'],
    );
  }

  static Map<String, dynamic> toMap(Task task) => {
    'name': task.name,
    'checked': task.checked,
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