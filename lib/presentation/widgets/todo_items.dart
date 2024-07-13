import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/constants/utils/padding_utils.dart';
import 'package:todo_app/constants/utils/sized_box_utils.dart';
import 'package:todo_app/presentation/screens/view_task_screen.dart';

import '../../constants/static_data/category_data.dart';

// ignore: must_be_immutable
class TodoItems extends StatelessWidget {
  const TodoItems({
    super.key,
    this.task,
  });

  final DocumentSnapshot<Object?>? task;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    // Parse string time to DateTime
    DateTime parseTime(String timeStr, DateTime date) {
      final List<String> parts = timeStr.split(':');
      final int hour = int.parse(parts[0]);
      final int minute = int.parse(parts[1]);
      return DateTime(date.year, date.month, date.day, hour, minute);
    }

    DateTime parseDate(String dateStr) {
      final List<String> parts = dateStr.split('-');
      final int day = int.parse(parts[0]);
      final int month = int.parse(parts[1]);
      final int year = int.parse(parts[2]);
      return DateTime(year, month, day);
    }

    // Retrieve and parse startTime and endTime
    final DateTime scheduledDate = parseDate(task?['scheduleDate']);
    final DateTime startTime = parseTime(task?['startTime'], scheduledDate);
    final DateTime endTime = parseTime(task?['endTime'], scheduledDate);

    // Helper function to get the category icon based on purpose
    IconData getCategoryIcon(String purpose) {
      final category = categoryIcons.firstWhere((element) => element['category'] == purpose, orElse: () => {"icon": Icons.check_circle})['icon'];
      return category;
    }

// Helper function to get the category color based on purpose
    Color getCategoryColor(String purpose) {
      final color = categoryIcons.firstWhere((element) => element['category'] == purpose, orElse: () => {"color": Colors.green})['color'];
      return color;
    }

    String getStatus() {
      if (task?['taskStatus'] == 'Completed') {
        return 'Completed';
      } else if (task?['taskStatus'] == 'Expired') {
        return 'Expired';
      } else if (now.isBefore(startTime)) {
        return 'Upcoming';
      } else if (now.isAfter(endTime) && task?['isCompleted'] == true) {
        return 'Completed';
      } else if (now.year == scheduledDate.year &&
          now.month == scheduledDate.month &&
          now.day == scheduledDate.day + 1 &&
          task?['isCompleted'] == false) {
        return 'Expired';
      } else {
        return 'In Progress';
      }
    }

    return GestureDetector(
      onTap: () {
        GoRouter.of(context).pushNamed(ViewTaskScreen.routeName, extra: task);
      },
      child: Card(
        child: Padding(
          padding: PaddingUtils.largePadding,
          child: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(120),
                  color: getCategoryColor(task?['purpose']).withOpacity(0.3),
                  border: Border.all(
                    color: getCategoryColor(task?['purpose']),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Icon(
                    getCategoryIcon(task?['purpose']),
                    color: getCategoryColor(task?['purpose']),
                  ),
                ),
              ),
              Padding(
                padding: PaddingUtils.horizontalMedium,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task?['title'] ?? '',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      textScaler: const TextScaler.linear(0.9),
                    ),
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.clock,
                          size: 15,
                        ),
                        SizedBoxUtils.horizontalSmall,
                        Text(
                          "${task?['startTime']} - ${task?['endTime']}",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    Text(
                      "Due Date: ${task?['scheduleDate']}",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryFixedDim,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: PaddingUtils.symmetric(horizontal: 10, vertical: 5),
                      child: Text(
                        task?['priority'] ?? '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.black,
                            ),
                      ),
                    ),
                  ),
                  SizedBoxUtils.verticalMedium,
                  Text(
                    getStatus(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
