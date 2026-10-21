// import 'package:flutter/material.dart';

// import '../../../core/app_colors.dart';
// import '../../../core/app_theme.dart';

// /// شريط رسالة أعلى الزرار الرئيسي: خطأ عام (أحمر) أو نجاح (أخضر).
// class AuthMessageBanner extends StatelessWidget {
//   const AuthMessageBanner({super.key, required this.message, this.isError = true});

//   final String message;
//   final bool isError;

//   @override
//   Widget build(BuildContext context) {
//     final color = isError ? AppColors.error : AppColors.green;
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
//       decoration: BoxDecoration(
//         color: isError ? const Color(0xFF3A1F27) : const Color(0xFF17342C),
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: color.withOpacity(0.45)),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(isError ? Icons.error_outline : Icons.check_circle_outline,
//               size: 17, color: color),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(message,
//                 style: AppText.body(12.5, color: color, weight: FontWeight.w600, height: 1.4)),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';

/// شريط رسالة أعلى الزرار الرئيسي: خطأ عام (أحمر) أو نجاح (أخضر).
class AuthMessageBanner extends StatelessWidget {
  const AuthMessageBanner({
    super.key,
    required this.message,
    this.isError = true,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final bool isError;

  /// رابط اختياري تحت الرسالة (زي "Resend verification email").
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final color = isError ? AppColors.error : AppColors.green;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: isError ? const Color(0xFF3A1F27) : const Color(0xFF17342C),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.45)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(isError ? Icons.error_outline : Icons.check_circle_outline,
              size: 17, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message,
                    style: AppText.body(12.5,
                        color: color, weight: FontWeight.w600, height: 1.4)),
                if (actionLabel != null) ...[
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: onAction,
                    child: Text(actionLabel!,
                        style: AppText.body(12.5,
                                color: AppColors.primary, weight: FontWeight.w700)
                            .copyWith(decoration: TextDecoration.underline)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
