import 'package:flutter/material.dart';

import '../../../core/app_assets.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../../core/widgets/app_image.dart';

/// كارت "Never miss premiere night" في صفحة نسيان كلمة المرور.
class SecurityTipCard extends StatelessWidget {
  const SecurityTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: const SizedBox(
              width: 52,
              height: 62,
              child: AppImage(AppAssets.batman),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CINEMATIC SECURITY',
                    style: AppText.body(9.5,
                        color: AppColors.primary,
                        letterSpacing: 1,
                        weight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text('Never miss premiere night',
                    style: AppText.body(13.5, weight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text('Protect your AI-curated watchlist & tickets',
                    style: AppText.body(11, color: AppColors.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
