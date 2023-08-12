import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/utility/screen_utility.dart';

import '../constants/colors.dart';
import '../controllers/homeController.dart';
import '../widgets/todo_items.dart';

class TodoScreen extends StatelessWidget {
  TodoScreen({super.key});

  final TodoController todoController = Get.put(TodoController());
  final TextEditingController todoCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(
          "TaskTrackr",
        ),
      ),
      body: bodyWiget(context),
    );
  }

  Widget bodyWiget(context) {
    return Column(
      children: [
        SizedBox(
          height: ScreenUtility.getHeight(context) * 0.8,
          child: Obx(
            () => todoController.todos.isEmpty
                ? const Center(
                    child: Text(
                      "Enter New Tasks",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: todoController.todos.length,
                    itemBuilder: (context, index) {
                      final todo = todoController.todos[index];
                      return TodoItems(
                        todo: todo,
                        onTodoChanged: (changedTodo) {
                          todoController.toggleTodoStatus(index);
                        },
                        onDeleteItem: (itemId) {
                          todoController.deleteTodo(index);
                        },
                      );
                    },
                  ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(0, 0),
                          blurRadius: 1,
                          spreadRadius: 0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      autocorrect: false,
                      controller: todoCont,
                      decoration: const InputDecoration(
                        hintText: "Add a new todo item.",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: tdBlue,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: IconButton(
                    onPressed: () {
                      todoController.addTodo(todoCont.text);
                      todoCont.clear();
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
