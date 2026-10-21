import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_theme.dart';

/// سطر أسفل الصفحة: نص عادي + رابط ملون (Create Account / Log In / Back to Login).
class BottomLink extends StatelessWidget {
  const BottomLink({
    super.key,
    required this.text,
    required this.action,
    required this.onTap,
    this.trailingIcon = false,
  });

  final String text;
  final String action;
  final VoidCallback onTap;
  final bool trailingIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: AppText.body(13, color: AppColors.textMuted),
          children: [
            TextSpan(text: text),
            TextSpan(
              text: action,
              style: const TextStyle(
                  color: AppColors.primary, fontWeight: FontWeight.w700),
            ),
            if (trailingIcon) const TextSpan(text: '  →'),
          ],
        ),
      ),
    );
  }
}
