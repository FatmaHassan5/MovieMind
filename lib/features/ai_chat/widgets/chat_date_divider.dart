import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';

/// فاصل تاريخ في منتصف المحادثة ("Today • 9:41 PM").
class ChatDateDivider extends StatelessWidget {
  const ChatDateDivider({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(label,
            style: AppText.body(11, color: AppColors.textDim, letterSpacing: 0.4)),
      ),
    );
  }
}
