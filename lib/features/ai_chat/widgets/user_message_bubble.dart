import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';

/// فقاعة رسالة المستخدم (يمين)، مع تمييز كلمة/اسم فيلم بلون مختلف اختياريًا.
class UserMessageBubble extends StatelessWidget {
  const UserMessageBubble({super.key, required this.text, this.highlight});

  final String text;
  final String? highlight;

  @override
  Widget build(BuildContext context) {
    final spans = <InlineSpan>[];
    if (highlight != null && text.contains(highlight!)) {
      final parts = text.split(highlight!);
      spans.add(TextSpan(text: parts.first));
      spans.add(TextSpan(
          text: highlight,
          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)));
      spans.add(TextSpan(text: parts.sublist(1).join(highlight!)));
    } else {
      spans.add(TextSpan(text: text));
    }

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        constraints: const BoxConstraints(maxWidth: 280),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: AppColors.surfaceHigh,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text.rich(
          TextSpan(style: AppText.body(13.5, weight: FontWeight.w400), children: spans),
        ),
      ),
    );
  }
}
