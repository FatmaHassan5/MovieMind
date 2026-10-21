import 'package:flutter/material.dart';

import '../../../core/app_assets.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../../core/widgets/app_image.dart';

/// الهيدر العلوي لصفحة "نسيت كلمة المرور": رجوع + لوجو + اسم + عنوان الصفحة + أفاتار.
class AuthTopBar extends StatelessWidget {
  const AuthTopBar({super.key, required this.pageTitle, required this.onBack});

  final String pageTitle;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 14, 0),
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
          const SizedBox(width: 8),
          Text('MovieMind', style: AppText.heading(15, weight: FontWeight.w700)),
          const Spacer(),
          Text(pageTitle,
              style: AppText.body(12, color: AppColors.textMuted)),
          const SizedBox(width: 12),
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
                color: AppColors.primary, shape: BoxShape.circle),
            child: const Icon(Icons.person_outline,
                color: AppColors.onPrimary, size: 17),
          ),
        ],
      ),
    );
  }
}
