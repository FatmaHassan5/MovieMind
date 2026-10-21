import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/choice_shapes.dart';

/// شريط قوة الباسورد (4 قطع) + تسمية (Weak/Fair/Good/Strong)
/// + قائمة الشروط اللي بتتلون لما تتحقق.
class PasswordStrengthMeter extends StatelessWidget {
  const PasswordStrengthMeter({super.key, required this.password});

  final String password;

  static const _labels = ['Weak', 'Weak', 'Fair', 'Good', 'Strong'];
  static const _colors = [
    AppColors.error,
    AppColors.error,
    AppColors.amber,
    AppColors.primary,
    AppColors.green,
  ];

  @override
  Widget build(BuildContext context) {
    final score = Validators.passwordStrengthScore(password);
    final active = password.isEmpty ? 0 : score;
    final color = _colors[active];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Security Strength',
                style: AppText.body(12, color: AppColors.textMuted)),
            Text(password.isEmpty ? 'Weak' : _labels[active],
                style: AppText.body(12, color: color, weight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: List.generate(4, (i) {
            final filled = i < active;
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: i == 3 ? 0 : 5),
                decoration: BoxDecoration(
                  color: filled ? color : AppColors.surfaceHigh,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 16,
          runSpacing: 6,
          children: [
            _Requirement(
                label: '8+ characters',
                met: Validators.hasMinLength(password)),
            _Requirement(
                label: 'Number included', met: Validators.hasNumber(password)),
            _Requirement(
                label: 'Special character',
                met: Validators.hasSpecialChar(password)),
          ],
        ),
      ],
    );
  }
}

class _Requirement extends StatelessWidget {
  const _Requirement({required this.label, required this.met});

  final String label;
  final bool met;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RequirementDot(met: met),
        const SizedBox(width: 7),
        Text(label,
            style: AppText.body(11.5,
                color: met ? AppColors.text : AppColors.textMuted)),
      ],
    );
  }
}
