import 'package:flutter/material.dart';

import '../app_colors.dart';

/// Image.asset مع placeholder لو الصورة لسه مش موجودة.
class AppImage extends StatelessWidget {
  const AppImage(this.path, {super.key, this.fit = BoxFit.cover});

  final String path;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      fit: fit,
      errorBuilder: (_, __, ___) => Container(
        color: AppColors.surfaceHigh,
        alignment: Alignment.center,
        child: const Icon(Icons.image_outlined, color: AppColors.textDim),
      ),
    );
  }
}
