import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';

/// نقط الصفحات: الضغط على نقطة ينقل لصفحتها، والنقطة النشطة بتتمدد.
class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.count,
    required this.index,
    required this.onTap,
    this.alignment = MainAxisAlignment.center,
  });

  final int count;
  final int index;
  final ValueChanged<int> onTap;
  final MainAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: alignment,
      children: List.generate(count, (i) {
        final active = i == index;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onTap(i),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              width: active ? 26 : 7,
              height: 7,
              decoration: BoxDecoration(
                color: active ? AppColors.primary : AppColors.surfaceHigh,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        );
      }),
    );
  }
}
