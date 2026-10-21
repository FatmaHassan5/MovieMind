import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/widgets/pill_chip.dart';

/// فلتر الفئة (All / Movies / TV Shows / People & Cast).
class CategoryFilterTabs extends StatelessWidget {
  const CategoryFilterTabs({super.key, required this.selected, required this.onChanged});

  final int selected;
  final ValueChanged<int> onChanged;

  static const _labels = ['All', 'Movies', 'TV Shows', 'People & Cast'];
  static const _icons = [Icons.auto_awesome, Icons.movie_outlined, Icons.tv, Icons.people_outline];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _labels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final active = i == selected;
          return GestureDetector(
            onTap: () => onChanged(i),
            child: PillChip(
              label: _labels[i],
              icon: _icons[i],
              fontSize: 12,
              background: active ? AppColors.primary : AppColors.surface,
              foreground: active ? AppColors.onPrimary : AppColors.text,
              iconColor: active ? AppColors.onPrimary : AppColors.textDim,
              weight: active ? FontWeight.w700 : FontWeight.w600,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            ),
          );
        },
      ),
    );
  }
}
