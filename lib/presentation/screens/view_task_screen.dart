import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/constants/extensions/snack_bar_ext.dart';
import 'package:todo_app/constants/utils/sized_box_utils.dart';
import 'package:todo_app/presentation/widgets/custom_button.dart';

import '../../constants/utils/padding_utils.dart';
import '../../data/backend/task_service.dart';
import '../providers/task_providers.dart';

class ViewTaskScreen extends ConsumerWidget {
  ViewTaskScreen({
    super.key,
    this.task,
  });

  static const routeName = '/viewTaskScreen';

  final DocumentSnapshot<Object?>? task;

  final _taskService = TaskService();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => GoRouter.of(context).pop(),
          icon: const Icon(
            CupertinoIcons.arrow_left_circle,
            size: 40,
          ),
          color: Theme.of(context).colorScheme.tertiaryContainer,
        ),
        actions: const [
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(
          //     Icons.mode_edit_outlined,
          //     size: 35,
          //   ),
          //   color: Theme.of(context).colorScheme.tertiaryContainer,
          // ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: PaddingUtils.horizontalLarge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBoxUtils.verticalMedium,
              Text(
                task?['title'] ?? '',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBoxUtils.verticalMedium,
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Due Date',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBoxUtils.verticalSmall,
                      Text(
                        'Time',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBoxUtils.verticalSmall,
                      Text(
                        'Priority',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBoxUtils.verticalSmall,
                      Text(
                        'Purpose',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBoxUtils.verticalSmall,
                      Text(
                        'Reminder',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  SizedBoxUtils.horizontalLarge,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task?['scheduleDate'] ?? '',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      SizedBoxUtils.verticalSmall,
                      Text(
                        '${task?['startTime']} - ${task?['endTime']}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      SizedBoxUtils.verticalSmall,
                      Text(
                        task?['priority'] ?? '',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      SizedBoxUtils.verticalSmall,
                      Text(
                        task?['purpose'] ?? '',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      SizedBoxUtils.verticalSmall,
                      Text(
                        task?['reminder'] != null ? 'Reminder set at ${task?['reminder']}' : 'No reminder set',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBoxUtils.verticalMedium,
              Text(
                'Description',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBoxUtils.verticalMedium,
              Text(
                task?['description'] ?? '',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Spacer(),
              CustomButton(
                label: task?['taskStatus'] != 'Completed' ? 'Mark as Done' : ' Task Completed',
                isEnabled: task?['taskStatus'] == 'Completed' ? false : true,
                onPressed: () async {
                  await _taskService.updateTaskCompletionStatus(
                    userId: task!['userId'],
                    taskId: task!['taskId'],
                    taskStatus: 'Completed',
                  );
                  ref.invalidate(userTasksProvider);
                  GoRouter.of(context).pop();
                  context.showSnackbar('Task Completed');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
