import 'dart:convert';

import 'package:hive/hive.dart';

part 'model.g.dart';

@HiveType(typeId: 0)
class ToDoModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String description;

  @HiveField(2)
  String category;

  @HiveField(3)
  bool isDone;

  @override
  String toString() {
    return jsonEncode({
      'name': name,
      'description': description,
      'category': category,
      'isDone': isDone,
    });
  }

  ToDoModel copyWith({
    String? name,
    String? description,
    String? category,
    bool? isDone,
  }) {
    return ToDoModel(
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      isDone: isDone ?? this.isDone,
    );
  }

  ToDoModel({
    required this.name,
    required this.description,
    required this.category,
    required this.isDone,
  });
}
