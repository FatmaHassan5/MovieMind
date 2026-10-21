// import 'package:flutter/material.dart';

// import '../../../core/app_assets.dart';
// import '../../../core/app_colors.dart';
// import '../../../core/app_theme.dart';
// import '../../../core/widgets/app_image.dart';

// /// هيدر شاشة المحادثة: لوجو + "AI ASSISTANT" + جرس + أفاتار،
// /// وتحت كده صف حالة المساعد (الاسم، الإصدار، وصف) + أيقونات صوت/تصفير.
// class AiChatHeader extends StatelessWidget {
//   const AiChatHeader({super.key, required this.onReset});

//   final VoidCallback onReset;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             const SizedBox(
//               width: 24,
//               height: 24,
//               child: AppImage(AppAssets.logo, fit: BoxFit.contain),
//             ),
//             const SizedBox(width: 9),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('MovieMind', style: AppText.heading(15, weight: FontWeight.w700)),
//                 Text('AI ASSISTANT',
//                     style: AppText.body(9,
//                         color: AppColors.primary,
//                         letterSpacing: 1.4,
//                         weight: FontWeight.w700)),
//               ],
//             ),
//             const Spacer(),
//             const Icon(Icons.notifications_none_rounded,
//                 color: AppColors.text, size: 22),
//             const SizedBox(width: 10),
//             const CircleAvatar(
//               radius: 16,
//               backgroundColor: AppColors.surface,
//               child: ClipOval(
//                 child: SizedBox(
//                   width: 32,
//                   height: 32,
//                   child: AppImage(AppAssets.avatar),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         Row(
//           children: [
//             Container(
//               width: 34,
//               height: 34,
//               decoration: const BoxDecoration(
//                   color: AppColors.surfaceHigh, shape: BoxShape.circle),
//               child: const Icon(Icons.psychology_alt_outlined,
//                   size: 17, color: AppColors.primary),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         width: 6,
//                         height: 6,
//                         margin: const EdgeInsets.only(right: 6),
//                         decoration: const BoxDecoration(
//                             color: AppColors.green, shape: BoxShape.circle),
//                       ),
//                       Text('MovieMind AI',
//                           style: AppText.body(14, weight: FontWeight.w700)),
//                       const SizedBox(width: 6),
//                       Container(
//                         padding:
//                             const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                         decoration: BoxDecoration(
//                           color: AppColors.surfaceHigh,
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         child: Text('v2.4',
//                             style: AppText.body(9, color: AppColors.textMuted)),
//                       ),
//                     ],
//                   ),
//                   Text('Personalized Film Intelligence',
//                       style: AppText.body(11, color: AppColors.textMuted)),
//                 ],
//               ),
//             ),
//             const Icon(Icons.volume_up_outlined, size: 19, color: AppColors.textDim),
//             const SizedBox(width: 12),
//             GestureDetector(
//               onTap: onReset,
//               child: const Icon(Icons.refresh, size: 19, color: AppColors.textDim),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }



import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../../core/widgets/brand_header.dart';

/// هيدر شاشة المحادثة: BrandHeader مشترك (لوجو + اسم + جرس + أفاتار)
/// وتحت كده صف حالة المساعد (الاسم، الإصدار، وصف) + أيقونات صوت/تصفير.
class AiChatHeader extends StatelessWidget {
  const AiChatHeader({super.key, required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BrandHeader(sectionLabel: 'AI ASSISTANT'),
        const SizedBox(height: 16),
        Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                  color: AppColors.surfaceHigh, shape: BoxShape.circle),
              child: const Icon(Icons.psychology_alt_outlined,
                  size: 17, color: AppColors.primary),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(right: 6),
                        decoration: const BoxDecoration(
                            color: AppColors.green, shape: BoxShape.circle),
                      ),
                      Text('MovieMind AI',
                          style: AppText.body(14, weight: FontWeight.w700)),
                      const SizedBox(width: 6),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceHigh,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('v2.4',
                            style: AppText.body(9, color: AppColors.textMuted)),
                      ),
                    ],
                  ),
                  Text('Personalized Film Intelligence',
                      style: AppText.body(11, color: AppColors.textMuted)),
                ],
              ),
            ),
            const Icon(Icons.volume_up_outlined, size: 19, color: AppColors.textDim),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: onReset,
              child: const Icon(Icons.refresh, size: 19, color: AppColors.textDim),
            ),
          ],
        ),
      ],
    );
  }
}
