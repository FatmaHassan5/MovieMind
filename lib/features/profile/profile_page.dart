

// import 'package:flutter/material.dart';

// import '../../core/app_colors.dart';
// import '../../core/app_theme.dart';
// import '../../core/data/movie_catalog.dart';
// import '../../core/models/movie.dart';
// import '../../core/state/user_controller.dart';
// import '../../core/state/watchlist_controller.dart';
// import '../../core/widgets/brand_header.dart';
// import '../auth/login_page.dart';
// import '../home/widgets/poster_row.dart';
// import '../home/widgets/section_header.dart';
// import 'widgets/edit_profile_sheet.dart';
// import 'widgets/favorite_genres_section.dart';
// import 'widgets/profile_header_card.dart';
// import 'widgets/profile_stats_row.dart';
// import 'widgets/settings_section.dart';
// import 'widgets/taste_card.dart';

// /// شاشة Profile — بنفس تصميم Home: هيدر، كروت، عناوين أقسام، وكلها
// /// مربوطة ببيانات حقيقية (Watchlist, المشاهدات, التفضيلات).
// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key, required this.onNavigate});

//   final ValueChanged<int> onNavigate;

//   static const _aiTabIndex = 2;
//   static const _watchlistTabIndex = 3;

//   Future<void> _confirmLogout(BuildContext context) async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         backgroundColor: AppColors.surface,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: Text('Log out?', style: AppText.heading(18, weight: FontWeight.w700)),
//         content: Text('You can log back in anytime.',
//             style: AppText.body(13, color: AppColors.textMuted)),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(ctx).pop(false),
//             child: Text('Cancel', style: AppText.body(13, color: AppColors.textMuted)),
//           ),
//           TextButton(
//             onPressed: () => Navigator.of(ctx).pop(true),
//             child: Text('Log out',
//                 style: AppText.body(13, color: AppColors.error, weight: FontWeight.w700)),
//           ),
//         ],
//       ),
//     );
//     if (confirmed != true || !context.mounted) return;

//     UserController.instance.reset();
//     Navigator.of(context).pushAndRemoveUntil(
//       MaterialPageRoute(builder: (_) => const LoginPage()),
//       (route) => false,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SafeArea(
//         child: ListView(
//           padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
//           children: [
//             const BrandHeader(sectionLabel: 'PROFILE'),
//             const SizedBox(height: 18),
//             Text('Your Profile', style: AppText.heading(21, weight: FontWeight.w700)),
//             const SizedBox(height: 2),
//             Text('Manage your taste, lists, and settings',
//                 style: AppText.body(13, color: AppColors.textMuted)),
//             const SizedBox(height: 16),
//             ProfileHeaderCard(onEdit: () => showEditProfileSheet(context)),
//             const SizedBox(height: 12),
//             const ProfileStatsRow(),
//             const SizedBox(height: 16),
//             TasteCard(onAskAi: () => onNavigate(_aiTabIndex)),
//             const SizedBox(height: 22),
//             SectionHeader(
//               icon: Icons.bookmark_border,
//               title: 'My Watchlist',
//               onAction: () => onNavigate(_watchlistTabIndex),
//             ),
//             const SizedBox(height: 12),
//             const _WatchlistPreview(),
//             const SizedBox(height: 22),
//             const SectionHeader(
//               icon: Icons.favorite_border,
//               title: 'Favorite Genres',
//               actionLabel: null,
//             ),
//             const SizedBox(height: 12),
//             const FavoriteGenresSection(),
//             const SizedBox(height: 22),
//             const SectionHeader(
//               icon: Icons.settings_outlined,
//               title: 'Settings',
//               actionLabel: null,
//             ),
//             const SizedBox(height: 12),
//             const SettingsSection(),
//             const SizedBox(height: 22),
//             _LogoutButton(onTap: () => _confirmLogout(context)),
//             const SizedBox(height: 14),
//             Center(
//               child: Text('MovieMind v1.0.0',
//                   style: AppText.body(11, color: AppColors.textDim)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _WatchlistPreview extends StatelessWidget {
//   const _WatchlistPreview();

//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<List<String>>(
//       valueListenable: WatchlistController.instance.ids,
//       builder: (_, ids, __) {
//         final movies = ids.map(MovieCatalog.byId).whereType<Movie>().toList();
//         if (movies.isEmpty) {
//           return Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(18),
//             decoration: BoxDecoration(
//               color: AppColors.surface,
//               borderRadius: BorderRadius.circular(18),
//             ),
//             child: Text('Nothing saved yet — tap the bookmark on any movie.',
//                 textAlign: TextAlign.center,
//                 style: AppText.body(12.5, color: AppColors.textMuted)),
//           );
//         }
//         return PosterRow(movies: movies);
//       },
//     );
//   }
// }

