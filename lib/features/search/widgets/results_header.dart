
import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';

/// "Results · 24 found" + قائمة ترتيب منسدلة.
class ResultsHeader extends StatelessWidget {
  const ResultsHeader({
    super.key,
    required this.count,
    required this.sortBy,
    required this.onSortChanged,
  });

  final int count;
  final String sortBy;
  final ValueChanged<String> onSortChanged;

  static const sortOptions = ['Relevance', 'Top Rated', 'Newest', 'A-Z'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text('Results', style: AppText.heading(16, weight: FontWeight.w700)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.surfaceHigh,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('$count found',
                  style: AppText.body(11, color: AppColors.textMuted)),
            ),
          ],
        ),
        PopupMenuButton<String>(
          color: AppColors.surfaceHigh,
          onSelected: onSortChanged,
          itemBuilder: (_) => sortOptions
              .map((o) => PopupMenuItem(value: o, child: Text(o, style: AppText.body(13))))
              .toList(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star_border, size: 14, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(sortBy,
                  style: AppText.body(12.5,
                      color: AppColors.primary, weight: FontWeight.w600)),
              const Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.primary),
            ],
          ),
        ),
      ],
    );
  }
}
