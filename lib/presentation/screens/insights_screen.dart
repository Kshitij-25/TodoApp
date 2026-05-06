import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/models/task_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../components/app_state_views.dart';
import '../providers/task_provider.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});
  static const routeName = '/insights';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final taskListAsync = ref.watch(taskListProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: taskListAsync.when(
          data: (tasks) {
            if (tasks.isEmpty) {
              return const AppEmptyState(
                title: 'No insights yet',
                subtitle:
                    'Complete some tasks to see your productivity trends and personalized tips.',
                iconData: Icons.insights_outlined,
              );
            }

            final completedTasks = tasks.where((t) => t.isCompleted).toList();
            final completedCount = completedTasks.length;

            // Calculate focus time (mock: 25 mins per completed task)
            final focusTimeHours = (completedCount * 25) / 60;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.space6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Insights',
                    style: AppTypography.heading1.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space6),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'Completed',
                          completedCount.toString(),
                          Icons.check_circle_outline,
                          AppColors.success,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.space4),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'Focus Time',
                          '${focusTimeHours.toStringAsFixed(1)}h',
                          Icons.timer_outlined,
                          AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.space8),
                  _buildSectionHeader(context, 'WEEKLY PRODUCTIVITY'),
                  const SizedBox(height: AppSpacing.space4),
                  _buildActivityChart(context, tasks),
                  const SizedBox(height: AppSpacing.space8),
                  _buildAITip(context, tasks),
                  const SizedBox(height: AppSpacing.space8),
                  _buildSectionHeader(context, 'CATEGORY BREAKDOWN'),
                  const SizedBox(height: AppSpacing.space4),
                  _buildCategoryBreakdown(context, tasks),
                  const SizedBox(height: AppSpacing.space12),
                ],
              ),
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

  Widget _buildStatCard(BuildContext context, String label, String value,
      IconData icon, Color color) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.borderRadiusLg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: AppSpacing.space2),
          Text(
            value,
            style: AppTypography.heading2.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface),
          ),
          Text(
            label,
            style: AppTypography.label.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityChart(BuildContext context, List<TaskModel> tasks) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final weekDays =
        List.generate(7, (index) => now.subtract(Duration(days: 6 - index)));

    return Container(
      height: 200,
      padding: const EdgeInsets.all(AppSpacing.space6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.borderRadiusLg,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: weekDays.map((day) {
          final completedOnDay = tasks
              .where(
                  (t) => t.isCompleted && DateUtils.isSameDay(t.dueDate, day))
              .length;

          final double heightFactor = (completedOnDay / 10).clamp(0.1, 1.0);

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 12,
                height: 120 * heightFactor,
                decoration: BoxDecoration(
                  color:
                      theme.colorScheme.primary.withValues(alpha: heightFactor),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(height: AppSpacing.space2),
              Text(
                DateFormat('E').format(day)[0],
                style: AppTypography.label.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryBreakdown(BuildContext context, List<TaskModel> tasks) {
    final theme = Theme.of(context);
    final categories = ['Work', 'Personal', 'Health', 'Finance'];
    final total = tasks.isEmpty ? 1 : tasks.length;

    return Column(
      children: categories.map((cat) {
        final count = tasks.where((t) => t.category == cat).length;
        final progress = count / total;
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.space3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(cat,
                      style: AppTypography.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface)),
                  Text('${(progress * 100).toInt()}%',
                      style: AppTypography.label.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.5))),
                ],
              ),
              const SizedBox(height: AppSpacing.space2),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor:
                      theme.colorScheme.onSurface.withValues(alpha: 0.05),
                  valueColor:
                      AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                  minHeight: 8,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAITip(BuildContext context, List<TaskModel> tasks) {
    final tip = _getPersonalizedTip(tasks);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.space6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.borderRadiusLg,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
              const SizedBox(width: AppSpacing.space2),
              Text(
                'PERSONALIZED TIP',
                style: AppTypography.label.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space3),
          Text(
            tip,
            style: AppTypography.body.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                height: 1.4,
                fontSize: 15),
          ),
        ],
      ),
    );
  }

  String _getPersonalizedTip(List<TaskModel> tasks) {
    if (tasks.isEmpty)
      return 'Welcome! Start by adding your first task to see personalized insights.';

    final activeTasks = tasks.where((t) => !t.isCompleted).toList();
    final completedTasks = tasks.where((t) => t.isCompleted).toList();
    final overdueCount =
        activeTasks.where((t) => t.dueDate.isBefore(DateTime.now())).length;

    // 1. Overdue Priority
    if (overdueCount > 0) {
      return "You have $overdueCount overdue tasks. We recommend the '2-minute rule': if it takes less than 2 minutes, do it now!";
    }

    // 2. High Completion Rate
    if (completedTasks.length > activeTasks.length * 2 &&
        activeTasks.isNotEmpty) {
      return "You're on fire! You've completed ${completedTasks.length} tasks recently. Consider taking a short break to recharge.";
    }

    // 3. Category Focus
    final workTasks = activeTasks.where((t) => t.category == 'Work').length;
    if (workTasks > activeTasks.length * 0.7 && activeTasks.length > 3) {
      return "You're heavily focused on 'Work' right now. Don't forget to balance with 'Personal' or 'Health' tasks today!";
    }

    // 4. Low Activity
    if (activeTasks.length > 8) {
      return 'Your list is getting long (${activeTasks.length} items). Try the Eisenhower Matrix: distinguish between urgent and important tasks.';
    }

    // 5. Clean Slate
    if (activeTasks.isEmpty) {
      return 'All caught up! Why not take this time to plan your goals for the coming week?';
    }

    return "Consistency is key. You've completed ${completedTasks.length} tasks so far. Keep building that momentum!";
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: AppTypography.label.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        letterSpacing: 1.2,
      ),
    );
  }
}
