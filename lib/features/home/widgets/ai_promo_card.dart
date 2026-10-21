import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../../core/widgets/pill_chip.dart';
import '../../onboarding/widgets/onboarding_buttons.dart';

/// كارت "Ask MovieMind AI" الترويجي في أعلى Home.
class AiPromoCard extends StatelessWidget {
  const AiPromoCard({super.key, required this.onStartChat});

  final VoidCallback onStartChat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2E2440), Color(0xFF1E1A2C)],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const PillChip(
                label: 'CINEMATCH AI',
                icon: Icons.auto_awesome,
                fontSize: 10,
                letterSpacing: 0.6,
              ),
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                        color: AppColors.green, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 5),
                  Text('Ready',
                      style: AppText.body(11,
                          color: AppColors.green, weight: FontWeight.w600)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Ask MovieMind AI',
              style: AppText.heading(19, weight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(
            'Find your perfect movie tonight through intuitive conversation, '
            'tailored moods, and smart tastes.',
            style: AppText.body(12.5, color: AppColors.textMuted, height: 1.5),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              SizedBox(
                width: 130,
                child: PrimaryButton(
                    label: 'Start Chat', onPressed: onStartChat, height: 42),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text('or tap for surprises ✨',
                    style: AppText.body(11.5, color: AppColors.textMuted)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
