import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/models/task_model.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../components/app_state_views.dart';
import '../components/task_card.dart';
import '../providers/task_provider.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedMonth = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  void _prevMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskListAsync = ref.watch(taskListProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: taskListAsync.when(
          data: (tasks) {
            final tasksForSelectedDate = tasks
                .where((t) => DateUtils.isSameDay(t.dueDate, _selectedDate))
                .toList();

            return Column(
              children: [
                _buildHeader(context),
                _buildCalendarGrid(context, tasks),
                const SizedBox(height: AppSpacing.space4),
                _buildDayHeader(context, tasksForSelectedDate.length),
                Expanded(
                  child: tasksForSelectedDate.isEmpty
                      ? const AppEmptyState(
                          title: 'Free day!',
                          subtitle: 'No tasks scheduled for this date.',
                          iconData: Icons.event_available,
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(AppSpacing.space4),
                          itemCount: tasksForSelectedDate.length,
                          itemBuilder: (context, index) {
                            final task = tasksForSelectedDate[index];
                            return TaskCard(
                              title: task.title,
                              date: DateFormat('h:mm a').format(task.dueDate),
                              priority: task.priority,
                              category: task.category,
                              isCompleted: task.isCompleted,
                              isPending: task.isPending,
                              onToggle: (val) {
                                ref
                                    .read(taskActionsProvider)
                                    .toggleTaskCompletion(
                                        task.id, val ?? false);
                              },
                              onDelete: () {
                                ref
                                    .read(taskActionsProvider)
                                    .deleteTask(task.id);
                              },
                            );
                          },
                        ),
                ),
              ],
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
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.space4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat.yMMMM().format(_focusedMonth),
            style: AppTypography.heading1.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: _prevMonth,
                icon: Icon(Icons.chevron_left,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
              ),
              IconButton(
                onPressed: _nextMonth,
                icon: Icon(Icons.chevron_right,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(BuildContext context, List<TaskModel> tasks) {
    final theme = Theme.of(context);
    final int daysInMonth =
        DateUtils.getDaysInMonth(_focusedMonth.year, _focusedMonth.month);
    final DateTime firstDayOfMonth =
        DateTime(_focusedMonth.year, _focusedMonth.month);
    final int startWeekday = firstDayOfMonth.weekday;
    final int offset = startWeekday - 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                .map((day) => Text(day,
                    style: AppTypography.label.copyWith(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.4))))
                .toList(),
          ),
          const SizedBox(height: AppSpacing.space2),
          ...List.generate(6, (weekIndex) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(7, (dayIndex) {
                  final int dayNumber = (weekIndex * 7 + dayIndex) - offset + 1;

                  if (dayNumber < 1 || dayNumber > daysInMonth) {
                    return const SizedBox(width: 32, height: 32);
                  }

                  final DateTime date = DateTime(
                      _focusedMonth.year, _focusedMonth.month, dayNumber);
                  final bool isSelected =
                      DateUtils.isSameDay(date, _selectedDate);
                  final bool isToday =
                      DateUtils.isSameDay(date, DateTime.now());

                  final hasTasks =
                      tasks.any((t) => DateUtils.isSameDay(t.dueDate, date));

                  return InkWell(
                    onTap: () => setState(() => _selectedDate = date),
                    borderRadius: BorderRadius.circular(16),
                    child: Column(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : Colors.transparent,
                            shape: BoxShape.circle,
                            border: isToday && !isSelected
                                ? Border.all(color: theme.colorScheme.primary)
                                : null,
                          ),
                          child: Text(
                            dayNumber.toString(),
                            style: AppTypography.body.copyWith(
                              color: isSelected
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onSurface,
                              fontWeight: isSelected || isToday
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (hasTasks && !isSelected)
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                                color: theme.colorScheme.error,
                                shape: BoxShape.circle),
                          ),
                      ],
                    ),
                  );
                }),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDayHeader(BuildContext context, int count) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('EEE MMM d').format(_selectedDate),
            style: AppTypography.label.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          Text(
            '$count tasks',
            style: AppTypography.label.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
          ),
        ],
      ),
    );
  }
}
