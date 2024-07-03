import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/constants/extensions/screen_size_ext.dart';
import 'package:todo_app/constants/static_data/category_data.dart';
import 'package:todo_app/constants/utils/app_utility.dart';
import 'package:todo_app/constants/utils/padding_utils.dart';
import 'package:todo_app/constants/utils/validation_utils.dart';
import 'package:todo_app/widgets/custom_button.dart';

import '../constants/utils/sized_box_utils.dart';
import '../widgets/custom_text_form_field.dart';

class CreateTaskScreen extends StatelessWidget {
  CreateTaskScreen({super.key});

  static const routeName = '/createTaskScreen';

  static final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppUtility.hideKeyboard(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Create New Task',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
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
                              'Select Date',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            icon: Icon(
                              CupertinoIcons.chevron_down,
                              size: 18,
                              color: Theme.of(context).colorScheme.tertiaryContainer,
                            ),
                            onPressed: () {
                              _selectDate(context);
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
                          if (ValidationUtils.isNotEmpty(value ?? '')) {
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
                                  return Tooltip(
                                    message: purpose['category'],
                                    child: Container(
                                      width: 35,
                                      margin: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(120),
                                        color: purpose['color'].withOpacity(0.3),
                                        border: Border.all(
                                          color: purpose['color'],
                                        ),
                                      ),
                                      child: Icon(
                                        purpose['icon'],
                                        size: 20,
                                        color: purpose['color'],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
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
                              onTap: () {},
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
                              onTap: () {},
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
                          ),
                          SizedBoxUtils.horizontalMedium,
                          _buildPriorityButton(
                            context: context,
                            priority: 'Medium',
                          ),
                          SizedBoxUtils.horizontalMedium,
                          _buildPriorityButton(
                            context: context,
                            priority: 'High',
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
                          if (ValidationUtils.isNotEmpty(value ?? '')) {
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
                            value: true,
                            onChanged: (value) {},
                          )
                        ],
                      ),
                      const Spacer(),
                      CustomButton(
                        label: 'Create Task',
                        onPressed: () {},
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

  _selectDate(BuildContext context) async {
    final ThemeData theme = Theme.of(context);

    switch (theme.platform) {
      case TargetPlatform.android:
        return buildMaterialDatePicker(context);
      case TargetPlatform.iOS:
        return buildCupertinoDatePicker(context);
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

  buildCupertinoDatePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: context.screenHeight / 3,
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (picked) {},
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

  Widget _buildPriorityButton({required BuildContext context, String? priority}) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        child: Text(
          priority ?? '',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.tertiary,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
