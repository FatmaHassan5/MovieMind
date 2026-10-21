import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_theme.dart';

/// زر تسجيل دخول اجتماعي (Google) بنفس شكل الأزرار الداكنة في التصميم.
class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.height = 48,
  });

  final String label;
  final Widget icon;
  final VoidCallback? onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: SizedBox(
          height: height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 10),
              Text(label,
                  style: AppText.body(14, weight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

/// أيقونة G بسيطة داخل دائرة بيضاء (بديل عام، غير شعار Google الرسمي).
class GoogleGlyph extends StatelessWidget {
  const GoogleGlyph({super.key, this.size = 20});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: Text(
        'G',
        style: TextStyle(
          fontSize: size * 0.62,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF4285F4),
          height: 1,
        ),
      ),
    );
  }
}
