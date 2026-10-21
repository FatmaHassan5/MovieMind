import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../../core/state/watchlist_controller.dart';
import '../../onboarding/widgets/onboarding_buttons.dart';

/// زر إضافة/إزالة الفيلم من الـ Watchlist — بيتغيّر شكله حسب الحالة.
class DetailsActionBar extends StatelessWidget {
  const DetailsActionBar({super.key, required this.movieId});

  final String movieId;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<String>>(
      valueListenable: WatchlistController.instance.ids,
      builder: (_, ids, __) {
        final saved = ids.contains(movieId);
        if (!saved) {
          return PrimaryButton(
            label: 'Add to Watchlist',
            onPressed: () => WatchlistController.instance.toggle(movieId),
          );
        }
        return Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => WatchlistController.instance.toggle(movieId),
            child: Container(
              height: 52,
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.bookmark, color: AppColors.primary, size: 18),
                  const SizedBox(width: 8),
                  Text('In Watchlist',
                      style: AppText.body(15,
                          color: AppColors.primary, weight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
