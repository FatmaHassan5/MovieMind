import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';

/// شريط بحث غير قابل للكتابة مباشرة في Home — بيوديك لتاب الـ Search عند الضغط.
class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              const Icon(Icons.search, size: 19, color: AppColors.textDim),
              const SizedBox(width: 10),
              Expanded(
                child: Text('Search movies, shows, actors...',
                    style: AppText.body(13, color: AppColors.textDim)),
              ),
              const Icon(Icons.mic_none_rounded, size: 19, color: AppColors.textDim),
            ],
          ),
        ),
      ),
    );
  }
}
