import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:todo_app/model/todo.dart';

import 'app/todo_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();

  Hive.init(appDocumentDir.path);
  await Hive.initFlutter();

  Hive.registerAdapter(ToDoAdapter());
  Hive.registerAdapter(TimeOfDayAdapter());

  await Hive.openBox<ToDo>('todos');

  runApp(const TodoApp());
}
