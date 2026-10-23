


import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../../core/models/movie.dart';
import '../../../core/state/reminder_controller.dart';
import '../../../core/state/user_controller.dart';
import '../../../core/utils/app_dates.dart';
import '../../../core/widgets/app_image.dart';
import '../../movie_details/movie_details_page.dart';

/// صف فيلم قادم (Coming Soon) — بيعرض تاريخ الإصدار الحقيقي وزر "Remind Me" شغال.
/// بيتستخدم في Home وفي صفحة الـ Calendar.
class ComingSoonTile extends StatelessWidget {
  const ComingSoonTile({super.key, required this.movie});

  final Movie movie;

  void _openDetails(BuildContext context) => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => MovieDetailsPage(movie: movie)),
      );

  void _toggleReminder(BuildContext context) {
    final alreadySet = ReminderController.instance.isSet(movie.id);
    if (!alreadySet && !UserController.instance.releaseReminders.value) {
      _showMessage(context, 'Turn on "Release reminders" in your Profile first.');
      return;
    }
    final nowOn = ReminderController.instance.toggle(movie.id);
    _showMessage(
      context,
      nowOn ? "We'll remind you when ${movie.title} is released." : 'Reminder removed.',
    );
  }

  void _showMessage(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.surfaceHigh,
        content: Text(text, style: AppText.body(12.5)),
      ));
  }

  @override
  Widget build(BuildContext context) {
    final date = movie.releaseDate;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => _openDetails(context),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                _Poster(movie: movie),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (date != null)
                        Row(
                          children: [
                            const Icon(Icons.schedule, size: 11, color: AppColors.textDim),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                '${AppDates.shortDate(date)} • ${AppDates.relative(date)}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppText.body(10.5, color: AppColors.textDim),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 3),
                      Text(movie.title, style: AppText.body(14, weight: FontWeight.w700)),
                      Text(movie.genre,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.body(10.5, color: AppColors.textMuted)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _RemindButton(
                            movieId: movie.id,
                            onTap: () => _toggleReminder(context),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => _openDetails(context),
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: const BoxDecoration(
                                  color: AppColors.surfaceHigh, shape: BoxShape.circle),
                              child: const Icon(Icons.info_outline,
                                  size: 14, color: AppColors.text),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Poster extends StatelessWidget {
  const _Poster({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 78,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AppImage(movie.posterAsset),
          ),
          if (movie.badge != null)
            Positioned(
              left: 4,
              bottom: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xCC000000),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(movie.badge!,
                    style: AppText.body(8.5,
                        color: Colors.white, weight: FontWeight.w700)),
              ),
            ),
        ],
      ),
    );
  }
}

class _RemindButton extends StatelessWidget {
  const _RemindButton({required this.movieId, required this.onTap});

  final String movieId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: ReminderController.instance.ids,
      builder: (_, ids, __) {
        final active = ids.contains(movieId);
        return GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: active
                  ? AppColors.primary.withOpacity(0.18)
                  : AppColors.surfaceHigh,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  active ? Icons.notifications_active : Icons.notifications_none,
                  size: 12,
                  color: active ? AppColors.primary : AppColors.text,
                ),
                const SizedBox(width: 4),
                Text(active ? 'Reminder set' : 'Remind Me',
                    style: AppText.body(10.5,
                        color: active ? AppColors.primary : AppColors.text,
                        weight: FontWeight.w600)),
              ],
            ),
          ),
        );
      },
    );
  }
}
