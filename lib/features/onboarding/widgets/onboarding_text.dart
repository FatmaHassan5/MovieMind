import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../../core/widgets/motion.dart';

/// القسم النصي المشترك: عنوان + وصف (مع كلمة/سطر ملوّن اختياري).
class OnboardingText extends StatelessWidget {
  const OnboardingText({
    super.key,
    required this.title,
    this.highlight,
    required this.description,
    this.centered = false,
  });

  final String title;
  final String? highlight;
  final String description;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final align = centered ? TextAlign.center : TextAlign.start;
    return Column(
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        FadeSlideIn(
          delay: const Duration(milliseconds: 100),
          child: Text.rich(
            TextSpan(
              style: AppText.heading(25, height: 1.15, letterSpacing: -0.6),
              children: [
                TextSpan(text: title),
                if (highlight != null)
                  TextSpan(
                      text: highlight,
                      style: const TextStyle(color: AppColors.primary)),
              ],
            ),
            textAlign: align,
          ),
        ),
        const SizedBox(height: 8),
        FadeSlideIn(
          delay: const Duration(milliseconds: 220),
          child: Text(
            description,
            textAlign: align,
            style: AppText.body(14,
                color: AppColors.textMuted,
                weight: FontWeight.w400,
                height: 1.5),
          ),
        ),
      ],
    );
  }
}
