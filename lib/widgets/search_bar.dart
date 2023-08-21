import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../controllers/homeController.dart';
import '../main.dart';

class NormalSearchBar extends StatelessWidget {
  final TodoController _homeCont = Get.put(TodoController());

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
            color: _homeCont.isDarkTheme.value ? Colors.white : Colors.black,
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
