import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_theme.dart';

class PillChip extends StatelessWidget {
  const PillChip({
    super.key,
    required this.label,
    this.icon,
    this.iconColor = AppColors.primary,
    this.showDot = false,
    this.background = AppColors.surface,
    this.foreground = AppColors.primary,
    this.fontSize = 11,
    this.letterSpacing = 0,
    this.weight = FontWeight.w600,
    this.padding = const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
  });

  final String label;
  final IconData? icon;
  final Color iconColor;
  final bool showDot;
  final Color background;
  final Color foreground;
  final double fontSize;
  final double letterSpacing;
  final FontWeight weight;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration:
                  BoxDecoration(color: iconColor, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
          ],
          if (icon != null) ...[
            Icon(icon, size: fontSize + 3, color: iconColor),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: AppText.body(fontSize,
                color: foreground, weight: weight, letterSpacing: letterSpacing),
          ),
        ],
      ),
    );
  }
}
