import 'dart:convert';

class Goal {
  String name;

  Goal({
    required this.name,

  }) {
    // this.goal = goal ?? '';
  }

  factory Goal.fromJson(Map<String, dynamic> jsonData) {
    return Goal(
      name: jsonData['name']
    );
  }

  static Map<String, dynamic> toMap(Goal goal) => {
    'name': goal.name,
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