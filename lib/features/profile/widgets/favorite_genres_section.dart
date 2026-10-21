import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/state/user_controller.dart';
import '../../../core/utils/taste_utils.dart';
import '../../../core/widgets/pill_chip.dart';

/// اختيار التصنيفات المفضلة (تحديد/إلغاء بالضغط) — بيتحفظ في UserController.
class FavoriteGenresSection extends StatelessWidget {
  const FavoriteGenresSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: UserController.instance.favoriteGenres,
      builder: (_, selected, __) => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final genre in TasteUtils.genres)
            GestureDetector(
              onTap: () => UserController.instance.toggleGenre(genre),
              child: PillChip(
                label: genre,
                icon: selected.contains(genre) ? Icons.check : null,
                fontSize: 12.5,
                background:
                    selected.contains(genre) ? AppColors.primary : AppColors.surface,
                foreground:
                    selected.contains(genre) ? AppColors.onPrimary : AppColors.text,
                iconColor: AppColors.onPrimary,
                weight: selected.contains(genre) ? FontWeight.w700 : FontWeight.w600,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              ),
            ),
        ],
      ),
    );
  }
}
