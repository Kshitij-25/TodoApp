import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:svg_flutter/svg_flutter.dart';

import '../../constants/assets.dart';
import '../../constants/strings.dart';
import '../../constants/utils/date_time_utils.dart';
import '../../constants/utils/padding_utils.dart';
import '../../constants/utils/sized_box_utils.dart';
import '../widgets/todo_items.dart';
import 'create_task_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const routeName = '/homeScreen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(
          "TaskTrackr",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Theme.of(context).brightness == Brightness.light ? CupertinoIcons.moon_fill : CupertinoIcons.sun_max_fill,
            ),
          ),
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
                // child: NoTasksFound(),
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return const TodoItems();
                  },
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
      ],
    );
  }
}
