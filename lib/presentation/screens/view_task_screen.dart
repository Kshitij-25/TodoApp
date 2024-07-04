import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/constants/utils/date_time_utils.dart';
import 'package:todo_app/constants/utils/sized_box_utils.dart';
import 'package:todo_app/presentation/widgets/custom_button.dart';

import '../../constants/utils/padding_utils.dart';

class ViewTaskScreen extends ConsumerWidget {
  const ViewTaskScreen({super.key});

  static const routeName = '/viewTaskScreen';

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
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.mode_edit_outlined,
              size: 35,
            ),
            color: Theme.of(context).colorScheme.tertiaryContainer,
          ),
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
                'Go to Gym',
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
                    ],
                  ),
                  SizedBoxUtils.horizontalLarge,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateTimeUtils.formatDate(DateTime.now()),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      SizedBoxUtils.verticalSmall,
                      Text(
                        '10:00Am - 12:00Pm',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      SizedBoxUtils.verticalSmall,
                      Text(
                        'High',
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
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Spacer(),
              CustomButton(
                label: 'Save as Done',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
