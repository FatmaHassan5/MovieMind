import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../../core/state/user_controller.dart';
import '../../../core/state/watchlist_controller.dart';
import '../../../core/widgets/pill_chip.dart';
import '../../../core/widgets/profile_avatar.dart';

/// كارت بيانات المستخدم: صورة + اسم + إيميل + مستوى المشاهدة + زر تعديل.
class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({super.key, required this.onEdit});

  final VoidCallback onEdit;

  /// المستوى بيتحدد من عدد الأفلام اللي علّمتيها "Watched".
  static String levelFor(int watched) {
    if (watched >= 6) return 'Film Buff';
    if (watched >= 3) return 'Cinephile';
    return 'Newcomer';
  }

  @override
  Widget build(BuildContext context) {
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
                color: AppColors.primary, shape: BoxShape.circle),
            child: const ProfileAvatar(size: 62),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder<String>(
                  valueListenable: UserController.instance.name,
                  builder: (_, name, __) => Text(name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.heading(19, weight: FontWeight.w700)),
                ),
                const SizedBox(height: 2),
                ValueListenableBuilder<String>(
                  valueListenable: UserController.instance.email,
                  builder: (_, email, __) => Text(email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.body(12, color: AppColors.textMuted)),
                ),
                const SizedBox(height: 8),
                ValueListenableBuilder<Set<String>>(
                  valueListenable: WatchlistController.instance.watchedIds,
                  builder: (_, watched, __) => PillChip(
                    label: levelFor(watched.length),
                    icon: Icons.military_tech_outlined,
                    fontSize: 10.5,
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onEdit,
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                  color: AppColors.surfaceHigh, shape: BoxShape.circle),
              child: const Icon(Icons.edit_outlined, size: 17, color: AppColors.text),
            ),
          ),
        ],
      ),
    );
  }
}