// class _LogoutButton extends StatelessWidget {
//   const _LogoutButton({required this.onTap});

//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: AppColors.surface,
//       borderRadius: BorderRadius.circular(18),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(18),
//         onTap: onTap,
//         child: Container(
//           height: 52,
//           alignment: Alignment.center,
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Icon(Icons.logout, size: 18, color: AppColors.error),
//               const SizedBox(width: 8),
//               Text('Log out',
//                   style: AppText.body(15,
//                       color: AppColors.error, weight: FontWeight.w700)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_theme.dart';
import '../../core/data/movie_catalog.dart';
import '../../core/models/movie.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/cloud_sync_service.dart';
import '../../core/state/watchlist_controller.dart';
import '../../core/widgets/brand_header.dart';
import '../auth/login_page.dart';
import '../home/widgets/poster_row.dart';
import '../home/widgets/section_header.dart';
import 'widgets/edit_profile_sheet.dart';
import 'widgets/favorite_genres_section.dart';
import 'widgets/profile_header_card.dart';
import 'widgets/profile_stats_row.dart';
import 'widgets/settings_section.dart';
import 'widgets/taste_card.dart';

/// شاشة Profile — بنفس تصميم Home: هيدر، كروت، عناوين أقسام، وكلها
/// مربوطة ببيانات حقيقية (Watchlist, المشاهدات, التفضيلات).
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.onNavigate});

  final ValueChanged<int> onNavigate;

  static const _aiTabIndex = 2;
  static const _watchlistTabIndex = 3;

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Log out?', style: AppText.heading(18, weight: FontWeight.w700)),
        content: Text('You can log back in anytime.',
            style: AppText.body(13, color: AppColors.textMuted)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Cancel', style: AppText.body(13, color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('Log out',
                style: AppText.body(13, color: AppColors.error, weight: FontWeight.w700)),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    // بيحفظ أي تغيير معلّق في السحابة، يطلع من الحساب، ويمسح البيانات المحلية.
    await AuthService.instance.signOut();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
          children: [
            const BrandHeader(sectionLabel: 'PROFILE'),
            const SizedBox(height: 18),
            Text('Your Profile', style: AppText.heading(21, weight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text('Manage your taste, lists, and settings',
                style: AppText.body(13, color: AppColors.textMuted)),
            const SizedBox(height: 16),
            ProfileHeaderCard(onEdit: () => showEditProfileSheet(context)),
            ValueListenableBuilder<String?>(
              valueListenable: CloudSyncService.instance.syncError,
              builder: (_, error, __) => error == null
                  ? const SizedBox(height: 12)
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          const Icon(Icons.cloud_off_outlined,
                              size: 15, color: AppColors.amber),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(error,
                                style: AppText.body(11.5, color: AppColors.amber)),
                          ),
                        ],
                      ),
                    ),
            ),
            const ProfileStatsRow(),
            const SizedBox(height: 16),
            TasteCard(onAskAi: () => onNavigate(_aiTabIndex)),
            const SizedBox(height: 22),
            SectionHeader(
              icon: Icons.bookmark_border,
              title: 'My Watchlist',
              onAction: () => onNavigate(_watchlistTabIndex),
            ),
            const SizedBox(height: 12),
            const _WatchlistPreview(),
            const SizedBox(height: 22),
            const SectionHeader(
              icon: Icons.favorite_border,
              title: 'Favorite Genres',
              actionLabel: null,
            ),
            const SizedBox(height: 12),
            const FavoriteGenresSection(),
            const SizedBox(height: 22),
            const SectionHeader(
              icon: Icons.settings_outlined,
              title: 'Settings',
              actionLabel: null,
            ),
            const SizedBox(height: 12),
            const SettingsSection(),
            const SizedBox(height: 22),
            _LogoutButton(onTap: () => _confirmLogout(context)),
            const SizedBox(height: 14),
            Center(
              child: Text('MovieMind v1.0.0',
                  style: AppText.body(11, color: AppColors.textDim)),
            ),
          ],
        ),
      ),
    );
  }
}

class _WatchlistPreview extends StatelessWidget {
  const _WatchlistPreview();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<String>>(
      valueListenable: WatchlistController.instance.ids,
      builder: (_, ids, __) {
        final movies = ids.map(MovieCatalog.byId).whereType<Movie>().toList();
        if (movies.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text('Nothing saved yet — tap the bookmark on any movie.',
                textAlign: TextAlign.center,
                style: AppText.body(12.5, color: AppColors.textMuted)),
          );
        }
        return PosterRow(movies: movies);
      },
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          height: 52,
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.logout, size: 18, color: AppColors.error),
              const SizedBox(width: 8),
              Text('Log out',
                  style: AppText.body(15,
                      color: AppColors.error, weight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}
