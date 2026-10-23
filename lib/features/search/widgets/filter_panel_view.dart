
import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../../core/utils/taste_utils.dart';
import '../../../core/widgets/pill_chip.dart';

/// لوحة الفلاتر: تصنيفات (متعددة)، فترة الإصدار، وأقل تقييم. بتتطبق على نتايج البحث.
class FilterPanelView extends StatelessWidget {
  const FilterPanelView({
    super.key,
    required this.genres,
    required this.era,
    required this.minRating,
    required this.onToggleGenre,
    required this.onEraChanged,
    required this.onRatingChanged,
    required this.onReset,
  });

  final Set<String> genres;
  final String? era;
  final double minRating;
  final ValueChanged<String> onToggleGenre;
  final ValueChanged<String?> onEraChanged;
  final ValueChanged<double> onRatingChanged;
  final VoidCallback onReset;

  static const eras = ['2020s', '2010s', '2000s', 'Classic'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Genre', style: AppText.body(13, weight: FontWeight.w700)),
            GestureDetector(
              onTap: onReset,
              child: Text('Reset',
                  style: AppText.body(12.5,
                      color: AppColors.primary, weight: FontWeight.w600)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final g in TasteUtils.genres)
              GestureDetector(
                onTap: () => onToggleGenre(g),
                child: _chip(g, genres.contains(g)),
              ),
          ],
        ),
        const SizedBox(height: 18),
        Text('Release Era', style: AppText.body(13, weight: FontWeight.w700)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final e in eras)
              GestureDetector(
                onTap: () => onEraChanged(era == e ? null : e),
                child: _chip(e, era == e),
              ),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          minRating <= 0 ? 'Minimum Rating' : 'Minimum Rating · ${minRating.toStringAsFixed(1)}+',
          style: AppText.body(13, weight: FontWeight.w700),
        ),
        Slider(
          value: minRating,
          min: 0,
          max: 9,
          divisions: 18,
          activeColor: AppColors.primary,
          inactiveColor: AppColors.surfaceHigh,
          label: minRating.toStringAsFixed(1),
          onChanged: onRatingChanged,
        ),
      ],
    );
  }

  Widget _chip(String label, bool selected) => PillChip(
        label: label,
        fontSize: 12,
        background: selected ? AppColors.primary : AppColors.surface,
        foreground: selected ? AppColors.onPrimary : AppColors.text,
        weight: selected ? FontWeight.w700 : FontWeight.w600,
      );
}
