import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants/assets.dart';
import '../../data/models/login_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../providers/auth_state_notifer.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});
  static const routeName = '/login';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(authStateNotifierProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Listen for login errors
    ref.listen(authStateNotifierProvider, (previous, next) {
      if (next == LoginState.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Login failed. Please check your SHA-1 configuration.'),
            backgroundColor: AppColors.danger,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          // Dynamic Background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          const Color(0xFF0F172A), // Slate 900
                          const Color(0xFF1E293B), // Slate 800
                          const Color(0xFF0F172A),
                        ]
                      : [
                          const Color(0xFFF8FAFC), // Slate 50
                          const Color(0xFFF1F5F9), // Slate 100
                          const Color(0xFFF8FAFC),
                        ],
                ),
              ),
            ),
          ),

          // Subtle accent glows
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(isDark ? 0.15 : 0.08),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.space8),
              child: Column(
                children: [
                  const Spacer(),

                  // Header Section
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(seconds: 1),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.space6),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSurface.withOpacity(0.05),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.1)),
                          ),
                          child: Image.asset(
                            Assets.appLogo,
                            height: 64,
                            width: 64,
                            color: isDark ? Colors.white : null,
                            colorBlendMode: isDark ? BlendMode.srcIn : null,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.space8),
                        Text(
                          'Welcome Back',
                          textAlign: TextAlign.center,
                          style: AppTypography.display.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.space2),
                        Text(
                          'Sign in to sync your productivity',
                          textAlign: TextAlign.center,
                          style: AppTypography.body.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.space12),

                  // Login Card (Glassmorphism)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.space8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onSurface.withOpacity(0.03),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.1)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildGoogleButton(context, ref, loginState),
                            const SizedBox(height: AppSpacing.space6),
                            Text(
                              'Secure one-tap authentication',
                              style: AppTypography.label.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.3),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Footer
                  Text(
                    'By continuing, you agree to our\nTerms of Service and Privacy Policy',
                    textAlign: TextAlign.center,
                    style: AppTypography.label.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.3),
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.space8),
                ],
              ),
            ),
          ),

          // Loading Overlay
          if (loginState == LoginState.loading)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: ColoredBox(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGoogleButton(
      BuildContext context, WidgetRef ref, LoginState state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: state == LoginState.loading
            ? null
            : () =>
                ref.read(authStateNotifierProvider.notifier).loginWithGoogle(),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.space4),
          decoration: BoxDecoration(
            color: isDark ? Colors.white : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(24),
            border: isDark
                ? null
                : Border.all(color: Colors.black.withOpacity(0.05)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                'https://www.gstatic.com/images/branding/product/2x/googleg_48dp.png',
                height: 24,
                width: 24,
              ),
              const SizedBox(width: AppSpacing.space4),
              Text(
                'Continue with Google',
                style: TextStyle(
                  color: isDark ? Colors.black : Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
