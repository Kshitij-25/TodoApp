import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_motion.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../components/app_button.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  static const routeName = '/onboarding';

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Stay on top of\neverything',
      description:
          'Capture tasks instantly, organize by priority, and never miss a deadline again.',
      color: AppColors.primary,
      icon: Icons.check_circle_outline,
      buttonText: 'Get Started',
    ),
    OnboardingData(
      title: 'Smart reminders\nthat fit your life',
      description:
          'Set reminders by time or location. TaskTrackr nudges you at just the right moment.',
      color: AppColors.accent,
      icon: Icons.alarm,
      buttonText: 'Continue',
    ),
    OnboardingData(
      title: 'Build powerful\nhabits',
      description:
          'Track streaks, earn rewards, and watch your productivity soar week after week.',
      color: AppColors.success,
      icon: Icons.local_fire_department,
      buttonText: 'Start for free',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => context.goNamed(LoginScreen.routeName),
                child: Text(
                  'Skip',
                  style: AppTypography.label.copyWith(
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.4)),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _OnboardingPage(data: _pages[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.space6),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, _buildDot),
                  ),
                  const SizedBox(height: AppSpacing.space8),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      text: _pages[_currentPage].buttonText,
                      size: ButtonSize.large,
                      onPressed: () {
                        if (_currentPage < _pages.length - 1) {
                          _pageController.nextPage(
                            duration: AppMotion.normal,
                            curve: AppMotion.easeSmooth,
                          );
                        } else {
                          context.goNamed(LoginScreen.routeName);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: AppMotion.fast,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 6,
      width: _currentPage == index ? 24 : 6,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? _pages[_currentPage].color
            : theme.colorScheme.onSurface.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class OnboardingData {
  OnboardingData({
    required this.title,
    required this.description,
    required this.color,
    required this.icon,
    required this.buttonText,
  });
  final String title;
  final String description;
  final Color color;
  final IconData icon;
  final String buttonText;
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.data});
  final OnboardingData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.space6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.space8),
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: 0.1),
              borderRadius: AppRadius.borderRadiusXl,
            ),
            child: Icon(data.icon, size: 80, color: data.color),
          ),
          const SizedBox(height: AppSpacing.space12),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: AppTypography.display.copyWith(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.space4),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: AppTypography.body.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
