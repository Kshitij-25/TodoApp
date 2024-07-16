import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:todo_app/constants/extensions/snack_bar_ext.dart';
import 'package:todo_app/main.dart';

import '../../constants/assets.dart';
import '../../constants/strings.dart';
import '../../constants/utils/date_time_utils.dart';
import '../../constants/utils/padding_utils.dart';
import '../../constants/utils/sized_box_utils.dart';
import '../../data/backend/task_service.dart';
import '../../data/models/login_state.dart';
import '../providers/auth_state_notifer.dart';
import '../providers/task_providers.dart';
import '../widgets/todo_items.dart';
import 'create_task_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const routeName = '/homeScreen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userTasksAsyncValue = ref.watch(userTasksProvider);
    final logOutState = ref.watch(authStateNotifierProvider);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            forceMaterialTransparency: true,
            title: Text(
              "TaskTrackr",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            centerTitle: false,
            actions: [
              // IconButton(
              //   onPressed: () {},
              //   icon: Icon(
              //     Theme.of(context).brightness == Brightness.light ? CupertinoIcons.moon_fill : CupertinoIcons.sun_max_fill,
              //   ),
              // ),
              IconButton(
                tooltip: 'Logout',
                onPressed: () async {
                  await ref.read(authStateNotifierProvider.notifier).logOut();
                  if (ref.read(authStateNotifierProvider) == LoginState.success) {
                    GoRouter.of(context).goNamed(HomeScreen.routeName);
                    context.showSnackbar('User Logged Out.');
                  } else {
                    ref.read(authStateNotifierProvider).log();
                    context.showSnackbar('Something went wrong');
                  }
                },
                icon: const Icon(
                  Icons.logout,
                ),
              )
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: PaddingUtils.horizontalMedium,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Strings.readyForTasks,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  Row(
                    children: [
                      Text(
                        "Today's",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      TextButton(
                        onPressed: () {},
                        style: const ButtonStyle(visualDensity: VisualDensity.compact),
                        child: Text(
                          DateTimeUtils.formatDay(
                            DateTime.now(),
                          ),
                        ),
                      )
                    ],
                  ),
                  Text(
                    DateTimeUtils.formatDate(
                      DateTime.now(),
                    ),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  SizedBoxUtils.verticalMedium,
                  Expanded(
                    child: userTasksAsyncValue.when(
                      data: (userTasks) {
                        if (userTasks.isEmpty) {
                          return const NoTasksFound();
                        } else {
                          return ListView.builder(
                            itemCount: userTasks.length,
                            itemBuilder: (context, index) {
                              final task = userTasks[index];
                              final taskService = TaskService();
                              return TodoItems(
                                task: task,
                                confirmDismiss: () async {
                                  await taskService.deleteTask(userId: task['userId'], taskId: task.id);
                                  ref.invalidate(userTasksProvider);
                                  return true;
                                },
                                // confirmCompleted: () async {
                                //   await taskService.updateTaskCompletionStatus(
                                //     userId: task['userId'],
                                //     taskId: task['taskId'],
                                //     taskStatus: 'Completed',
                                //   );
                                //   return true;
                                // },
                                onDismissed: () => ref.invalidate(userTasksProvider),
                              );
                            },
                          );
                        }
                      },
                      loading: () => const Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                      error: (error, stackTrace) => Text('Error: $error'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              GoRouter.of(context).pushNamed(CreateTaskScreen.routeName);
            },
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.onInverseSurface,
            ),
          ),
        ),
        if (logOutState == LoginState.loading)
          Container(
            color: Colors.black87,
            child: Center(
              child: CircularProgressIndicator.adaptive(
                backgroundColor: Theme.of(context).indicatorColor,
              ),
            ),
          ),
      ],
    );
  }
}

class NoTasksFound extends StatelessWidget {
  const NoTasksFound({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SvgPicture.asset(
          Assets.emptyFolder,
          height: 100,
        ),
        SizedBoxUtils.verticalMedium,
        Opacity(
          opacity: 0.2,
          child: Text(
            'No Tasks Found',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBoxUtils.verticalLarge,
        SizedBoxUtils.verticalLarge,
        SizedBoxUtils.verticalLarge,
      ],
    );
  }
}
