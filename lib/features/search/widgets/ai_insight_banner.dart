import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../../core/widgets/pill_chip.dart';

/// بانر "Need deeper analysis?" أسفل نتائج البحث — بيودّي لتاب الـ AI Mind.
class AiInsightBanner extends StatelessWidget {
  const AiInsightBanner({super.key, required this.query, required this.onAskAi});

  final String query;
  final VoidCallback onAskAi;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
                color: AppColors.surfaceHigh, shape: BoxShape.circle),
            child: const Icon(Icons.psychology_outlined,
                size: 17, color: AppColors.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('Need deeper analysis?',
                          style: AppText.body(13.5, weight: FontWeight.w700)),
                    ),
                    const PillChip(label: 'AI MIND', fontSize: 9, letterSpacing: 0.6),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  "Ask the AI why Nolan's physics in Interstellar connects "
                  "so deeply with Arrival's linguistic loops.",
                  style: AppText.body(11.5, color: AppColors.textMuted, height: 1.4),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: onAskAi,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceHigh,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Ask AI about $query',
                            style: AppText.body(11.5, weight: FontWeight.w600)),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward, size: 13),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
