import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../../core/utils/app_dates.dart';

/// شبكة أيام الشهر (الأسبوع بيبدأ بالأحد). بتحسب أماكن الأيام من التاريخ الفعلي،
/// وبتعلّم النهارده واليوم المختار والأيام اللي فيها أفلام بنقطة.
class CalendarGrid extends StatelessWidget {
  const CalendarGrid({
    super.key,
    required this.month,
    required this.selected,
    required this.hasRelease,
    required this.onSelect,
  });

  final DateTime month;
  final DateTime? selected;
  final bool Function(DateTime day) hasRelease;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final offset = DateTime(month.year, month.month, 1).weekday % 7; // الأحد = 0
    final daysInMonth = AppDates.daysInMonth(month.year, month.month);
    final rows = ((offset + daysInMonth) / 7).ceil();

    return Column(
      children: [
        Row(
          children: [
            for (final initial in AppDates.weekdayInitials)
              Expanded(
                child: Center(
                  child: Text(initial,
                      style: AppText.body(11,
                          color: AppColors.textDim, weight: FontWeight.w700)),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        for (var r = 0; r < rows; r++)
          Row(
            children: [
              for (var c = 0; c < 7; c++)
                Expanded(child: _cell(r * 7 + c - offset + 1, daysInMonth)),
            ],
          ),
      ],
    );
  }

  Widget _cell(int day, int daysInMonth) {
    if (day < 1 || day > daysInMonth) {
      return const AspectRatio(aspectRatio: 1, child: SizedBox.shrink());
    }
    final date = DateTime(month.year, month.month, day);
    final isToday = AppDates.isSameDay(date, AppDates.today());
    final isSelected = selected != null && AppDates.isSameDay(date, selected!);
    final release = hasRelease(date);

    return GestureDetector(
      onTap: () => onSelect(date),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isToday && !isSelected
                  ? Border.all(color: AppColors.primary, width: 1.2)
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$day',
                    style: AppText.body(12.5,
                        color: isSelected ? AppColors.onPrimary : AppColors.text,
                        weight: isToday || isSelected
                            ? FontWeight.w700
                            : FontWeight.w500)),
                const SizedBox(height: 3),
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: release
                        ? (isSelected ? AppColors.onPrimary : AppColors.green)
                        : Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
