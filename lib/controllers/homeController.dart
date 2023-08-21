import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../model/todo.dart';

class TodoController extends GetxController {
  var todos = <ToDo>[].obs;
  var filteredTodos = <ToDo>[].obs;
  var isDarkTheme = false.obs;

  RxBool isSliverAppBarExpanded = true.obs;
  ScrollController scrollController = ScrollController();
  Animation<double>? titleAnimation;
  TextEditingController searchController = TextEditingController();
  TextEditingController todoTextCont = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      if (scrollController.offset > 0) {
        isSliverAppBarExpanded.value = false;
      } else {
        isSliverAppBarExpanded.value = true;
      }
    });
    _loadTodos();
  }

  void filterTodos(String query) {
    filteredTodos.assignAll(todos.where((todo) {
      return todo.todoText!.toLowerCase().contains(query.toLowerCase());
    }));
  }

  void _loadTodos() async {
    final box = await Hive.openBox<ToDo>('todos');
    todos.assignAll(box.values.toList());
    filteredTodos.assignAll(todos);
  }

  void addTodo(String title) async {
    final box = await Hive.openBox<ToDo>('todos');
    final todo = ToDo(todoText: title);
    await box.add(todo);
    todos.add(todo);
  }

  void toggleTodoStatus(int index) async {
    final box = await Hive.openBox<ToDo>('todos');
    final todo = todos[index];
    todo.isCompleted = !todo.isCompleted;
    await box.putAt(index, todo);
    todos[index] = todo;
  }

  void deleteTodo(int index) async {
    final box = await Hive.openBox<ToDo>('todos');
    await box.deleteAt(index);
    todos.removeAt(index);
  }
}
