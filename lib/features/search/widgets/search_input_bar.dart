import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';

/// حقل البحث الرئيسي في شاشة Explore Cinema (نص + زر مسح + زر فلتر).
class SearchInputBar extends StatelessWidget {
  const SearchInputBar({
    super.key,
    required this.controller,
    required this.onClear,
    required this.onFilterTap,
    this.onChanged,
  });

  final TextEditingController controller;
  final VoidCallback onClear;
  final VoidCallback onFilterTap;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 19, color: AppColors.textDim),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: AppText.body(14, color: AppColors.text),
              cursorColor: AppColors.primary,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'Search movies, shows, actors...',
                hintStyle: AppText.body(13.5, color: AppColors.textDim),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            GestureDetector(
              onTap: onClear,
              child: const Icon(Icons.close, size: 18, color: AppColors.textDim),
            ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onFilterTap,
            child: Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                  color: AppColors.green, shape: BoxShape.circle),
              child: const Icon(Icons.tune, size: 14, color: Color(0xFF0B241C)),
            ),
          ),
        ],
      ),
    );
  }
}
