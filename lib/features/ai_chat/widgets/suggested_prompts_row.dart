import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/widgets/pill_chip.dart';

/// اقتراحات أسئلة سريعة أسفل رد الـ AI.
class SuggestedPromptsRow extends StatelessWidget {
  const SuggestedPromptsRow({super.key, required this.prompts, required this.onTap});

  final List<String> prompts;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: prompts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) => GestureDetector(
          onTap: () => onTap(prompts[i]),
          child: PillChip(
            label: prompts[i],
            icon: i == 0 ? Icons.help_outline : Icons.auto_awesome,
            background: AppColors.surface,
            foreground: AppColors.text,
            fontSize: 11.5,
          ),
        ),
      ),
    );
  }
}
