import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../../core/utils/app_dates.dart';

/// رأس الشهر: سهم سابق + "October 2026" + سهم تالي.
class CalendarMonthHeader extends StatelessWidget {
  const CalendarMonthHeader({
    super.key,
    required this.month,
    required this.onPrevious,
    required this.onNext,
  });

  final DateTime month;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ArrowButton(icon: Icons.chevron_left, onTap: onPrevious),
        Expanded(
          child: Text(
            AppDates.monthYear(month),
            textAlign: TextAlign.center,
            style: AppText.heading(17, weight: FontWeight.w700),
          ),
        ),
        _ArrowButton(icon: Icons.chevron_right, onTap: onNext),
      ],
    );
  }
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: const BoxDecoration(
            color: AppColors.surfaceHigh, shape: BoxShape.circle),
        child: Icon(icon, size: 20, color: AppColors.text),
      ),
    );
  }
}
