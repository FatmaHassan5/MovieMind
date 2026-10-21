import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../onboarding/widgets/onboarding_buttons.dart';

/// بانر "AI Prioritizer" أعلى شاشة الـ Watchlist.
class AiPrioritizerBanner extends StatelessWidget {
  const AiPrioritizerBanner({super.key, required this.sciFiCount, required this.onDecide});

  final int sciFiCount;
  final VoidCallback onDecide;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
                color: AppColors.surfaceHigh, shape: BoxShape.circle),
            child: const Icon(Icons.auto_awesome, size: 16, color: AppColors.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('AI PRIORITIZER',
                        style: AppText.body(10.5,
                            color: AppColors.primary,
                            letterSpacing: 0.8,
                            weight: FontWeight.w700)),
                    const SizedBox(width: 6),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                          color: AppColors.green, shape: BoxShape.circle),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  sciFiCount > 0
                      ? 'You have $sciFiCount Sci-Fi ${sciFiCount == 1 ? "title" : "titles"} '
                          'in your queue. Want MovieMind to decide...'
                      : 'Your queue is ready. Want MovieMind to pick what\'s next...',
                  style: AppText.body(11.5, color: AppColors.textMuted, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 92,
            child: PrimaryButton(label: 'Decide', onPressed: onDecide, height: 38),
          ),
        ],
      ),
    );
  }
}
