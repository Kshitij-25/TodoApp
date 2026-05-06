import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/backend/authenticator.dart';
import '../../data/models/task_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../components/app_state_views.dart';
import '../components/task_card.dart';
import '../providers/task_provider.dart';
import 'profile_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  static const routeName = '/homeScreen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final taskListAsync = ref.watch(taskListProvider);
    final displayName = const Authenticator().displayName;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: taskListAsync.when(
          data: (tasks) {
            final now = DateTime.now();
            final todayTasks = tasks
                .where((t) =>
                    DateUtils.isSameDay(t.dueDate, now) && !t.isCompleted)
                .toList();

            final upcomingTasks = tasks
                .where((t) =>
                    t.dueDate.isAfter(now) &&
                    !DateUtils.isSameDay(t.dueDate, now) &&
                    !t.isCompleted)
                .toList();

            final completedToday = tasks
                .where(
                    (t) => DateUtils.isSameDay(t.dueDate, now) && t.isCompleted)
                .length;

            final totalToday =
                tasks.where((t) => DateUtils.isSameDay(t.dueDate, now)).length;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, displayName),
                  const SizedBox(height: AppSpacing.space6),
                  _buildProgressCard(completedToday, totalToday),
                  const SizedBox(height: AppSpacing.space8),
                  if (todayTasks.isEmpty && upcomingTasks.isEmpty)
                    const AppEmptyState(
                      title: 'No tasks for today',
                      subtitle: 'Enjoy your free time or plan your next goal!',
                      iconData: Icons.wb_sunny_outlined,
                    )
                  else ...[
                    if (todayTasks.isNotEmpty) ...[
                      _buildSectionTitle(context, 'TODAY'),
                      const SizedBox(height: AppSpacing.space4),
                      ...todayTasks
                          .map((task) => _buildTaskCard(context, ref, task)),
                    ],
                    const SizedBox(height: AppSpacing.space4),
                    if (upcomingTasks.isNotEmpty) ...[
                      _buildSectionTitle(context, 'UPCOMING'),
                      const SizedBox(height: AppSpacing.space4),
                      ...upcomingTasks
                          .take(3)
                          .map((task) => _buildTaskCard(context, ref, task)),
                    ],
                  ],
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

  Widget _buildTaskCard(BuildContext context, WidgetRef ref, TaskModel task) {
    return TaskCard(
      title: task.title,
      date: DateFormat('h:mm a').format(task.dueDate),
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
  }

  Widget _buildHeader(BuildContext context, String name) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good morning 👋',
              style: AppTypography.body.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
            ),
            Text(
              name.isEmpty ? 'User' : name.split(' ')[0],
              style: AppTypography.heading1.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () => context.pushNamed(ProfileScreen.routeName),
          borderRadius: BorderRadius.circular(24),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: theme.colorScheme.primary,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'U',
              style: AppTypography.label
                  .copyWith(color: theme.colorScheme.onPrimary),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCard(int completed, int total) {
    final progress = total == 0 ? 0.0 : completed / total;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space6),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: AppRadius.borderRadiusLg,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TODAY\'S PROGRESS',
            style: AppTypography.label.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.space2),
          Text(
            '$completed / $total tasks done',
            style: AppTypography.heading2.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.space4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTypography.label.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            letterSpacing: 1.1,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'See all',
            style:
                AppTypography.label.copyWith(color: theme.colorScheme.primary),
          ),
        ),
      ],
    );
  }
}
