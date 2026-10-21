// import 'package:flutter/material.dart';

// import '../../../core/app_colors.dart';
// import '../../../core/app_theme.dart';
// import '../../../core/widgets/app_image.dart';
// import '../../../core/widgets/rating_badge.dart';
// import '../models/chat_message.dart';

// /// كارت توصية فيلم داخل رد الـ AI: بوستر + تقييم + سبب الترشيح + أزرار إجراء.
// class AiRecommendationCard extends StatefulWidget {
//   const AiRecommendationCard({
//     super.key,
//     required this.recommendation,
//     this.onViewDetails,
//     this.onWatchlist,
//   });

//   final AiRecommendation recommendation;
//   final VoidCallback? onViewDetails;
//   final VoidCallback? onWatchlist;

//   @override
//   State<AiRecommendationCard> createState() => _AiRecommendationCardState();
// }

// class _AiRecommendationCardState extends State<AiRecommendationCard> {
//   bool _liked = false;

//   @override
//   Widget build(BuildContext context) {
//     final r = widget.recommendation;
//     return Container(
//       margin: const EdgeInsets.only(bottom: 14),
//       decoration: BoxDecoration(
//         color: AppColors.surface,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       clipBehavior: Clip.antiAlias,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           AspectRatio(
//             aspectRatio: 16 / 9,
//             child: Stack(
//               fit: StackFit.expand,
//               children: [
//                 AppImage(r.posterAsset),
//                 const DecoratedBox(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [Color(0x00000000), Color(0xCC000000)],
//                     ),
//                   ),
//                 ),
//                 Positioned(top: 8, left: 8, child: RatingBadge(rating: r.rating)),
//                 Positioned(
//                   top: 8,
//                   left: 54,
//                   child: _Chip(label: r.year, dark: true),
//                 ),
//                 Positioned(top: 8, right: 8, child: _Chip(label: r.runtimeOrQuality)),
//                 Positioned(
//                   left: 12,
//                   bottom: 10,
//                   right: 12,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(r.title,
//                           style: AppText.body(17, weight: FontWeight.w700)),
//                       Text(r.genre,
//                           style: AppText.body(11.5, color: AppColors.textMuted)),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: AppColors.surfaceHigh,
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Icon(Icons.hub_outlined, size: 15, color: AppColors.primary),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text.rich(
//                           TextSpan(
//                             style: AppText.body(11.5,
//                                 color: AppColors.textMuted, height: 1.4),
//                             children: [
//                               const TextSpan(
//                                   text: 'AI Match Justification: ',
//                                   style: TextStyle(
//                                       color: AppColors.text, fontWeight: FontWeight.w700)),
//                               TextSpan(text: r.justification),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   children: [
//                     Expanded(
//                       flex: 3,
//                       child: _ActionButton(
//                         label: 'View Details',
//                         icon: Icons.visibility_outlined,
//                         filled: true,
//                         onTap: widget.onViewDetails,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       flex: 3,
//                       child: _ActionButton(
//                         label: 'Watchlist',
//                         icon: Icons.bookmark_add_outlined,
//                         onTap: widget.onWatchlist,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     GestureDetector(
//                       onTap: () => setState(() => _liked = !_liked),
//                       child: Container(
//                         width: 38,
//                         height: 38,
//                         decoration: BoxDecoration(
//                           color: AppColors.surfaceHigh,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Icon(
//                           _liked ? Icons.favorite : Icons.favorite_border,
//                           size: 17,
//                           color: _liked ? AppColors.error : AppColors.text,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _Chip extends StatelessWidget {
//   const _Chip({required this.label, this.dark = false});

//   final String label;
//   final bool dark;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
//       decoration: BoxDecoration(
//         color: dark ? const Color(0xCC000000) : const Color(0xCC17342C),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Text(label,
//           style: AppText.body(10,
//               color: dark ? Colors.white : AppColors.green, weight: FontWeight.w700)),
//     );
//   }
// }

// class _ActionButton extends StatelessWidget {
//   const _ActionButton({
//     required this.label,
//     required this.icon,
//     required this.onTap,
//     this.filled = false,
//   });

//   final String label;
//   final IconData icon;
//   final VoidCallback? onTap;
//   final bool filled;

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: filled ? AppColors.primary : AppColors.surfaceHigh,
//       borderRadius: BorderRadius.circular(12),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: onTap,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 10),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, size: 14, color: filled ? AppColors.onPrimary : AppColors.text),
//               const SizedBox(width: 6),
//               Text(label,
//                   style: AppText.body(11.5,
//                       color: filled ? AppColors.onPrimary : AppColors.text,
//                       weight: FontWeight.w700)),
//             ],
//           ),
//         ),
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
import '../../../core/widgets/rating_badge.dart';
import '../../movie_details/movie_details_page.dart';

/// كارت توصية فيلم داخل رد الـ AI: بوستر + تقييم + سبب الترشيح + أزرار إجراء.
/// "View Details" بيفتح شاشة التفاصيل، و"Watchlist" بيضيف/يشيل فعليًا.
class AiRecommendationCard extends StatefulWidget {
  const AiRecommendationCard({
    super.key,
    required this.movie,
    required this.justification,
  });

  final Movie movie;
  final String justification;

  @override
  State<AiRecommendationCard> createState() => _AiRecommendationCardState();
}

class _AiRecommendationCardState extends State<AiRecommendationCard> {
  bool _liked = false;

  @override
  Widget build(BuildContext context) {
    final m = widget.movie;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => MovieDetailsPage(movie: m)),
            ),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AppImage(m.posterAsset),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x00000000), Color(0xCC000000)],
                      ),
                    ),
                  ),
                  if (m.rating != null)
                    Positioned(top: 8, left: 8, child: RatingBadge(rating: m.rating!)),
                  Positioned(top: 8, left: 54, child: _Chip(label: m.year, dark: true)),
                  if (m.duration != null)
                    Positioned(top: 8, right: 8, child: _Chip(label: m.duration!)),
                  Positioned(
                    left: 12,
                    bottom: 10,
                    right: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m.title, style: AppText.body(17, weight: FontWeight.w700)),
                        Text(m.genre,
                            style: AppText.body(11.5, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHigh,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.hub_outlined, size: 15, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            style: AppText.body(11.5,
                                color: AppColors.textMuted, height: 1.4),
                            children: [
                              const TextSpan(
                                  text: 'AI Match Justification: ',
                                  style: TextStyle(
                                      color: AppColors.text, fontWeight: FontWeight.w700)),
                              TextSpan(text: widget.justification),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _ActionButton(
                        label: 'View Details',
                        icon: Icons.visibility_outlined,
                        filled: true,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => MovieDetailsPage(movie: m)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: ValueListenableBuilder<List<String>>(
                        valueListenable: WatchlistController.instance.ids,
                        builder: (_, ids, __) {
                          final saved = ids.contains(m.id);
                          return _ActionButton(
                            label: saved ? 'In Watchlist' : 'Watchlist',
                            icon: saved ? Icons.bookmark : Icons.bookmark_add_outlined,
                            onTap: () => WatchlistController.instance.toggle(m.id),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => setState(() => _liked = !_liked),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceHigh,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _liked ? Icons.favorite : Icons.favorite_border,
                          size: 17,
                          color: _liked ? AppColors.error : AppColors.text,
                        ),
                      ),
                    ),
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

class _Chip extends StatelessWidget {
  const _Chip({required this.label, this.dark = false});

  final String label;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: dark ? const Color(0xCC000000) : const Color(0xCC17342C),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label,
          style: AppText.body(10,
              color: dark ? Colors.white : AppColors.green, weight: FontWeight.w700)),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.filled = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? AppColors.primary : AppColors.surfaceHigh,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: filled ? AppColors.onPrimary : AppColors.text),
              const SizedBox(width: 6),
              Text(label,
                  style: AppText.body(11.5,
                      color: filled ? AppColors.onPrimary : AppColors.text,
                      weight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}
