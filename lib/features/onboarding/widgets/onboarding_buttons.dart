import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';

/// الزر الأساسي البنفسجي الفاتح (Continue / Get Started).
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = 52,
  });

  final String label;
  final VoidCallback onPressed;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withOpacity(0.25),
              blurRadius: 20,
              offset: const Offset(0, 5)),
        ],
      ),
      child: Material(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onPressed,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label,
                    style: AppText.body(15,
                        color: AppColors.onPrimary, weight: FontWeight.w700)),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward,
                    color: AppColors.onPrimary, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// الزر الغامق الثانوي (Back) وزر tune.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.onPressed,
    this.label,
    this.icon,
    this.height = 52,
  });

  final VoidCallback onPressed;
  final String? label;
  final IconData? icon;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onPressed,
        child: SizedBox(
          height: height,
          child: Center(
            child: label == null
                ? Icon(icon, color: AppColors.text, size: 22)
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.arrow_back,
                          color: AppColors.text, size: 17),
                      const SizedBox(width: 8),
                      Text(label!,
                          style: AppText.body(15, weight: FontWeight.w600)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// كبسولة صغيرة أعلى الصفحة (STEP 1 OF 3 / Back / Skip).
class TopChip extends StatelessWidget {
  const TopChip({super.key, required this.label, this.icon, this.onTap});

  final String label;
  final IconData? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 14, color: AppColors.text),
                const SizedBox(width: 6),
              ],
              Text(label,
                  style: AppText.body(12,
                      weight: FontWeight.w600,
                      letterSpacing: label.startsWith('STEP') ? 0.6 : 0)),
            ],
          ),
        ),
      ),
    );
  }
}
