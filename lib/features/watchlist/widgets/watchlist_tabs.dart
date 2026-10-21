import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/widgets/pill_chip.dart';

enum WatchlistFilter { all, movies, tvShows }

/// تابات All / Movies / TV Shows مع عدد كل فئة.
class WatchlistTabs extends StatelessWidget {
  const WatchlistTabs({
    super.key,
    required this.value,
    required this.onChanged,
    required this.allCount,
    required this.moviesCount,
    required this.tvCount,
  });

  final WatchlistFilter value;
  final ValueChanged<WatchlistFilter> onChanged;
  final int allCount;
  final int moviesCount;
  final int tvCount;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (WatchlistFilter.all, 'All ($allCount)'),
      (WatchlistFilter.movies, 'Movies ($moviesCount)'),
      (WatchlistFilter.tvShows, 'TV Shows ($tvCount)'),
    ];
    return Row(
      children: [
        for (final (filter, label) in tabs) ...[
          GestureDetector(
            onTap: () => onChanged(filter),
            child: PillChip(
              label: label,
              fontSize: 12.5,
              background: value == filter ? AppColors.primary : AppColors.surface,
              foreground: value == filter ? AppColors.onPrimary : AppColors.text,
              weight: value == filter ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ],
    );
  }
}
