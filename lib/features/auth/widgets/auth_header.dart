


import 'package:flutter/material.dart';

import '../../../core/app_assets.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/motion.dart';

/// هيدر اللوجين والتسجيل: لوجو (بإضاءة خفيفة خلفه) + عنوان + وصف، الكل في النص.
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    // SizedBox بعرض كامل الشاشة، عشان الـ Column اللي جواه يقدر
    // يتوسط فعليًا بدل ما ينكمش على عرض أضيق عنصر جواه.
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.7, end: 1),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutBack,
            builder: (_, v, child) => Opacity(
              opacity: v.clamp(0.0, 1.0),
              child: Transform.scale(scale: v, child: child),
            ),
            child: SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // توهج بنفسجي خفيف خلف اللوجو.
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.accent.withOpacity(0.35),
                          AppColors.accent.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 66,
                    height: 66,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFF29292E),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.accent.withOpacity(0.3),
                            blurRadius: 26,
                            spreadRadius: 1),
                        const BoxShadow(
                            color: Color(0x55000000),
                            blurRadius: 18,
                            offset: Offset(0, 8)),
                      ],
                    ),
                    child: Container(
                      width: 50,
                      height: 50,
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: const Color(0xFF17171C),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const AppImage(AppAssets.logo, fit: BoxFit.contain),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          FadeSlideIn(
            delay: const Duration(milliseconds: 120),
            child: Text(title,
                textAlign: TextAlign.center,
                style: AppText.heading(24, weight: FontWeight.w700)),
          ),
          const SizedBox(height: 6),
          FadeSlideIn(
            delay: const Duration(milliseconds: 220),
            child: Text(subtitle,
                textAlign: TextAlign.center,
                style: AppText.body(13,
                    color: AppColors.textMuted, weight: FontWeight.w400)),
          ),
        ],
      ),
    );
  }
}
