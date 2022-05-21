import 'dart:convert';

class Goal {
  String name;
  String task = '';
  bool checked;
  DateTime dateAdded;

  Goal({
    required this.name,
    required this.task,
    required this.checked,
    required this.dateAdded,
  }) {
    // this.goal = goal ?? '';
  }

  factory Goal.fromJson(Map<String, dynamic> jsonData) {
    return Goal(
      name: jsonData['name'],
      task: jsonData['task'],
      checked: jsonData['checked'],
      dateAdded: DateTime.parse(jsonData['dateAdded']),
    );
  }

  static Map<String, dynamic> toMap(Goal goal) => {
    'name': goal.name,
    'task': goal.task,
    'checked': goal.checked,
    'dateAdded': goal.dateAdded.toIso8601String(),
  };

  static String encode(List<Goal> goals) => json.encode(
    goals
        .map<Map<String, dynamic>>((goal) => Goal.toMap(goal))
        .toList(),
  );

  static List<Goal> decode(String goals) =>
      (json.decode(goals) as List<dynamic>)
          .map<Goal>((item) => Goal.fromJson(item))
          .toList();
}