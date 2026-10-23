

import 'package:flutter/material.dart';

import '../app_colors.dart';

/// صورة من رابط (https) أو من assets، مع placeholder لو الصورة مش موجودة أو فشلت.
class AppImage extends StatelessWidget {
  const AppImage(this.path, {super.key, this.fit = BoxFit.cover});

  final String path;
  final BoxFit fit;

  Widget get _placeholder => Container(
        color: AppColors.surfaceHigh,
        alignment: Alignment.center,
        child: const Icon(Icons.image_outlined, color: AppColors.textDim),
      );

  @override
  Widget build(BuildContext context) {
    if (path.isEmpty) return _placeholder;

    if (path.startsWith('http')) {
      return Image.network(
        path,
        fit: fit,
        errorBuilder: (_, __, ___) => _placeholder,
        loadingBuilder: (_, child, progress) =>
            progress == null ? child : Container(color: AppColors.surfaceHigh),
      );
    }
    return Image.asset(path, fit: fit, errorBuilder: (_, __, ___) => _placeholder);
  }
}
