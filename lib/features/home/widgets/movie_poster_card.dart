// import 'package:flutter/material.dart';

// import '../../../core/app_colors.dart';
// import '../../../core/app_theme.dart';
// import '../../../core/widgets/app_image.dart';
// import '../../../core/widgets/match_badge.dart';
// import '../../../core/widgets/rating_badge.dart';
// import '../models/movie_summary.dart';

// /// كارت فيلم رأسي (مستخدم في Trending Now و Popular Movies).
// class MoviePosterCard extends StatefulWidget {
//   const MoviePosterCard({super.key, required this.movie, this.width = 150});

//   final MovieSummary movie;
//   final double width;

//   @override
//   State<MoviePosterCard> createState() => _MoviePosterCardState();
// }

// class _MoviePosterCardState extends State<MoviePosterCard> {
//   bool _saved = false;

//   @override
//   Widget build(BuildContext context) {
//     final m = widget.movie;
//     return SizedBox(
//       width: widget.width,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           AspectRatio(
//             aspectRatio: 2 / 3,
//             child: Stack(
//               fit: StackFit.expand,
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(16),
//                   child: AppImage(m.posterAsset),
//                 ),
//                 if (m.rating != null)
//                   Positioned(top: 7, left: 7, child: RatingBadge(rating: m.rating!)),
//                 Positioned(
//                   top: 7,
//                   right: 7,
//                   child: GestureDetector(
//                     onTap: () => setState(() => _saved = !_saved),
//                     child: Container(
//                       width: 26,
//                       height: 26,
//                       decoration: const BoxDecoration(
//                           color: Color(0x99000000), shape: BoxShape.circle),
//                       child: Icon(
//                         _saved ? Icons.favorite : Icons.favorite_border,
//                         size: 14,
//                         color: _saved ? AppColors.error : Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//                 if (m.matchPercent != null)
//                   Positioned(
//                     left: 7,
//                     bottom: 7,
//                     child: MatchBadge(percent: m.matchPercent!, dense: true),
//                   ),
//                 if (m.matchPercent != null)
//                   const Positioned(
//                     right: 7,
//                     bottom: 5,
//                     child: Icon(Icons.play_circle_fill,
//                         size: 24, color: Colors.white70),
//                   ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 7),
//           Text(m.title,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: AppText.body(13, weight: FontWeight.w700)),
//           Text('${m.year} • ${m.genre}',
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: AppText.body(11, color: AppColors.textMuted)),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../../core/models/movie.dart';
import '../../../core/state/watchlist_controller.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/match_badge.dart';
import '../../../core/widgets/rating_badge.dart';
import '../../movie_details/movie_details_page.dart';

/// كارت فيلم رأسي (مستخدم في Trending Now و Popular Movies).
/// الضغط على البوستر بيفتح شاشة التفاصيل، وأيقونة الحفظ بتضيفه للـ Watchlist.
class MoviePosterCard extends StatelessWidget {
  const MoviePosterCard({super.key, required this.movie, this.width = 150});

  final Movie movie;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => MovieDetailsPage(movie: movie)),
            ),
            child: AspectRatio(
              aspectRatio: 2 / 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AppImage(movie.posterAsset),
                  ),
                  if (movie.rating != null)
                    Positioned(
                        top: 7, left: 7, child: RatingBadge(rating: movie.rating!)),
                  Positioned(
                    top: 7,
                    right: 7,
                    child: ValueListenableBuilder<List<String>>(
                      valueListenable: WatchlistController.instance.ids,
                      builder: (_, ids, __) {
                        final saved = ids.contains(movie.id);
                        return GestureDetector(
                          onTap: () => WatchlistController.instance.toggle(movie.id),
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: const BoxDecoration(
                                color: Color(0x99000000), shape: BoxShape.circle),
                            child: Icon(
                              saved ? Icons.bookmark : Icons.bookmark_border,
                              size: 14,
                              color: saved ? AppColors.primary : Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (movie.matchPercent != null)
                    Positioned(
                      left: 7,
                      bottom: 7,
                      child: MatchBadge(percent: movie.matchPercent!, dense: true),
                    ),
                  if (movie.matchPercent != null)
                    const Positioned(
                      right: 7,
                      bottom: 5,
                      child: Icon(Icons.play_circle_fill,
                          size: 24, color: Colors.white70),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 7),
          Text(movie.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.body(13, weight: FontWeight.w700)),
          Text('${movie.year} • ${movie.genre}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.body(11, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
