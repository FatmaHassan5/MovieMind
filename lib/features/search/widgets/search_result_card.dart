// import 'package:flutter/material.dart';

// import '../../../core/app_colors.dart';
// import '../../../core/app_theme.dart';
// import '../../../core/widgets/app_image.dart';
// import '../../../core/widgets/match_badge.dart';
// import '../../../core/widgets/rating_badge.dart';
// import '../models/search_result.dart';

// /// كارت نتيجة بحث (Grid، عمودين) — بوستر + تقييم + نسبة تطابق + عنوان.
// class SearchResultCard extends StatefulWidget {
//   const SearchResultCard({super.key, required this.result});

//   final SearchResult result;

//   @override
//   State<SearchResultCard> createState() => _SearchResultCardState();
// }

// class _SearchResultCardState extends State<SearchResultCard> {
//   bool _saved = false;

//   @override
//   Widget build(BuildContext context) {
//     final r = widget.result;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         AspectRatio(
//           aspectRatio: 1,
//           child: Stack(
//             fit: StackFit.expand,
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(16),
//                 child: AppImage(r.posterAsset),
//               ),
//               Positioned(top: 7, left: 7, child: RatingBadge(rating: r.rating)),
//               Positioned(
//                 top: 7,
//                 right: 7,
//                 child: GestureDetector(
//                   onTap: () => setState(() => _saved = !_saved),
//                   child: Container(
//                     width: 26,
//                     height: 26,
//                     decoration: const BoxDecoration(
//                         color: Color(0x99000000), shape: BoxShape.circle),
//                     child: Icon(
//                       _saved ? Icons.bookmark : Icons.bookmark_border,
//                       size: 14,
//                       color: _saved ? AppColors.primary : Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 left: 7,
//                 right: 7,
//                 bottom: 7,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     MatchBadge(percent: r.matchPercent, dense: true),
//                     Text(r.year,
//                         style: AppText.body(10.5,
//                             color: Colors.white, weight: FontWeight.w600)),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 7),
//         Text(r.title,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: AppText.body(13, weight: FontWeight.w700)),
//         Text(r.genre,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: AppText.body(10.5, color: AppColors.textMuted)),
//         const SizedBox(height: 4),
//         Row(
//           children: [
//             Expanded(
//               child: Text(r.badge,
//                   style: AppText.body(10, color: AppColors.textDim)),
//             ),
//             GestureDetector(
//               onTap: () => setState(() => _saved = !_saved),
//               child: Icon(
//                 _saved ? Icons.bookmark : Icons.bookmark_border,
//                 size: 15,
//                 color: _saved ? AppColors.primary : AppColors.textDim,
//               ),
//             ),
//           ],
//         ),
//       ],
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

/// كارت نتيجة بحث (Grid، عمودين) — بوستر + تقييم + نسبة تطابق + عنوان.
/// الضغط على الكارت بيفتح التفاصيل، وأيقونة الـ bookmark بتضيف/تشيل
/// الفيلم من الـ Watchlist فعليًا.
class SearchResultCard extends StatelessWidget {
  const SearchResultCard({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => MovieDetailsPage(movie: movie)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
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
                  child: _BookmarkButton(movieId: movie.id),
                ),
                Positioned(
                  left: 7,
                  right: 7,
                  bottom: 7,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (movie.matchPercent != null)
                        MatchBadge(percent: movie.matchPercent!, dense: true)
                      else
                        const SizedBox.shrink(),
                      Text(movie.year,
                          style: AppText.body(10.5,
                              color: Colors.white, weight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 7),
          Text(movie.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.body(13, weight: FontWeight.w700)),
          Text(movie.genre,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.body(10.5, color: AppColors.textMuted)),
          const SizedBox(height: 4),
          Text(movie.badge ?? movie.duration ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.body(10, color: AppColors.textDim)),
        ],
      ),
    );
  }
}

class _BookmarkButton extends StatelessWidget {
  const _BookmarkButton({required this.movieId});

  final String movieId;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<String>>(
      valueListenable: WatchlistController.instance.ids,
      builder: (_, ids, __) {
        final saved = ids.contains(movieId);
        return GestureDetector(
          onTap: () => WatchlistController.instance.toggle(movieId),
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
    );
  }
}
