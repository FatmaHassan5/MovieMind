import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_theme.dart';

/// بادج "98% Match" الأخضر.
class MatchBadge extends StatelessWidget {
  const MatchBadge({super.key, required this.percent, this.dense = false});

  final String percent;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: dense ? 7 : 9, vertical: dense ? 3 : 4),
      decoration: BoxDecoration(
        color: const Color(0xFF17342C),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text('$percent% Match',
          style: AppText.body(dense ? 9.5 : 11,
              color: AppColors.green, weight: FontWeight.w700)),
    );
  }
}
