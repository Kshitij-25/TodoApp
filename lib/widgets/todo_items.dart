import 'package:flutter/material.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/utility/screen_utility.dart';

// ignore: must_be_immutable
class TodoItems extends StatelessWidget {
  TodoItems({
    super.key,
    required this.todo,
    required this.onTodoChanged,
    required this.onDeleteItem,
    // ignore: non_constant_identifier_names
    this.fromTime,
    // ignore: non_constant_identifier_names
    this.toTime,
  });

  // final todoList = ToDo.todoList();
  final ToDo todo;
  // ignore: prefer_typing_uninitialized_variables
  final onTodoChanged;
  // ignore: prefer_typing_uninitialized_variables
  final onDeleteItem;

  // ignore: non_constant_identifier_names
  String? fromTime;
  // ignore: non_constant_identifier_names
  String? toTime;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: ScreenUtility.getWidth(context) * 0.84,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListTile(
              onTap: () {
                onTodoChanged(todo);
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              tileColor: Theme.of(context).canvasColor,
              title: Text(
                todo.todoText!,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.08,
                  decoration: todo.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("From : $fromTime"),
                  Text("To : $toTime"),
                ],
              ),
              leading: Icon(
                todo.isCompleted
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                color: tdBlue,
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: tdRed, borderRadius: BorderRadius.circular(5)),
          child: IconButton(
            onPressed: () {
              onDeleteItem(todo.id);
            },
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
