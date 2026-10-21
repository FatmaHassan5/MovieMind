import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_theme.dart';

/// خط فاصل بكلمة "OR" في النص، زي اللي بين الأزرار في اللوجين والتسجيل.
class SectionDivider extends StatelessWidget {
  const SectionDivider({super.key, this.label = 'OR'});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.surfaceHigh, height: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(label,
              style: AppText.body(11,
                  color: AppColors.textDim, letterSpacing: 1)),
        ),
        const Expanded(child: Divider(color: AppColors.surfaceHigh, height: 1)),
      ],
    );
  }
}
