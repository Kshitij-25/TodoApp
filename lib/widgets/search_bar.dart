// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../constants/colors.dart';
// import '../controllers/homeController.dart';
// import '../main.dart';

// class SearchBarDelegate extends SliverPersistentHeaderDelegate {
//   final TodoController _homeCont = Get.put(TodoController());
//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Container(
//       color: tdBGColor,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             color: Colors.white,
//           ),
//           child: TextField(
//             autocorrect: false,
//             controller: _homeCont.searchController,
//             style: const TextStyle(color: Colors.black),
//             onChanged: (value) {
//               searchQuery.value = value;
//             },
//             decoration: const InputDecoration(
//               prefixIcon: Icon(
//                 Icons.search,
//                 color: tdBlack,
//               ),
//               // prefixIconConstraints: BoxConstraints(maxHeight: 20, maxWidth: 25),
//               hintText: "Search",
//               border: InputBorder.none,
//             ),
//             cursorColor: Colors.green,
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   double get maxExtent => 48.0;

//   @override
//   double get minExtent => 48.0;

//   @override
//   bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
// }
