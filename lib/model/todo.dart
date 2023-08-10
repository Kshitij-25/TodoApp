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

  ToDo({
    this.id,
    this.todoText,
    this.isCompleted = false,
  });

  ToDo copyWith({
    int? id,
    String? todoText,
    bool? isCompleted,
  }) {
    return ToDo(
      id: id ?? this.id,
      todoText: todoText ?? this.todoText,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  ToDo.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        todoText = data['todoText'],
        isCompleted = data['isCompleted'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'todoText': todoText,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }
}
