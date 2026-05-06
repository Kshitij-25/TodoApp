import 'dart:math' as math;
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/assets.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'main_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const routeName = '/splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _textFade;
  late Animation<double> _bgAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _logoScale = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.3, curve: Curves.easeIn),
      ),
    );

    _textFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.7, curve: Curves.easeIn),
      ),
    );

    _bgAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(milliseconds: 3500));
    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.go(MainScreen.routeName);
    } else {
      context.go(OnboardingScreen.routeName);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          // Animated Liquid Background
          AnimatedBuilder(
            animation: _bgAnimation,
            builder: (context, child) {
              return CustomPaint(
                painter: _LiquidBackgroundPainter(
                  _bgAnimation.value,
                  isDark: isDark,
                ),
                size: Size.infinite,
              );
            },
          ),

          // Glassmorphism Overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [
                            const Color(0xFF0F172A).withOpacity(0.8),
                            const Color(0xFF1E293B).withOpacity(0.8),
                          ]
                        : [
                            const Color(0xFFF8FAFC).withOpacity(0.8),
                            const Color(0xFFF1F5F9).withOpacity(0.8),
                          ],
                  ),
                ),
              ),
            ),
          ),

          // Content
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Glowing Logo
                    Opacity(
                      opacity: _logoFade.value,
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary
                                    .withOpacity(isDark ? 0.3 : 0.1),
                                blurRadius: 50,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.05),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.1)),
                            ),
                            child: Image.asset(
                              Assets.appLogo,
                              height: 100,
                              width: 100,
                              color: isDark ? Colors.white : null,
                              colorBlendMode: isDark ? BlendMode.srcIn : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Staggered Text
                    Opacity(
                      opacity: _textFade.value,
                      child: Column(
                        children: [
                          Text(
                            'TASKTRACKR',
                            style: AppTypography.display.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 8,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            height: 2,
                            width: 40,
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'ELEVATE YOUR PRODUCTIVITY',
                            style: AppTypography.label.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.5),
                              fontSize: 12,
                              letterSpacing: 4,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LiquidBackgroundPainter extends CustomPainter {
  _LiquidBackgroundPainter(this.animationValue, {required this.isDark});
  final double animationValue;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final primaryColor = AppColors.primary;

    // Draw background blobs
    _drawBlob(
        canvas,
        size,
        primaryColor.withOpacity(isDark ? 0.15 : 0.05),
        0.2 + 0.1 * math.sin(animationValue * 2 * math.pi),
        0.3 + 0.1 * math.cos(animationValue * 2 * math.pi),
        size.width * 0.4);

    _drawBlob(
        canvas,
        size,
        const Color(0xFF4F46E5).withOpacity(isDark ? 0.1 : 0.04),
        0.8 + 0.1 * math.cos(animationValue * 2 * math.pi),
        0.7 + 0.1 * math.sin(animationValue * 2 * math.pi),
        size.width * 0.5);

    _drawBlob(
        canvas,
        size,
        const Color(0xFF7C3AED).withOpacity(isDark ? 0.12 : 0.06),
        0.5 + 0.2 * math.sin(animationValue * math.pi),
        0.2 + 0.2 * math.cos(animationValue * math.pi),
        size.width * 0.3);
  }

  void _drawBlob(Canvas canvas, Size size, Color color, double xFactor,
      double yFactor, double radius) {
    final paint = Paint()..color = color;
    canvas.drawCircle(
      Offset(size.width * xFactor, size.height * yFactor),
      radius,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _LiquidBackgroundPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
