import 'package:flutter/material.dart';

import '../app_colors.dart';

/// checkbox دائري ممتلئ (مستخدم في "Remember for 30 days").
class CircleCheck extends StatelessWidget {
  const CircleCheck({super.key, required this.value, this.size = 20});

  final bool value;
  final double size;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: value ? AppColors.primary : Colors.transparent,
        border: Border.all(
          color: value ? AppColors.primary : AppColors.textDim,
          width: 1.4,
        ),
      ),
      child: value
          ? Icon(Icons.check, size: size * 0.65, color: AppColors.onPrimary)
          : null,
    );
  }
}

/// checkbox مربّع (مستخدم في الموافقة على الشروط).
class SquareCheck extends StatelessWidget {
  const SquareCheck({super.key, required this.value, this.size = 20});

  final bool value;
  final double size;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: value ? AppColors.primary : AppColors.surface,
        border: Border.all(
          color: value ? AppColors.primary : AppColors.textDim,
          width: 1.4,
        ),
      ),
      child: value
          ? Icon(Icons.check, size: size * 0.65, color: AppColors.onPrimary)
          : null,
    );
  }
}

/// دائرة صغيرة تتحول لعلامة صح خضراء عند استيفاء شرط
/// (مستخدمة في متطلبات الباسورد بصفحة التسجيل).
class RequirementDot extends StatelessWidget {
  const RequirementDot({super.key, required this.met, this.size = 16});

  final bool met;
  final double size;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: met ? AppColors.green.withOpacity(0.18) : Colors.transparent,
        border: Border.all(
          color: met ? AppColors.green : AppColors.textDim,
          width: 1.3,
        ),
      ),
      child: met
          ? Icon(Icons.check, size: size * 0.65, color: AppColors.green)
          : null,
    );
  }
}
