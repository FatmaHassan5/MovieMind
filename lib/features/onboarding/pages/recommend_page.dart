import 'package:flutter/material.dart';

import '../../../core/app_assets.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/motion.dart';
import '../../../core/widgets/pill_chip.dart';
import '../widgets/onboarding_text.dart';

/// الصفحة 2: كروت التوصيات (Inception / Arrival / Batman).
class RecommendPage extends StatelessWidget {
  const RecommendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        children: [
          const Expanded(child: Center(child: _CardsStack())),
          const FadeSlideIn(
            child: PillChip(
              label: 'SMART DISCOVERY',
              icon: Icons.tune,
              letterSpacing: 0.8,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 12),
          const OnboardingText(
            title: 'Recommendations Made\nFor You',
            description:
                'Find movies that match your taste, mood, and favorite genres with personalized curation.',
            centered: true,
          ),
        ],
      ),
    );
  }
}

class _CardsStack extends StatelessWidget {
  const _CardsStack();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: const [
          Positioned(left: -6, top: 18, child: _SideCard(
            path: AppAssets.inception,
            title: 'Inception',
            badge: '94%',
            angle: -0.08,
            left: true,
          )),
          Positioned(right: -6, top: 0, child: _SideCard(
            path: AppAssets.batman,
            title: 'Batman',
            badge: 'Neo-Noir',
            angle: 0.08,
            left: false,
          )),
          _CenterCard(),
          Positioned(right: 2, bottom: 2, child: _SyncedTag()),
        ],
      ),
    );
  }
}

class _CenterCard extends StatelessWidget {
  const _CenterCard();

  @override
  Widget build(BuildContext context) {
    return Floating(
      amplitude: 4,
      child: Container(
        width: 122,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.surfaceHigh,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Color(0x88000000), blurRadius: 24, offset: Offset(0, 10)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const PillChip(
              label: '98% AI Match',
              icon: Icons.auto_awesome,
              background: AppColors.surfaceHigh,
              fontSize: 10,
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: 138,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: const AppImage(AppAssets.arrival),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                      gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x00000000), Color(0xCC000000)],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                          color: Color(0x99000000), shape: BoxShape.circle),
                      child: const Icon(Icons.bookmark_border,
                          color: Colors.white, size: 14),
                    ),
                  ),
                  Positioned(
                    left: 8,
                    bottom: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Arrival',
                            style: AppText.body(13, weight: FontWeight.w700)),
                        Text('Atmospheric Sci-Fi',
                            style: AppText.body(9,
                                color: AppColors.textMuted,
                                weight: FontWeight.w400)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(3, 6, 3, 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                            color: AppColors.green, shape: BoxShape.circle)),
                    const SizedBox(width: 4),
                    Text('Sci-Fi Affinity',
                        style: AppText.body(8, color: AppColors.textMuted)),
                  ]),
                  Text('Top Pick',
                      style: AppText.body(9,
                          color: AppColors.green, weight: FontWeight.w700)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SideCard extends StatelessWidget {
  const _SideCard({
    required this.path,
    required this.title,
    required this.badge,
    required this.angle,
    required this.left,
  });

  final String path;
  final String title;
  final String badge;
  final double angle;
  final bool left;

  @override
  Widget build(BuildContext context) {
    return Floating(
      amplitude: 3,
      duration: Duration(milliseconds: left ? 3000 : 2300),
      child: Transform.rotate(
        angle: angle,
        child: Container(
          width: 84,
          height: 132,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AppImage(path),
              ),
              Positioned(
                left: 6,
                bottom: 6,
                child: Text(title,
                    style: AppText.body(11, weight: FontWeight.w700)),
              ),
              if (left)
                Positioned(
                  left: 2,
                  bottom: -12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B3A34),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(badge,
                        style: AppText.body(10,
                            color: AppColors.green, weight: FontWeight.w700)),
                  ),
                ),
              if (!left)
                const Positioned(
                  top: 6,
                  right: 6,
                  child: Icon(Icons.favorite_border, color: Colors.white, size: 14),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SyncedTag extends StatelessWidget {
  const _SyncedTag();

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.06,
      child: const PillChip(
        label: 'Taste Profile Synced',
        icon: Icons.psychology_outlined,
        iconColor: AppColors.green,
        foreground: AppColors.text,
        background: AppColors.surfaceHigh,
        fontSize: 10,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      ),
    );
  }
}
