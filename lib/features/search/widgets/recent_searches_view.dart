import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';

/// محتوى تاب "Recent" — قائمة عمليات البحث الأخيرة.
class RecentSearchesView extends StatelessWidget {
  const RecentSearchesView({super.key, required this.items, required this.onTap});

  final List<String> items;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Searches', style: AppText.heading(16, weight: FontWeight.w700)),
        const SizedBox(height: 12),
        for (final item in items)
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => onTap(item),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 11),
                child: Row(
                  children: [
                    const Icon(Icons.history, size: 17, color: AppColors.textDim),
                    const SizedBox(width: 12),
                    Expanded(child: Text(item, style: AppText.body(13.5))),
                    const Icon(Icons.north_west, size: 14, color: AppColors.textDim),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
