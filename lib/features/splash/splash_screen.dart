
import 'package:flutter/material.dart';

import '../../core/app_assets.dart';
import '../../core/app_colors.dart';
import '../../core/app_theme.dart';
import '../../core/widgets/app_image.dart';
import '../../core/widgets/motion.dart';
import '../../core/widgets/pill_chip.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/cloud_sync_service.dart';
import '../main/main_shell.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const _targetProgress = 0.97;

  late final AnimationController _progress = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3200),
  );
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat(reverse: true);

  @override
  void initState() {
    super.initState();
    _progress.forward().whenComplete(_goNext);
  }

  Future<void> _goNext() async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    // لو المستخدم مسجّل دخوله من قبل: نحمّل بياناته من السحابة ونفتح التطبيق مباشرة.
    Widget next = const OnboardingScreen();
    final user = AuthService.instance.currentUser;
    if (user != null) {
      await CloudSyncService.instance.startForUser(user);
      next = const MainShell();
    }
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) => next,
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _progress.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.3),
            radius: 0.85,
            colors: [AppColors.glow, AppColors.background],
          ),
        ),
        child: Stack(
          children: [
            _Particles(animation: _pulse),
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const FadeSlideIn(
                    offset: Offset(0, -0.4),
                    child: PillChip(
                      label: 'CINEMATIC INTELLIGENCE',
                      icon: Icons.auto_awesome,
                      iconColor: AppColors.textDim,
                      foreground: AppColors.textDim,
                      background: Color(0x33FFFFFF),
                      fontSize: 11,
                      letterSpacing: 1.2,
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    ),
                  ),
                  const Spacer(flex: 3),
                  const _Logo(),
                  const SizedBox(height: 26),
                  const FadeSlideIn(
                    delay: Duration(milliseconds: 300),
                    child: _Brand(),
                  ),
                  const SizedBox(height: 8),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 450),
                    child: Text(
                      'DISCOVER  •  WATCH  •  ASK AI',
                      style: AppText.body(12,
                          color: AppColors.textMuted,
                          weight: FontWeight.w600,
                          letterSpacing: 2.6),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const FadeSlideIn(
                    delay: Duration(milliseconds: 600),
                    child: _FeatureChips(),
                  ),
                  const Spacer(flex: 3),
                  _ProgressSection(
                    animation: _progress,
                    target: _targetProgress,
                  ),
                  const Spacer(flex: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.7, end: 1),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutBack,
      builder: (_, v, child) => Opacity(
        opacity: v.clamp(0.0, 1.0),
        child: Transform.scale(scale: v, child: child),
      ),
      child: Container(
        width: 92,
        height: 92,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF29292E),
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
                color: Color(0x66000000), blurRadius: 24, offset: Offset(0, 10)),
          ],
        ),
        child: Container(
          width: 70,
          height: 70,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF17171C),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const AppImage(AppAssets.logo, fit: BoxFit.contain),
        ),
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: AppText.heading(36, weight: FontWeight.w700, letterSpacing: -1),
        children: const [
          TextSpan(text: 'Movie'),
          TextSpan(text: 'Mind', style: TextStyle(color: AppColors.accent)),
        ],
      ),
    );
  }
}

class _FeatureChips extends StatelessWidget {
  const _FeatureChips();

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF1E1E26);
    const pad = EdgeInsets.symmetric(horizontal: 12, vertical: 10);
    return const Wrap(
      spacing: 8,
      alignment: WrapAlignment.center,
      children: [
        PillChip(
          label: 'Smart Match',
          icon: Icons.movie_outlined,
          background: bg,
          foreground: AppColors.text,
          fontSize: 12,
          padding: pad,
        ),
        PillChip(
          label: 'Taste Neural',
          icon: Icons.psychology_outlined,
          iconColor: AppColors.green,
          background: bg,
          foreground: AppColors.text,
          fontSize: 12,
          padding: pad,
        ),
        PillChip(
          label: 'Film AI',
          icon: Icons.forum_outlined,
          iconColor: AppColors.accent,
          background: bg,
          foreground: AppColors.text,
          fontSize: 12,
          padding: pad,
        ),
      ],
    );
  }
}

class _ProgressSection extends StatelessWidget {
  const _ProgressSection({required this.animation, required this.target});

  final Animation<double> animation;
  final double target;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: AnimatedBuilder(
        animation: animation,
        builder: (_, __) {
          final value = Curves.easeInOut.transform(animation.value) * target;
          final done = animation.isCompleted;
          return Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 4,
                  color: const Color(0xFF2A2A33),
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: value,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(colors: [
                          AppColors.accent,
                          AppColors.primary,
                          AppColors.green,
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(done ? 'Ready' : 'Loading',
                      style: AppText.body(13, color: AppColors.textMuted)),
                  Text('${(value * 100).round()}%',
                      style: AppText.body(13,
                          color: AppColors.primary, weight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                        color: AppColors.green, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 9),
                  Text('V1.0.0 PRODUCTION BUILD',
                      style: AppText.body(11,
                          color: AppColors.textMuted, letterSpacing: 0.8)),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

/// نقط صغيرة في الخلفية بتنبض بهدوء.
class _Particles extends StatelessWidget {
  const _Particles({required this.animation});

  final Animation<double> animation;

  static const _dots = [
    (0.22, 0.12, 4.0),
    (0.85, 0.20, 5.0),
    (0.20, 0.27, 3.0),
    (0.87, 0.38, 3.0),
    (0.72, 0.48, 6.0),
    (0.30, 0.51, 3.0),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) => Stack(
        children: [
          for (final (x, y, size) in _dots)
            Align(
              alignment: Alignment(x * 2 - 1, y * 2 - 1),
              child: Opacity(
                opacity: 0.25 + animation.value * 0.35,
                child: Container(
                  width: size,
                  height: size,
                  decoration: const BoxDecoration(
                      color: AppColors.textDim, shape: BoxShape.circle),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
