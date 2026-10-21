import 'package:flutter/material.dart';

import '../../../core/app_assets.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../../core/widgets/app_image.dart';

/// الهيدر الثابت: رجوع + لوجو + اسم التطبيق + أيقونة البروفايل.
class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 12, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back, color: AppColors.text, size: 20),
          ),
          const SizedBox(width: 2),
          const SizedBox(
            width: 20,
            height: 20,
            child: AppImage(AppAssets.logo, fit: BoxFit.contain),
          ),
          const SizedBox(width: 7),
          Text('MovieMi…', style: AppText.heading(14, weight: FontWeight.w600)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Onboarding Taste\nProfile',
              style: AppText.body(11,
                  color: AppColors.textMuted, weight: FontWeight.w400, height: 1.2),
            ),
          ),
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
                color: AppColors.primary, shape: BoxShape.circle),
            child: const Icon(Icons.person_outline,
                color: AppColors.onPrimary, size: 19),
          ),
        ],
      ),
    );
  }
}
