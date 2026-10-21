import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../../core/data/movie_catalog.dart';
import '../../../core/models/movie.dart';
import '../../../core/state/watchlist_controller.dart';
import '../../../core/utils/duration_utils.dart';

/// 3 إحصائيات حقيقية: عدد المحفوظ، عدد اللي اتشاف، وإجمالي ساعات المشاهدة.
class ProfileStatsRow extends StatelessWidget {
  const ProfileStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<String>>(
      valueListenable: WatchlistController.instance.ids,
      builder: (_, savedIds, __) => ValueListenableBuilder<Set<String>>(
        valueListenable: WatchlistController.instance.watchedIds,
        builder: (_, watchedIds, __) {
          final watched =
              watchedIds.map(MovieCatalog.byId).whereType<Movie>().toList();
          return Row(
            children: [
              _StatCard(
                  icon: Icons.bookmark_border,
                  value: '${savedIds.length}',
                  label: 'Saved'),
              const SizedBox(width: 10),
              _StatCard(
                  icon: Icons.check_circle_outline,
                  value: '${watched.length}',
                  label: 'Watched'),
              const SizedBox(width: 10),
              _StatCard(
                  icon: Icons.schedule,
                  value: '${DurationUtils.totalHours(watched)}h',
                  label: 'Watch time'),
            ],
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.icon, required this.value, required this.label});

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(value, style: AppText.heading(20, weight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(label, style: AppText.body(11, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}
