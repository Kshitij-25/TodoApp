import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/backend/authenticator.dart';
import '../../data/models/user_model.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../providers/user_provider.dart';

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});
  static const routeName = '/notification-settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null)
            return const Center(child: Text('No user profile found'));

          final settings = user.notificationSettings;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.space6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TASK-TRIGGERED',
                  style: AppTypography.label.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: AppSpacing.space4),
                _buildToggleRow(
                  context,
                  ref,
                  'Due soon reminder',
                  'Fires at your chosen lead time (Default 30 min)',
                  settings.dueSoon,
                  (val) => _updateSettings(ref, user, dueSoon: val),
                  priority: 'Critical',
                ),
                _buildToggleRow(
                  context,
                  ref,
                  'Overdue alert',
                  '15 min grace period after due time',
                  settings.overdue,
                  (val) => _updateSettings(ref, user, overdue: val),
                  priority: 'Critical',
                ),
                _buildToggleRow(
                  context,
                  ref,
                  'Morning briefing',
                  'Daily summary of today\'s tasks at 8am',
                  settings.morningBriefing,
                  (val) => _updateSettings(ref, user, morningBriefing: val),
                  priority: 'Normal',
                ),
                _buildToggleRow(
                  context,
                  ref,
                  'Evening wrap-up',
                  'Score and rollover options at 8pm',
                  settings.eveningWrapUp,
                  (val) => _updateSettings(ref, user, eveningWrapUp: val),
                  priority: 'Low',
                ),
                const SizedBox(height: AppSpacing.space6),
                Text(
                  'STREAKS & MOTIVATION',
                  style: AppTypography.label.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: AppSpacing.space4),
                _buildToggleRow(
                  context,
                  ref,
                  'Streak at risk',
                  '3 hours before midnight if 0 tasks done',
                  settings.streakAtRisk,
                  (val) => _updateSettings(ref, user, streakAtRisk: val),
                  priority: 'Normal',
                ),
                _buildToggleRow(
                  context,
                  ref,
                  'Streak milestone',
                  'Day of milestone (7, 14, 30, 60, 100)',
                  settings.streakMilestone,
                  (val) => _updateSettings(ref, user, streakMilestone: val),
                  priority: 'Low',
                ),
                _buildToggleRow(
                  context,
                  ref,
                  'Weekly review ready',
                  'Sunday evening after insights generation',
                  settings.weeklyReview,
                  (val) => _updateSettings(ref, user, weeklyReview: val),
                  priority: 'Low',
                ),
              ],
            ),
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Future<void> _updateSettings(
    WidgetRef ref,
    UserModel user, {
    bool? dueSoon,
    bool? overdue,
    bool? morningBriefing,
    bool? streakAtRisk,
    bool? streakMilestone,
    bool? weeklyReview,
    bool? eveningWrapUp,
  }) async {
    final current = user.notificationSettings;
    final newSettings = NotificationSettings(
      dueSoon: dueSoon ?? current.dueSoon,
      overdue: overdue ?? current.overdue,
      morningBriefing: morningBriefing ?? current.morningBriefing,
      streakAtRisk: streakAtRisk ?? current.streakAtRisk,
      streakMilestone: streakMilestone ?? current.streakMilestone,
      weeklyReview: weeklyReview ?? current.weeklyReview,
      eveningWrapUp: eveningWrapUp ?? current.eveningWrapUp,
    );

    await const Authenticator().updateNotificationSettings(newSettings.toMap());
  }

  Widget _buildToggleRow(
    BuildContext context,
    WidgetRef ref,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged, {
    String? priority,
  }) {
    final theme = Theme.of(context);
    Color priorityColor;
    switch (priority?.toLowerCase()) {
      case 'critical':
        priorityColor = Colors.red;
        break;
      case 'normal':
        priorityColor = Colors.orange;
        break;
      case 'low':
        priorityColor = Colors.blue;
        break;
      default:
        priorityColor = Colors.grey;
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space4),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.space4),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: AppRadius.borderRadiusLg,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: AppTypography.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      if (priority != null) ...[
                        const SizedBox(width: AppSpacing.space2),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: priorityColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                                color: priorityColor.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            priority.toUpperCase(),
                            style: AppTypography.label.copyWith(
                              fontSize: 8,
                              color: priorityColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    subtitle,
                    style: AppTypography.label.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeTrackColor: theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
