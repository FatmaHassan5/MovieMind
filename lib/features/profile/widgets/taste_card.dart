import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../../core/data/movie_catalog.dart';
import '../../../core/models/movie.dart';
import '../../../core/state/user_controller.dart';
import '../../../core/state/watchlist_controller.dart';
import '../../../core/utils/taste_utils.dart';
import '../../../core/widgets/pill_chip.dart';
import '../../onboarding/widgets/onboarding_buttons.dart';

/// كارت "Taste Profile": بيحلل الأفلام المحفوظة ويطلّع أكتر تصنيف بتحبيه،
/// وبيوديكي لـ AI Mind تاخدي ترشيحات على ذوقك.
class TasteCard extends StatelessWidget {
  const TasteCard({super.key, required this.onAskAi});

  final VoidCallback onAskAi;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<String>>(
      valueListenable: WatchlistController.instance.ids,
      builder: (_, ids, __) {
        final saved = ids.map(MovieCatalog.byId).whereType<Movie>().toList();
        final top = TasteUtils.topGenres(saved, take: 2);

        final title = top.isEmpty
            ? 'Build your taste profile'
            : 'You love ${top.join(' & ')}';
        final subtitle = top.isEmpty
            ? 'Save a few movies and MovieMind will learn what you enjoy.'
            : 'Based on ${saved.length} saved ${saved.length == 1 ? "title" : "titles"}. '
                'Ask MovieMind AI for picks that match.';

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2E2440), Color(0xFF1E1A2C)],
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const PillChip(
                    label: 'TASTE PROFILE',
                    icon: Icons.psychology_outlined,
                    fontSize: 10,
                    letterSpacing: 0.6,
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: UserController.instance.aiPersonalization,
                    builder: (_, aiOn, __) => Text(
                      aiOn ? 'Personalized' : 'Paused',
                      style: AppText.body(11,
                          color: aiOn ? AppColors.green : AppColors.textDim,
                          weight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(title, style: AppText.heading(19, weight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(subtitle,
                  style: AppText.body(12.5, color: AppColors.textMuted, height: 1.5)),
              const SizedBox(height: 14),
              SizedBox(
                width: 150,
                child: PrimaryButton(label: 'Ask MovieMind', onPressed: onAskAi, height: 42),
              ),
            ],
          ),
        );
      },
    );
  }
}
