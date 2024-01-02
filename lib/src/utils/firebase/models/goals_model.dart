import 'dart:convert';

class GoalsModel {
  final String? id;
  final String? type;
  final String? description;
  final String? title;
  final int? times;
  final List<String> daysWeek;
  final List<String> daysMonth;
  final List<String> hours;

  GoalsModel({
    this.id,
    this.type,
    this.description,
    this.title,
    this.times,
    this.daysWeek = const [],
    this.daysMonth = const [],
    this.hours = const [],
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'title': title,
      'description': description,
      'times': times,
      'daysWeek': daysWeek,
      'daysMonth': daysMonth,
      'hours': hours,
    };
  }

  factory GoalsModel.fromMap(Map<String, dynamic> map, String? id) {
    return GoalsModel(
      id: id,
      type: map['type'] != null ? map['type'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      times: map['times'] != null ? map['times'] as int : null,
      daysWeek: List<String>.from(((map['daysWeek'] ?? []))),
      daysMonth: List<String>.from(((map['daysMonth'] ?? []))),
      hours: List<String>.from(((map['hours'] ?? []))),
    );
  }

  String toJson() => json.encode(toMap());

  factory GoalsModel.fromJson(String source, String id) =>
      GoalsModel.fromMap(json.decode(source) as Map<String, dynamic>, id);
}
