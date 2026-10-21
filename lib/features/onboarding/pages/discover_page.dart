import 'package:flutter/material.dart';

import '../../../core/app_assets.dart';
import '../../../core/app_colors.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/motion.dart';
import '../../../core/widgets/pill_chip.dart';
import '../widgets/onboarding_text.dart';

/// الصفحة 1: كولاج بوسترات (بدون ميل) + Discover Your Next Favorite.
class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  static const _genres = [
    ('🍿', 'Blockbusters'),
    ('🌌', 'Mind-Bending Sci-Fi'),
    ('🕯️', 'Dark Thrillers'),
    ('🎭', 'Drama'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(child: _PosterCollage()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FadeSlideIn(
                child: PillChip(
                  label: 'Curated Intelligence',
                  showDot: true,
                  iconColor: AppColors.green,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 12),
              const OnboardingText(
                title: 'Discover Your\n',
                highlight: 'Next Favorite',
                description:
                    'Explore trending movies and TV shows and find something you’ll genuinely love watching tonight.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 38,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            scrollDirection: Axis.horizontal,
            itemCount: _genres.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) => Center(
              child: PillChip(
                label: '${_genres[i].$1}  ${_genres[i].$2}',
                foreground: AppColors.text,
                fontSize: 12,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// كولاج البوسترات: 3 أعمدة، كل عمود فيه كارتين متراكبين بإزاحة خفيفة،
/// وكارت "Trending #1" في النص أعلى شوية عن الباقي — مطابق لترتيب الصورة.
class _PosterCollage extends StatelessWidget {
  const _PosterCollage();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 44, 14, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _Poster(AppAssets.poster1, height: 148),
                      const SizedBox(height: 8),
                      _Poster(AppAssets.poster4, height: 110),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Transform.translate(
                    offset: const Offset(0, -18),
                    child: Column(
                      children: [
                        _Poster(AppAssets.poster2, height: 168,
                            badge: 'Trending #1'),
                        const SizedBox(height: 8),
                        _Poster(AppAssets.poster5, height: 96, label: 'MOVIES'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    children: [
                      _Poster(AppAssets.poster3, height: 118),
                      const SizedBox(height: 8),
                      _Poster(AppAssets.poster6, height: 142),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // تدرج يذوّب البوسترات في الخلفية من تحت
        const Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 110,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x00131318), AppColors.background],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Poster extends StatelessWidget {
  const _Poster(this.path, {required this.height, this.badge, this.label});

  final String path;
  final double height;
  final String? badge;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppImage(path),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [Color(0x00000000), Color(0x99000000)],
              ),
            ),
          ),
          if (badge != null)
            Positioned(
              top: 6,
              left: 6,
              child: PillChip(
                label: badge!,
                background: const Color(0xCC000000),
                foreground: AppColors.text,
                fontSize: 9,
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
              ),
            ),
          if (label != null)
            Positioned(
              left: 8,
              bottom: 6,
              child: Text(label!,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5)),
            ),
        ],
      ),
    );
  }
}
