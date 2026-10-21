// import 'package:flutter/material.dart';

// import '../app_colors.dart';
// import '../app_theme.dart';

// /// حقل إدخال موحّد الشكل لكل الفورمز: label فوق، خلفية داكنة، أيقونة يسار،
// /// وحدود بتتلوّن باللون الأساسي عند الفوكس وباللون الأحمر عند الخطأ.
// class AppTextField extends StatelessWidget {
//   const AppTextField({
//     super.key,
//     required this.label,
//     required this.controller,
//     this.hint,
//     this.prefixIcon,
//     this.obscureText = false,
//     this.showObscureToggle = false,
//     this.isObscured = true,
//     this.onToggleObscure,
//     this.validator,
//     this.keyboardType,
//     this.textInputAction,
//     this.onChanged,
//     this.trailing,
//   });

//   final String label;
//   final TextEditingController controller;
//   final String? hint;
//   final IconData? prefixIcon;
//   final bool obscureText;
//   final bool showObscureToggle;
//   final bool isObscured;
//   final VoidCallback? onToggleObscure;
//   final String? Function(String?)? validator;
//   final TextInputType? keyboardType;
//   final TextInputAction? textInputAction;
//   final ValueChanged<String>? onChanged;

//   /// عنصر اختياري يظهر يمين الـ label (زي "Forgot Password?").
//   final Widget? trailing;

//   @override
//   Widget build(BuildContext context) {
//     final radius = BorderRadius.circular(14);
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(label,
//                 style: AppText.body(13, weight: FontWeight.w600)),
//             if (trailing != null) trailing!,
//           ],
//         ),
//         const SizedBox(height: 8),
//         TextFormField(
//           controller: controller,
//           obscureText: showObscureToggle ? isObscured : obscureText,
//           keyboardType: keyboardType,
//           textInputAction: textInputAction,
//           validator: validator,
//           onChanged: onChanged,
//           cursorColor: AppColors.primary,
//           style: AppText.body(14, color: AppColors.text),
//           decoration: InputDecoration(
//             isDense: true,
//             hintText: hint,
//             hintStyle: AppText.body(13.5,
//                 color: AppColors.textDim, weight: FontWeight.w400),
//             filled: true,
//             fillColor: AppColors.surface,
//             contentPadding:
//                 const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
//             prefixIcon: prefixIcon != null
//                 ? Icon(prefixIcon, color: AppColors.textDim, size: 18)
//                 : null,
//             prefixIconConstraints:
//                 const BoxConstraints(minWidth: 42, minHeight: 0),
//             suffixIcon: showObscureToggle
//                 ? IconButton(
//                     splashRadius: 18,
//                     onPressed: onToggleObscure,
//                     icon: Icon(
//                       isObscured
//                           ? Icons.visibility_off_outlined
//                           : Icons.visibility_outlined,
//                       color: AppColors.textDim,
//                       size: 18,
//                     ),
//                   )
//                 : null,
//             border: OutlineInputBorder(
//                 borderRadius: radius, borderSide: BorderSide.none),
//             enabledBorder: OutlineInputBorder(
//                 borderRadius: radius,
//                 borderSide: const BorderSide(color: Colors.transparent)),
//             focusedBorder: OutlineInputBorder(
//                 borderRadius: radius,
//                 borderSide: const BorderSide(color: AppColors.primary, width: 1.4)),
//             errorBorder: OutlineInputBorder(
//                 borderRadius: radius,
//                 borderSide: const BorderSide(color: AppColors.error, width: 1.2)),
//             focusedErrorBorder: OutlineInputBorder(
//                 borderRadius: radius,
//                 borderSide: const BorderSide(color: AppColors.error, width: 1.4)),
//             errorStyle: AppText.body(11.5,
//                 color: AppColors.error, weight: FontWeight.w500),
//             errorMaxLines: 2,
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_theme.dart';

/// حقل إدخال موحّد الشكل لكل الفورمز: label فوق، خلفية داكنة، أيقونة يسار،
/// وحدود بتتلوّن باللون الأساسي عند الفوكس وباللون الأحمر عند الخطأ.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.prefixIcon,
    this.obscureText = false,
    this.readOnly = false,
    this.showObscureToggle = false,
    this.isObscured = true,
    this.onToggleObscure,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.trailing,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final IconData? prefixIcon;
  final bool obscureText;
  final bool readOnly;
  final bool showObscureToggle;
  final bool isObscured;
  final VoidCallback? onToggleObscure;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;

  /// عنصر اختياري يظهر يمين الـ label (زي "Forgot Password?").
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(14);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: AppText.body(13, weight: FontWeight.w600)),
            if (trailing != null) trailing!,
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          obscureText: showObscureToggle ? isObscured : obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          onChanged: onChanged,
          cursorColor: AppColors.primary,
          style: AppText.body(14,
              color: readOnly ? AppColors.textDim : AppColors.text),
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            hintStyle: AppText.body(13.5,
                color: AppColors.textDim, weight: FontWeight.w400),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: AppColors.textDim, size: 18)
                : null,
            prefixIconConstraints:
                const BoxConstraints(minWidth: 42, minHeight: 0),
            suffixIcon: showObscureToggle
                ? IconButton(
                    splashRadius: 18,
                    onPressed: onToggleObscure,
                    icon: Icon(
                      isObscured
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textDim,
                      size: 18,
                    ),
                  )
                : null,
            border: OutlineInputBorder(
                borderRadius: radius, borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
                borderRadius: radius,
                borderSide: const BorderSide(color: Colors.transparent)),
            focusedBorder: OutlineInputBorder(
                borderRadius: radius,
                borderSide: const BorderSide(color: AppColors.primary, width: 1.4)),
            errorBorder: OutlineInputBorder(
                borderRadius: radius,
                borderSide: const BorderSide(color: AppColors.error, width: 1.2)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: radius,
                borderSide: const BorderSide(color: AppColors.error, width: 1.4)),
            errorStyle: AppText.body(11.5,
                color: AppColors.error, weight: FontWeight.w500),
            errorMaxLines: 2,
          ),
        ),
      ],
    );
  }
}
