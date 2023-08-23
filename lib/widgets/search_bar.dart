import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/homeController.dart';

class NormalSearchBar extends StatelessWidget {
  final TodoController _homeCont = Get.put(TodoController());

  NormalSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        autocorrect: false,
        controller: _homeCont.searchController,
        onChanged: (value) {
          _homeCont.filterTodos(value);
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
          hintText: "Search",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).canvasColor,
        ),
        cursorColor: Colors.green,
      ),
    );
  }
}
