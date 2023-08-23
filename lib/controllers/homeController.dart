import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../model/todo.dart';

class TodoController extends GetxController {
  var todos = <ToDo>[].obs;
  var filteredTodos = <ToDo>[].obs;
  var isDarkTheme = Get.isDarkMode.obs;

  Rx<TimeOfDay> selectedFromTime = Rx(TimeOfDay.now());
  Rx<TimeOfDay> selectedToTime = Rx(TimeOfDay.now());

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
    filterTodos(searchController.text); // Update filteredTodos
  }

  // void addTodo(String title) async {
  //   final box = await Hive.openBox<ToDo>('todos');
  //   final todo = ToDo(todoText: title);
  //   await box.add(todo);
  //   todos.add(todo); // Use todos.add to update the list
  //   filterTodos(searchController.text); // Update filteredTodos
  //   todoTextCont.clear();
  // }
  void addTodo(String title) async {
    final box = await Hive.openBox<ToDo>('todos');
    final todo = ToDo(
      todoText: title,
      fromTime: selectedFromTime.value,
      toTime: selectedToTime.value,
    );
    await box.add(todo);
    todos.add(todo); // Use todos.add to update the list
    filterTodos(searchController.text); // Update filteredTodos
    todoTextCont.clear();
  }

  // void toggleTodoStatus(int index) async {
  //   final box = await Hive.openBox<ToDo>('todos');
  //   final todo = todos[index];
  //   todo.isCompleted = !todo.isCompleted;
  //   await box.putAt(index, todo);
  //   todos[index] = todo;

  //   filterTodos(searchController.text); // Update filteredTodos
  // }
  void toggleTodoStatus(int index) async {
    final box = await Hive.openBox<ToDo>('todos');
    final todo = todos[index];
    todo.isCompleted = !todo.isCompleted;
    await box.putAt(index, todo);
    todos[index] = todo;

    filterTodos(searchController.text); // Update filteredTodos
  }

  // void deleteTodo(int index) async {
  //   final box = await Hive.openBox<ToDo>('todos');
  //   await box.deleteAt(index);
  //   todos.removeAt(index); // Update todos list
  //   filterTodos(searchController.text); // Update filteredTodos
  // }

  void deleteTodo(int index) async {
    final box = await Hive.openBox<ToDo>('todos');
    await box.deleteAt(index);
    todos.removeAt(index); // Update todos list
    filterTodos(searchController.text); // Update filteredTodos
  }
}
