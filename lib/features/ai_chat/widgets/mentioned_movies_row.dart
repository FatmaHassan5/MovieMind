import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../../core/data/movie_catalog.dart';
import '../../../core/models/movie.dart';
import '../../../core/widgets/app_image.dart';
import '../../movie_details/movie_details_page.dart';

/// بطاقات صغيرة للأفلام اللي اتذكرت في إجابة الـ AI — الضغط بيفتح التفاصيل.
class MentionedMoviesRow extends StatelessWidget {
  const MentionedMoviesRow({super.key, required this.ids});

  final List<String> ids;

  @override
  Widget build(BuildContext context) {
    final movies = ids.map(MovieCatalog.byId).whereType<Movie>().toList();
    if (movies.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 64,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final movie = movies[i];
          return GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => MovieDetailsPage(movie: movie)),
            ),
            child: Container(
              width: 190,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 38,
                      height: 52,
                      child: AppImage(movie.posterAsset),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(movie.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.body(12, weight: FontWeight.w700)),
                        Text(
                          [movie.year, if (movie.rating != null) '★ ${movie.rating}']
                              .where((s) => s.isNotEmpty)
                              .join('  •  '),
                          style: AppText.body(10.5, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
