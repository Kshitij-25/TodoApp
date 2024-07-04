import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/constants/utils/date_time_utils.dart';
import 'package:todo_app/constants/utils/padding_utils.dart';
import 'package:todo_app/constants/utils/sized_box_utils.dart';
import 'package:todo_app/presentation/screens/view_task_screen.dart';

// ignore: must_be_immutable
class TodoItems extends StatelessWidget {
  const TodoItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).pushNamed(ViewTaskScreen.routeName);
      },
      child: Card(
        child: Padding(
          padding: PaddingUtils.largePadding,
          child: Row(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(120),
                  // color: purpose['color'].withOpacity(0.3),
                  border: Border.all(
                      // color: purpose['color'],
                      ),
                ),
                child: const Icon(
                  Icons.check_box,
                  color: Colors.green,
                ),
              ),
              Padding(
                padding: PaddingUtils.horizontalLarge,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Go To Gym",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.clock,
                          size: 15,
                        ),
                        SizedBoxUtils.horizontalSmall,
                        Text(
                          "10:00 AM - 11:00 AM",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    Text(
                      "Due Date: ${DateTimeUtils.formatDate(DateTime.now())}",
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
                        'High',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.black,
                            ),
                      ),
                    ),
                  ),
                  SizedBoxUtils.verticalMedium,
                  Text(
                    'In Progress',
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
