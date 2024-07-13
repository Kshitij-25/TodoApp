import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/constants/extensions/screen_size_ext.dart';
import 'package:todo_app/constants/extensions/snack_bar_ext.dart';
import 'package:todo_app/constants/static_data/category_data.dart';
import 'package:todo_app/constants/utils/app_utility.dart';
import 'package:todo_app/constants/utils/padding_utils.dart';
import 'package:todo_app/constants/utils/validation_utils.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/presentation/widgets/custom_button.dart';

import '../../constants/utils/date_time_utils.dart';
import '../../constants/utils/sized_box_utils.dart';
import '../../data/backend/task_service.dart';
import '../providers/state_providers.dart';
import '../providers/task_providers.dart';
import '../widgets/custom_text_form_field.dart';

class CreateTaskScreen extends ConsumerWidget {
  CreateTaskScreen({super.key});

  static const routeName = '/createTaskScreen';

  static final _formKey = GlobalKey<FormState>();

  final _taskService = TaskService();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _createTask(BuildContext context, WidgetRef ref) async {
    if (_formKey.currentState!.validate()) {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      final scheduleDate = ref.read(scheduleDateProvider.notifier).state;
      final startTime = ref.read(startTimeProvider.notifier).state;
      final endTime = ref.read(endTimeProvider.notifier).state;
      final priority = ref.read(priorityProvider.notifier).state;
      final purpose = ref.watch(selectedPurposeProvider).selectedPurpose;
      final reminder = ref.read(reminderProvider.notifier).state;

      if (scheduleDate == null || startTime == null || endTime == null || priority == null || purpose == null || reminder == null) {
        context.showSnackbar('Please fill the details first');
        return;
      }

      try {
        await _taskService.createTask(
          userId: userId,
          scheduleDate: DateTimeUtils.formatDate(scheduleDate),
          title: _titleController.text,
          purpose: purpose,
          startTime: DateTimeUtils.formatTime(startTime),
          endTime: DateTimeUtils.formatTime(endTime),
          description: _descriptionController.text,
          reminder: DateTimeUtils.formatTime(reminder),
          priority: priority,
          taskStatus: '',
        );
        context.showSnackbar('Task created successfully');
        GoRouter.of(context).pop();
        ref.invalidate(userTasksProvider);
      } catch (e) {
        context.showSnackbar(e.toString());
      }

      // Show a success message or navigate to another screen
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleDate = ref.watch(scheduleDateProvider);
    final startTime = ref.watch(startTimeProvider);
    final endTime = ref.watch(endTimeProvider);
    final priority = ref.watch(priorityProvider);
    final reminder = ref.watch(reminderProvider);
    final purpose = ref.watch(selectedPurposeProvider).selectedPurpose;
    return GestureDetector(
      onTap: () => AppUtility.hideKeyboard(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Create New Task',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          leading: IconButton(
            icon: const Icon(CupertinoIcons.clear),
            onPressed: () => GoRouter.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: PaddingUtils.horizontalLarge,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: SizedBox(
                  height: context.screenHeight * 0.83,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBoxUtils.verticalSmall,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Schedule',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.surface,
                              elevation: 0,
                              splashFactory: NoSplash.splashFactory,
                            ),
                            label: Text(
                              scheduleDate == null
                                  ? 'Select Date'
                                  : DateTimeUtils.formatDate(
                                      scheduleDate,
                                    ),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            icon: Icon(
                              CupertinoIcons.chevron_down,
                              size: 18,
                              color: Theme.of(context).colorScheme.tertiaryContainer,
                            ),
                            onPressed: () {
                              _selectDate(context, (pickedDate) {
                                ref.watch(scheduleDateProvider.notifier).state = pickedDate;
                                pickedDate.log();
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBoxUtils.verticalLarge,
                      CustomTextFormField(
                        hintText: 'Title',
                        labelText: 'Title',
                        controller: _titleController,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (!ValidationUtils.isNotEmpty(value ?? '')) {
                            return 'Title is required';
                          }
                          return null;
                        },
                      ),
                      SizedBoxUtils.verticalLarge,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Purpose',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 60,
                              child: ListView(
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(12),
                                scrollDirection: Axis.horizontal,
                                children: categoryIcons.map((purpose) {
                                  bool isSelected = purpose['category'] == ref.watch(selectedPurposeProvider).selectedPurpose;
                                  return Tooltip(
                                    message: purpose['category'],
                                    child: GestureDetector(
                                      onTap: () {
                                        ref.read(selectedPurposeProvider).selectedPurpose = purpose['category'];
                                      },
                                      child: Container(
                                        width: 35,
                                        margin: const EdgeInsets.only(right: 8),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(120),
                                          color: isSelected ? purpose['color'] : purpose['color'].withOpacity(0.3),
                                          border: Border.all(
                                            color: isSelected ? purpose['color'] : Colors.transparent,
                                            width: 2,
                                          ),
                                        ),
                                        child: isSelected
                                            ? Icon(
                                                Icons.check,
                                                size: 30,
                                                color: Theme.of(context).colorScheme.onPrimary,
                                              )
                                            : Icon(
                                                purpose['icon'],
                                                size: 20,
                                                color: purpose['color'],
                                              ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (purpose != null)
                        Text(
                          purpose,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      SizedBoxUtils.verticalLarge,
                      Row(
                        children: [
                          Flexible(
                            child: CustomTextFormField(
                              labelText: 'Start Time',
                              hintText: 'Start Time',
                              readOnly: true,
                              suffixIcon: Icon(
                                CupertinoIcons.clock,
                                size: 18,
                                color: Theme.of(context).colorScheme.tertiaryContainer,
                              ),
                              onTap: () {
                                _selectTime(context, ref, isStartTime: true);
                              },
                              controller: TextEditingController(
                                text: startTime == null ? '' : DateTimeUtils.formatTime(startTime),
                              ),
                            ),
                          ),
                          SizedBoxUtils.horizontalMedium,
                          Flexible(
                            child: CustomTextFormField(
                              labelText: 'End Time',
                              hintText: 'End Time',
                              readOnly: true,
                              suffixIcon: Icon(
                                CupertinoIcons.clock,
                                size: 18,
                                color: Theme.of(context).colorScheme.tertiaryContainer,
                              ),
                              onTap: () {
                                _selectTime(context, ref, isStartTime: false);
                              },
                              controller: TextEditingController(
                                text: endTime == null ? '' : DateTimeUtils.formatTime(endTime),
                              ),
                              validator: (value) {
                                if (startTime != null && endTime != null) {
                                  if (endTime.isBefore(startTime)) {
                                    return 'End time cannot be before start time';
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBoxUtils.verticalLarge,
                      Text(
                        'Priority',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildPriorityButton(
                            context: context,
                            priority: 'Low',
                            isSelected: priority == 'Low', // Check if 'Low' is selected
                            onTap: () {
                              ref.read(priorityProvider.notifier).state = 'Low';
                            },
                          ),
                          SizedBoxUtils.horizontalMedium,
                          _buildPriorityButton(
                            context: context,
                            priority: 'Medium',
                            isSelected: priority == 'Medium', // Check if 'Medium' is selected
                            onTap: () {
                              ref.read(priorityProvider.notifier).state = 'Medium';
                            },
                          ),
                          SizedBoxUtils.horizontalMedium,
                          _buildPriorityButton(
                            context: context,
                            priority: 'High',
                            isSelected: priority == 'High', // Check if 'High' is selected
                            onTap: () {
                              ref.read(priorityProvider.notifier).state = 'High';
                            },
                          ),
                        ],
                      ),
                      SizedBoxUtils.verticalLarge,
                      CustomTextFormField(
                        hintText: 'Description',
                        labelText: 'Description',
                        controller: _descriptionController,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (!ValidationUtils.isNotEmpty(value ?? '')) {
                            return 'Description is required';
                          }
                          return null;
                        },
                      ),
                      SizedBoxUtils.verticalLarge,
                      Row(
                        children: [
                          Text(
                            'Reminder',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const Spacer(),
                          Switch.adaptive(
                            value: ref.watch(reminderProvider.notifier).state != null,
                            onChanged: (value) {
                              if (value) {
                                if (startTime != null) {
                                  ref.read(reminderProvider.notifier).state = startTime.subtract(const Duration(minutes: 15));
                                } else {
                                  context.showSnackbar('Please select a start time first');
                                }
                              } else {
                                ref.read(reminderProvider.notifier).state = null;
                              }
                            },
                          ),
                        ],
                      ),
                      if (reminder != null)
                        Text(
                          'A reminder will be sent at ${DateTimeUtils.formatTime(reminder)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      const Spacer(),
                      CustomButton(
                        label: 'Create Task',
                        onPressed: () async {
                          await _createTask(context, ref);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _selectDate(BuildContext context, void Function(DateTime) onDateTimeChanged) async {
    final ThemeData theme = Theme.of(context);

    switch (theme.platform) {
      case TargetPlatform.android:
        return buildMaterialDatePicker(context);
      case TargetPlatform.iOS:
        return buildCupertinoDatePicker(context, onDateTimeChanged);
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
    }
  }

  buildMaterialDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
    );
  }

  buildCupertinoDatePicker(BuildContext context, void Function(DateTime) onDateTimeChanged) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: context.screenHeight / 3,
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (DateTime picked) {
              onDateTimeChanged(picked);
            },
            initialDateTime: DateTime.now(),
            minimumDate: DateTime.now().subtract(
              const Duration(seconds: 10),
            ),
            maximumDate: DateTime.now().add(
              const Duration(days: 365),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPriorityButton({
    required BuildContext context,
    required String priority,
    required bool isSelected,
    required void Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline,
          ),
        ),
        child: Text(
          priority,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.tertiary,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  _selectTime(BuildContext context, WidgetRef ref, {required bool isStartTime}) async {
    final ThemeData theme = Theme.of(context);

    switch (theme.platform) {
      case TargetPlatform.android:
        return buildMaterialTimePicker(context, ref, isStartTime: isStartTime);
      case TargetPlatform.iOS:
        return buildCupertinoTimePicker(context, ref, isStartTime: isStartTime);
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
    }
  }

  buildMaterialTimePicker(BuildContext context, WidgetRef ref, {required bool isStartTime}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final now = DateTime.now();
      final dateTime = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);

      if (isStartTime) {
        ref.read(startTimeProvider.notifier).state = dateTime;
      } else {
        ref.read(endTimeProvider.notifier).state = dateTime;
      }
    }
  }

  buildCupertinoTimePicker(BuildContext context, WidgetRef ref, {required bool isStartTime}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          color: Theme.of(context).colorScheme.surface,
          child: CupertinoTimerPicker(
            mode: CupertinoTimerPickerMode.hm,
            onTimerDurationChanged: (Duration picked) {
              final now = DateTime.now();
              final dateTime = DateTime(now.year, now.month, now.day, picked.inHours, picked.inMinutes % 60);

              if (isStartTime) {
                ref.read(startTimeProvider.notifier).state = dateTime;
              } else {
                ref.read(endTimeProvider.notifier).state = dateTime;
              }
            },
            initialTimerDuration: Duration(
              hours: TimeOfDay.now().hour,
              minutes: TimeOfDay.now().minute,
            ),
          ),
        );
      },
    );
  }
}
