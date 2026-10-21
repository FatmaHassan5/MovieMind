import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';

/// محتوى تاب "Empty" — حالة عدم وجود نتائج.
class EmptyResultsView extends StatelessWidget {
  const EmptyResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
                color: AppColors.surface, shape: BoxShape.circle),
            child: const Icon(Icons.search_off,
                size: 30, color: AppColors.textDim),
          ),
          const SizedBox(height: 16),
          Text('No results found',
              style: AppText.heading(16, weight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text('Try a different title, actor, or genre.',
              style: AppText.body(12.5, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
