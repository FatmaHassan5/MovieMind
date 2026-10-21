import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_theme.dart';
import '../../core/models/movie.dart';
import '../../core/widgets/app_image.dart';
import '../../core/widgets/match_badge.dart';
import '../../core/widgets/pill_chip.dart';
import 'widgets/details_action_bar.dart';

/// شاشة تفاصيل الفيلم — بتتفتح لما تدوسي على أي بوستر في أي شاشة
/// (Home, Search, Watchlist).
class MovieDetailsPage extends StatelessWidget {
  const MovieDetailsPage({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _Poster(movie: movie)),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: AppText.heading(24, weight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  _MetaRow(movie: movie),
                  if (movie.matchPercent != null) ...[
                    const SizedBox(height: 12),
                    MatchBadge(percent: movie.matchPercent!),
                  ],
                  const SizedBox(height: 18),
                  Text('Overview', style: AppText.body(14, weight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(
                    movie.description ?? 'No description available yet.',
                    style: AppText.body(13.5, color: AppColors.textMuted, height: 1.6),
                  ),
                  const SizedBox(height: 26),
                  DetailsActionBar(movieId: movie.id),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Poster extends StatelessWidget {
  const _Poster({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppImage(movie.posterAsset),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x00000000), AppColors.background],
                stops: [0.5, 1],
              ),
            ),
          ),
          Positioned(
            top: 14,
            left: 14,
            child: SafeArea(
              bottom: false,
              child: GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                      color: Color(0x99000000), shape: BoxShape.circle),
                  child: const Icon(Icons.arrow_back, color: Colors.white, size: 19),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (movie.rating != null)
          PillChip(
            label: movie.rating!,
            icon: Icons.star,
            iconColor: const Color(0xFFFFC64B),
            background: AppColors.surface,
            fontSize: 12,
          ),
        PillChip(label: movie.year, background: AppColors.surface, fontSize: 12),
        if (movie.duration != null)
          PillChip(label: movie.duration!, background: AppColors.surface, fontSize: 12),
        if (movie.badge != null)
          PillChip(label: movie.badge!, background: AppColors.surface, fontSize: 12),
        PillChip(label: movie.genre, background: AppColors.surface, fontSize: 12),
      ],
    );
  }
}
