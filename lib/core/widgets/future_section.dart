import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_theme.dart';
import '../services/tmdb_client.dart';

/// بيعرض نتيجة طلب شبكة بـ 3 حالات: تحميل، خطأ مع Retry، أو المحتوى.
class FutureSection<T> extends StatelessWidget {
  const FutureSection({
    super.key,
    required this.future,
    required this.builder,
    required this.onRetry,
    this.loadingHeight = 200,
    this.emptyText = 'Nothing to show yet.',
  });

  final Future<T> future;
  final Widget Function(T data) builder;
  final VoidCallback onRetry;
  final double loadingHeight;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return SizedBox(
            height: loadingHeight,
            child: const Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          final error = snapshot.error;
          return ErrorRetry(
            message: error is TmdbException
                ? error.message
                : 'Something went wrong. Please try again.',
            onRetry: onRetry,
          );
        }
        final data = snapshot.data as T;
        if (data is List && data.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 28),
            child: Center(
              child: Text(emptyText, style: AppText.body(12.5, color: AppColors.textMuted)),
            ),
          );
        }
        return builder(data);
      },
    );
  }
}

/// رسالة خطأ مع زر إعادة المحاولة.
class ErrorRetry extends StatelessWidget {
  const ErrorRetry({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const Icon(Icons.cloud_off_outlined, size: 24, color: AppColors.textDim),
          const SizedBox(height: 8),
          Text(message,
              textAlign: TextAlign.center,
              style: AppText.body(12.5, color: AppColors.textMuted, height: 1.4)),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onRetry,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.refresh, size: 16, color: AppColors.primary),
                const SizedBox(width: 5),
                Text('Retry',
                    style: AppText.body(12.5,
                        color: AppColors.primary, weight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
