import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
class ToDo extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? todoText;
  @HiveField(2)
  bool isCompleted;
  @HiveField(3)
  TimeOfDay? fromTime;
  @HiveField(4)
  TimeOfDay? toTime;

  ToDo({
    this.id,
    this.todoText,
    this.isCompleted = false,
    this.fromTime,
    this.toTime,
  });

  ToDo copyWith({
    int? id,
    String? todoText,
    bool? isCompleted,
    TimeOfDay? fromTime,
    TimeOfDay? toTime,
  }) {
    return ToDo(
      id: id ?? this.id,
      todoText: todoText ?? this.todoText,
      isCompleted: isCompleted ?? this.isCompleted,
      fromTime: fromTime ?? this.fromTime,
      toTime: toTime ?? this.toTime,
    );
  }

  ToDo.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        todoText = data['todoText'],
        isCompleted = data['isCompleted'],
        fromTime = data['fromTime'],
        toTime = data['toTime'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'todoText': todoText,
      'isCompleted': isCompleted ? 1 : 0,
      'fromTime': fromTime,
      'toTime': toTime,
    };
  }
}
