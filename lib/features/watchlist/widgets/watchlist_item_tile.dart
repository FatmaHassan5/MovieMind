import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../../core/models/movie.dart';
import '../../../core/state/watchlist_controller.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/rating_badge.dart';
import '../../movie_details/movie_details_page.dart';

/// صف فيلم محفوظ في الـ Watchlist — بوستر + معلومات + checkbox "Mark watched"
/// + نسبة تطابق + زرار حذف. مطابق لتصميم شاشة My Watchlist.
class WatchlistItemTile extends StatelessWidget {
  const WatchlistItemTile({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => MovieDetailsPage(movie: movie)),
            ),
            child: SizedBox(
              width: 64,
              height: 92,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AppImage(movie.posterAsset),
                  ),
                  if (movie.rating != null)
                    Positioned(top: 5, left: 5, child: RatingBadge(rating: movie.rating!)),
                  if (movie.isTvShow)
                    Positioned(
                      left: 5,
                      bottom: 5,
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xCC000000),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text('TV',
                            style: AppText.body(8,
                                color: AppColors.primary, weight: FontWeight.w700)),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(movie.title,
                          style: AppText.body(14.5, weight: FontWeight.w700)),
                    ),
                    GestureDetector(
                      onTap: () => WatchlistController.instance.remove(movie.id),
                      child: const Icon(Icons.delete_outline,
                          size: 18, color: AppColors.textDim),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  [movie.year, movie.duration, movie.genre]
                      .whereType<String>()
                      .join(' • '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.body(10.5, color: AppColors.textDim),
                ),
                const SizedBox(height: 4),
                if (movie.description != null)
                  Text(
                    movie.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.body(11, color: AppColors.textMuted, height: 1.35),
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _MarkWatchedCheck(movieId: movie.id)),
                    if (movie.matchPercent != null) ...[
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                            color: AppColors.green, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 5),
                      Text('${movie.matchPercent}% Match',
                          style: AppText.body(10.5,
                              color: AppColors.green, weight: FontWeight.w700)),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MarkWatchedCheck extends StatelessWidget {
  const _MarkWatchedCheck({required this.movieId});

  final String movieId;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: WatchlistController.instance.watchedIds,
      builder: (_, watched, __) {
        final checked = watched.contains(movieId);
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => WatchlistController.instance.toggleWatched(movieId),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: checked ? AppColors.primary : Colors.transparent,
                  border: Border.all(
                      color: checked ? AppColors.primary : AppColors.textDim,
                      width: 1.3),
                ),
                child: checked
                    ? const Icon(Icons.check, size: 11, color: AppColors.onPrimary)
                    : null,
              ),
              const SizedBox(width: 6),
              Text('Mark watched',
                  style: AppText.body(10.5, color: AppColors.textMuted)),
            ],
          ),
        );
      },
    );
  }
}
