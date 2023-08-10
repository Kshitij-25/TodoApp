import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

var todoList = <ToDo>[].obs;
var filteredTodoList = <ToDo>[].obs;
final RxString searchQuery = RxString('');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  await Hive.initFlutter();
  Hive.registerAdapter(ToDoAdapter());
  await Hive.openBox<ToDo>('todos');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "ToDo App",
        theme: ThemeData.dark(useMaterial3: true),
        home: TodoScreen(),
      ),
    );
  }
}
