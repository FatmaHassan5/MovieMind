import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../../core/widgets/pill_chip.dart';

/// محتوى تاب "Filter UI" — لوحة فلاتر مبسطة لمعاينة التصميم.
class FilterPanelView extends StatelessWidget {
  const FilterPanelView({super.key});

  static const _genres = ['Sci-Fi', 'Drama', 'Action', 'Thriller', 'Comedy'];
  static const _years = ['2024', '2020s', '2010s', '2000s', 'Classic'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Genre', style: AppText.body(13, weight: FontWeight.w700)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final g in _genres)
              PillChip(label: g, fontSize: 12, background: AppColors.surface),
          ],
        ),
        const SizedBox(height: 18),
        Text('Release Year', style: AppText.body(13, weight: FontWeight.w700)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final y in _years)
              PillChip(label: y, fontSize: 12, background: AppColors.surface),
          ],
        ),
        const SizedBox(height: 18),
        Text('Minimum Rating', style: AppText.body(13, weight: FontWeight.w700)),
        const SizedBox(height: 4),
        Slider(
          value: 7,
          min: 0,
          max: 10,
          divisions: 10,
          activeColor: AppColors.primary,
          inactiveColor: AppColors.surfaceHigh,
          label: '7.0+',
          onChanged: (_) {},
        ),
      ],
    );
  }
}
