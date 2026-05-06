import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/backend/authenticator.dart';
import '../../data/models/task_model.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../providers/task_provider.dart';
import 'app_button.dart';
import 'app_input.dart';

class AddTaskSheet extends ConsumerStatefulWidget {
  const AddTaskSheet({super.key});

  @override
  ConsumerState<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends ConsumerState<AddTaskSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedPriority = 'Medium';
  String _selectedCategory = 'Work';
  DateTime _selectedDate = DateTime.now().add(const Duration(hours: 1));

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _saveTask() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title')),
      );
      return;
    }

    final userId = const Authenticator().userId;
    if (userId == null) return;

    final newTask = TaskModel(
      id: '', // Firestore will generate ID
      title: _titleController.text,
      description: _descriptionController.text,
      dueDate: _selectedDate,
      priority: _selectedPriority,
      category: _selectedCategory,
      userId: userId,
    );

    try {
      await ref.read(taskActionsProvider).addTask(newTask);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving task: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          Divider(
              height: 1,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppInput(
                    label: 'TITLE',
                    hint: 'Design system review',
                    controller: _titleController,
                  ),
                  const SizedBox(height: AppSpacing.space6),
                  AppInput(
                    label: 'DESCRIPTION',
                    hint: 'Add details...',
                    isMultiline: true,
                    controller: _descriptionController,
                  ),
                  const SizedBox(height: AppSpacing.space6),
                  _buildSectionLabel(context, 'DUE DATE & TIME'),
                  const SizedBox(height: AppSpacing.space2),
                  _buildSelector(
                    context: context,
                    icon: Icons.calendar_today_outlined,
                    text:
                        DateFormat('EEE MMM d · h:mm a').format(_selectedDate),
                    onTap: _selectDateTime,
                  ),
                  const SizedBox(height: AppSpacing.space6),
                  _buildSectionLabel(context, 'CATEGORY'),
                  const SizedBox(height: AppSpacing.space2),
                  _buildCategoryChips(context),
                  const SizedBox(height: AppSpacing.space6),
                  AppPrioritySelector(
                    selectedPriority: _selectedPriority,
                    onChanged: (val) => setState(() => _selectedPriority = val),
                  ),
                  const SizedBox(height: AppSpacing.space8),
                  const SizedBox(height: AppSpacing.space8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space4, vertical: AppSpacing.space3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
              ),
              Text(
                'New Task',
                style: AppTypography.heading2.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          AppButton(
            text: 'Save',
            size: ButtonSize.small,
            onPressed: _saveTask,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String label) {
    final theme = Theme.of(context);
    return Text(
      label,
      style: AppTypography.label.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _buildSelector({
    required BuildContext context,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.borderRadiusSm,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.space4),
        decoration: BoxDecoration(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
          borderRadius: AppRadius.borderRadiusSm,
          border: Border.all(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 20,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
            const SizedBox(width: AppSpacing.space3),
            Text(
              text,
              style: AppTypography.body
                  .copyWith(color: theme.colorScheme.onSurface),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChips(BuildContext context) {
    final theme = Theme.of(context);
    final categories = ['Work', 'Personal', 'Health', 'Finance'];
    return Wrap(
      spacing: 8,
      children: categories.map((cat) {
        final bool isSelected = _selectedCategory == cat;
        return ChoiceChip(
          label: Text(cat),
          selected: isSelected,
          onSelected: (val) => setState(() => _selectedCategory = cat),
          selectedColor: theme.colorScheme.primary,
          labelStyle: AppTypography.label.copyWith(
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
          ),
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusFull,
            side: BorderSide(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.1)),
          ),
          showCheckmark: false,
        );
      }).toList(),
    );
  }
}
