import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/utility/screen_utility.dart';
import 'package:todo_app/widgets/customButton.dart';
import 'package:todo_app/widgets/search_bar.dart';

import '../constants/colors.dart';
import '../controllers/homeController.dart';
import '../widgets/todo_items.dart';

class TodoScreen extends StatelessWidget {
  TodoScreen({super.key});

  var todoController = Get.put(TodoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).primaryColorDark
          : tdBGColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(
          "TaskTrackr",
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            letterSpacing: 1.08,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              todoController.isDarkTheme.toggle();
              Get.changeThemeMode(
                Theme.of(context).brightness == Brightness.dark
                    ? ThemeMode.light
                    : ThemeMode.dark,
              );
            },
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? CupertinoIcons.moon_fill
                  : CupertinoIcons.sun_max_fill,
            ),
          ),
        ],
      ),
      body: bodyWiget(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CustomButton(
        label: "ADD TASK",
        onPressed: () => customBottomSheet(context),
      ),
    );
  }

  Future<dynamic> customBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      offset: const Offset(0, 0),
                      blurRadius: 1,
                      spreadRadius: 0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  autocorrect: false,
                  controller: todoController.todoTextCont,
                  decoration: const InputDecoration(
                    hintText: "Add new Tasks.",
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              ListTile(
                onTap: () async {
                  // final pickedDate = await showDatePicker(
                  //   context: context,
                  //   initialDate: todoController.selectedFromDate.value,
                  //   firstDate: DateTime.now(),
                  //   lastDate: DateTime(2100),
                  // );
                  final pickedDate = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedDate != null) {
                    todoController.selectedFromDate.value =
                        pickedDate; // Update the selected date
                  }
                },
                title: const Text(
                  "FROM",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.08,
                  ),
                ),
                trailing: Obx(
                  () => Text(
                    todoController.selectedFromDate.value.format(context),
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.08,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              ListTile(
                onTap: () async {
                  final pickedDate = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedDate != null) {
                    todoController.selectedToDate.value =
                        pickedDate; // Update the selected date
                  }
                },
                title: const Text(
                  "TO",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.08,
                  ),
                ),
                trailing: Obx(
                  () => Text(
                    todoController.selectedToDate.value.format(context),
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.08,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              CustomButton(
                label: "ADD TASK",
                onPressed: () {
                  todoController.addTodo(todoController.todoTextCont.text);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget bodyWiget(context) {
    return Column(
      children: [
        NormalSearchBar(),
        Expanded(
          child: Obx(
            () => todoController.filteredTodos.isEmpty
                ? Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 40,
                        ),
                        child: Text(
                          "No Tasks",
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                            fontSize: 18,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.08,
                          ),
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: todoController.filteredTodos.length,
                    itemBuilder: (context, index) {
                      final todo = todoController.filteredTodos[index];
                      return TodoItems(
                        todo: todo,
                        onTodoChanged: (changedTodo) {
                          todoController.toggleTodoStatus(index);
                        },
                        onDeleteItem: (itemId) {
                          Get.defaultDialog(
                            title: "Are you sure?",
                            middleText: "Are you sure you want to delete?",
                            onConfirm: () {
                              todoController.deleteTodo(index);
                              Get.back();
                            },
                            onCancel: () => Get.back(),
                          );
                        },
                      );
                    },
                  ),
          ),
        ),
        // SafeArea(
        //   child: Align(
        //     alignment: Alignment.bottomCenter,
        //     child: Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 20),
        //       child: Row(
        //         children: [
        //           Expanded(
        //             child: Container(
        //               padding: const EdgeInsets.symmetric(
        //                   horizontal: 15, vertical: 5),
        //               decoration: BoxDecoration(
        //                 color: Theme.of(context).canvasColor,
        //                 boxShadow: [
        //                   BoxShadow(
        //                     color:
        //                         Theme.of(context).brightness == Brightness.dark
        //                             ? Colors.white
        //                             : Colors.black,
        //                     offset: const Offset(0, 0),
        //                     blurRadius: 1,
        //                     spreadRadius: 0,
        //                   ),
        //                 ],
        //                 borderRadius: BorderRadius.circular(10),
        //               ),
        //               child: TextField(
        //                 autocorrect: false,
        //                 controller: todoController.todoTextCont,
        //                 decoration: const InputDecoration(
        //                   hintText: "Add new Tasks.",
        //                   border: InputBorder.none,
        //                 ),
        //               ),
        //             ),
        //           ),
        //           const SizedBox(
        //             width: 20,
        //           ),
        //           Container(
        //             decoration: BoxDecoration(
        //               color: tdBlue,
        //               borderRadius: BorderRadius.circular(5),
        //             ),
        //             child: IconButton(
        //               onPressed: () {
        //                 todoController
        //                     .addTodo(todoController.todoTextCont.text);
        //                 // todoController.todoTextCont.clear();
        //               },
        //               icon: const Icon(
        //                 Icons.add,
        //                 color: Colors.white,
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
