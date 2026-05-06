import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../components/app_button.dart';
import '../components/app_state_views.dart';
import '../providers/auth_state_notifer.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import '../screens/account_settings_screen.dart';
import '../screens/notification_settings_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});
  static const routeName = '/profile';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: userAsync.when(
        data: (user) => Padding(
          padding: const EdgeInsets.all(AppSpacing.space6),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.space8),
              _buildProfileHeader(context, user),
              const SizedBox(height: AppSpacing.space8),
              _buildThemeToggle(context, ref),
              const SizedBox(height: AppSpacing.space4),
              _buildProfileOption(
                context: context,
                icon: Icons.person_outline,
                title: 'Account Settings',
                onTap: () => context.pushNamed(AccountSettingsScreen.routeName),
              ),
              _buildProfileOption(
                context: context,
                icon: Icons.notifications_none,
                title: 'Notifications',
                onTap: () =>
                    context.pushNamed(NotificationSettingsScreen.routeName),
              ),
              _buildProfileOption(
                context: context,
                icon: Icons.security,
                title: 'Privacy & Security',
                onTap: () {},
              ),
              _buildProfileOption(
                context: context,
                icon: Icons.help_outline,
                title: 'Help & Support',
                onTap: () {},
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Log Out',
                  variant: ButtonVariant.destructive,
                  size: ButtonSize.large,
                  onPressed: () async {
                    await ref.read(authStateNotifierProvider.notifier).logOut();
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.space8),
            ],
          ),
        ),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (err, stack) => AppErrorState(
          error: err.toString(),
          onRetry: () => ref.invalidate(userProfileProvider),
        ),
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space4, vertical: AppSpacing.space2),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.borderRadiusLg,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.space2),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: AppRadius.borderRadiusMd,
            ),
            child: Icon(
              isDark ? Icons.dark_mode : Icons.light_mode,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(width: AppSpacing.space4),
          Expanded(
            child: Text(
              'Dark Mode',
              style: AppTypography.body.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          Switch.adaptive(
            value: isDark,
            onChanged: (val) => ref.read(themeProvider.notifier).toggleTheme(),
            activeTrackColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, user) {
    final theme = Theme.of(context);
    final name = user?.displayName ?? 'User';
    final email = user?.email ?? '';
    final photoURL = user?.photoURL;

    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: theme.colorScheme.primary,
          backgroundImage: photoURL != null ? NetworkImage(photoURL) : null,
          child: photoURL == null
              ? Text(
                  name.isNotEmpty ? name[0].toUpperCase() : 'U',
                  style: TextStyle(
                      fontSize: 40,
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold),
                )
              : null,
        ),
        const SizedBox(height: AppSpacing.space4),
        Text(
          name,
          style: AppTypography.heading1.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        Text(
          email,
          style: AppTypography.body.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
        ),
      ],
    );
  }

  Widget _buildProfileOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space4),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(AppSpacing.space2),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: AppRadius.borderRadiusMd,
          ),
          child: Icon(icon,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
        ),
        title: Text(
          title,
          style: AppTypography.body.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        trailing: Icon(Icons.chevron_right,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusLg,
        ),
        tileColor: theme.colorScheme.surface,
      ),
    );
  }
}
