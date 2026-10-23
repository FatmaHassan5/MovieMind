import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';

/// فقاعة خطأ في المحادثة مع زر "Retry" لإعادة إرسال نفس الرسالة.
class ChatErrorBubble extends StatelessWidget {
  const ChatErrorBubble({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        constraints: const BoxConstraints(maxWidth: 300),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF3A1F27),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.error.withOpacity(0.45)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.error_outline, size: 17, color: AppColors.error),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(message,
                      style: AppText.body(12.5,
                          color: AppColors.error, weight: FontWeight.w600, height: 1.4)),
                ),
              ],
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 10),
              GestureDetector(
                onTap: onRetry,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.refresh, size: 15, color: AppColors.primary),
                    const SizedBox(width: 5),
                    Text('Retry',
                        style: AppText.body(12.5,
                            color: AppColors.primary, weight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
