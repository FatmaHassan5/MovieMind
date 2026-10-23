

import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';

/// هيدر قسم (زي "Trending Now" / "Popular Movies") مع رابط "See all" يمين.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.icon,
    required this.title,
    this.actionLabel = 'See all',
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 7),
            Text(title, style: AppText.heading(16, weight: FontWeight.w700)),
          ],
        ),
        if (actionLabel != null)
          GestureDetector(
          onTap: onAction,
          child: Row(
            children: [
              Text(actionLabel!,
                  style: AppText.body(12.5,
                      color: AppColors.primary, weight: FontWeight.w600)),
              const Icon(Icons.chevron_right, size: 16, color: AppColors.primary),
            ],
          ),
        ),
      ],
    );
  }
}
