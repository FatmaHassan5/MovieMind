import 'package:flutter/material.dart';

import '../app_assets.dart';
import '../app_colors.dart';

/// أفاتار البروفايل المستخدم في كل الشاشات. لو صورة [AppAssets.avatar]
/// مش موجودة، بيرجع تلقائيًا لأيقونة شخص بدل ما يبين مكسور أو فاضي.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, this.size = 34, this.onTap});

  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          color: AppColors.surfaceHigh,
          shape: BoxShape.circle,
        ),
        child: Image.asset(
          AppAssets.avatar,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Icon(
            Icons.person,
            size: size * 0.6,
            color: AppColors.textDim,
          ),
        ),
      ),
    );
  }
}
