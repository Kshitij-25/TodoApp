import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/models/task_model.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../components/app_state_views.dart';
import '../components/task_card.dart';
import '../providers/task_provider.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  const TaskListScreen({super.key});

  @override
  ConsumerState<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Today', 'Upcoming', 'Completed'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskListAsync = ref.watch(taskListProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildFilters(context),
            Expanded(
              child: taskListAsync.when(
                data: (tasks) {
                  final filteredTasks = _filterTasks(tasks);

                  if (filteredTasks.isEmpty) {
                    return AppEmptyState(
                      title: 'No $_selectedFilter tasks',
                      subtitle: _selectedFilter == 'All'
                          ? 'Your task list is empty. Start adding some!'
                          : 'No tasks match the "$_selectedFilter" filter.',
                      iconData: _selectedFilter == 'Completed'
                          ? Icons.done_all
                          : Icons.assignment_late_outlined,
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.space4),
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return TaskCard(
                        title: task.title,
                        date: DateFormat('MMM d, h:mm a').format(task.dueDate),
                        priority: task.priority,
                        category: task.category,
                        isCompleted: task.isCompleted,
                        onToggle: (val) {
                          ref
                              .read(taskActionsProvider)
                              .toggleTaskCompletion(task.id, val ?? false);
                        },
                        onDelete: () {
                          ref.read(taskActionsProvider).deleteTask(task.id);
                        },
                      );
                    },
                  );
                },
                loading: () =>
                    const Center(child: CircularProgressIndicator.adaptive()),
                error: (err, stack) => AppErrorState(
                  error: err.toString(),
                  onRetry: () => ref.invalidate(taskListProvider),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TaskModel> _filterTasks(List<TaskModel> tasks) {
    final now = DateTime.now();
    switch (_selectedFilter) {
      case 'Today':
        return tasks.where((t) => DateUtils.isSameDay(t.dueDate, now)).toList();
      case 'Upcoming':
        return tasks
            .where((t) =>
                t.dueDate.isAfter(now) && !DateUtils.isSameDay(t.dueDate, now))
            .toList();
      case 'Completed':
        return tasks.where((t) => t.isCompleted).toList();
      default:
        return tasks;
    }
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.space4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'My Tasks',
            style: AppTypography.heading1.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space4),
      child: Row(
        children: _filters.map((filter) {
          final bool isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.space2),
            child: ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) setState(() => _selectedFilter = filter);
              },
              selectedColor: theme.colorScheme.primary,
              labelStyle: AppTypography.label.copyWith(
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              backgroundColor: theme.colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.borderRadiusFull,
                side: BorderSide(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.1),
                ),
              ),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }
}
