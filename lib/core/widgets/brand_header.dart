import 'package:flutter/material.dart';

import '../app_assets.dart';
import '../app_colors.dart';
import '../app_theme.dart';
import 'app_image.dart';
import 'profile_avatar.dart';

/// هيدر علوي مشترك: لوجو + اسم التطبيق + تسمية القسم (HOME/WATCHLIST/...)
/// + جرس الإشعارات + أفاتار البروفايل. تستخدمه Home وWatchlist وAI Mind.
class BrandHeader extends StatelessWidget {
  const BrandHeader({
    super.key,
    required this.sectionLabel,
    this.onAvatarTap,
    this.onBellTap,
  });

  final String sectionLabel;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onBellTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 24,
          height: 24,
          child: AppImage(AppAssets.logo, fit: BoxFit.contain),
        ),
        const SizedBox(width: 9),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('MovieMind', style: AppText.heading(15, weight: FontWeight.w700)),
            Text(sectionLabel,
                style: AppText.body(9,
                    color: AppColors.primary,
                    letterSpacing: 1.4,
                    weight: FontWeight.w700)),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: onBellTap,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.notifications_none_rounded,
                  color: AppColors.text, size: 24),
              Positioned(
                right: -1,
                top: -1,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                      color: AppColors.accent, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        ProfileAvatar(size: 34, onTap: onAvatarTap),
      ],
    );
  }
}
