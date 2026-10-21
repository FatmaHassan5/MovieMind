

// import 'package:flutter/material.dart';

// import '../../core/app_colors.dart';
// import '../../core/app_theme.dart';
// import '../../core/data/movie_catalog.dart';
// import '../../core/models/movie.dart';
// import '../../core/widgets/brand_header.dart';
// import 'widgets/ai_promo_card.dart';
// import 'widgets/coming_soon_tile.dart';
// import 'widgets/genre_chips.dart';
// import 'widgets/home_search_bar.dart';
// import 'widgets/movie_poster_card.dart';
// import 'widgets/section_header.dart';

// /// شاشة Home الرئيسية. onNavigate بتسمحلها تنقل لأي تاب تاني في MainShell
// /// (زي الضغط على البحث أو "Start Chat").
// class HomePage extends StatelessWidget {
//   const HomePage({super.key, required this.onNavigate});

//   final ValueChanged<int> onNavigate;

//   static const _searchTabIndex = 1;
//   static const _aiTabIndex = 2;
//   static const _profileTabIndex = 4;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SafeArea(
//         child: ListView(
//           padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
//           children: [
//             BrandHeader(
//               sectionLabel: 'HOME',
//               onAvatarTap: () => onNavigate(_profileTabIndex),
//             ),
//             const SizedBox(height: 18),
//             Text('Good evening 👋',
//                 style: AppText.heading(21, weight: FontWeight.w700)),
//             const SizedBox(height: 2),
//             Text('What are you watching today?',
//                 style: AppText.body(13, color: AppColors.textMuted)),
//             const SizedBox(height: 16),
//             HomeSearchBar(onTap: () => onNavigate(_searchTabIndex)),
//             const SizedBox(height: 16),
//             AiPromoCard(onStartChat: () => onNavigate(_aiTabIndex)),
//             const SizedBox(height: 20),
//             SectionHeader(
//               icon: Icons.filter_list,
//               title: 'Explore Genres',
//               actionLabel: 'All',
//               onAction: () => onNavigate(_searchTabIndex),
//             ),
//             const SizedBox(height: 10),
//             const GenreChips(),
//             const SizedBox(height: 22),
//             SectionHeader(
//               icon: Icons.local_fire_department_outlined,
//               title: 'Trending Now',
//               onAction: () => onNavigate(_searchTabIndex),
//             ),
//             const SizedBox(height: 12),
//             _PosterRow(movies: MovieCatalog.trending),
//             const SizedBox(height: 22),
//             SectionHeader(
//               icon: Icons.thumb_up_outlined,
//               title: 'Popular Movies',
//               onAction: () => onNavigate(_searchTabIndex),
//             ),
//             const SizedBox(height: 12),
//             _PosterRow(movies: MovieCatalog.popular),
//             const SizedBox(height: 22),
//             SectionHeader(
//               icon: Icons.calendar_today_outlined,
//               title: 'Coming Soon',
//               actionLabel: 'Calendar',
//             ),
//             const SizedBox(height: 12),
//             for (final movie in MovieCatalog.comingSoon) ComingSoonTile(movie: movie),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// صف بوسترات أفقي. الارتفاع محسوب يدويًا (بوستر 2:3 + مسافة + سطرين نص)
// /// عشان مايحصلش overflow تحت الكروت.
// class _PosterRow extends StatelessWidget {
//   const _PosterRow({required this.movies});

//   final List<Movie> movies;

//   static const _cardWidth = 150.0;
//   static const _rowHeight = 272.0; // (150 * 1.5) + 7 + ~40 (سطرين نص) + هامش أمان

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: _rowHeight,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         itemCount: movies.length,
//         separatorBuilder: (_, __) => const SizedBox(width: 12),
//         itemBuilder: (_, i) => MoviePosterCard(movie: movies[i], width: _cardWidth),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_theme.dart';
import '../../core/data/movie_catalog.dart';
import '../../core/widgets/brand_header.dart';
import '../calendar/release_calendar_page.dart';
import 'widgets/ai_promo_card.dart';
import 'widgets/coming_soon_tile.dart';
import 'widgets/genre_chips.dart';
import 'widgets/home_search_bar.dart';
import 'widgets/poster_row.dart';
import 'widgets/section_header.dart';

/// شاشة Home الرئيسية. onNavigate بتسمحلها تنقل لأي تاب تاني في MainShell
/// (زي الضغط على البحث أو "Start Chat").
class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.onNavigate});

  final ValueChanged<int> onNavigate;

  static const _searchTabIndex = 1;
  static const _aiTabIndex = 2;
  static const _profileTabIndex = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
          children: [
            BrandHeader(
              sectionLabel: 'HOME',
              onAvatarTap: () => onNavigate(_profileTabIndex),
            ),
            const SizedBox(height: 18),
            Text('Good evening 👋',
                style: AppText.heading(21, weight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text('What are you watching today?',
                style: AppText.body(13, color: AppColors.textMuted)),
            const SizedBox(height: 16),
            HomeSearchBar(onTap: () => onNavigate(_searchTabIndex)),
            const SizedBox(height: 16),
            AiPromoCard(onStartChat: () => onNavigate(_aiTabIndex)),
            const SizedBox(height: 20),
            SectionHeader(
              icon: Icons.filter_list,
              title: 'Explore Genres',
              actionLabel: 'All',
              onAction: () => onNavigate(_searchTabIndex),
            ),
            const SizedBox(height: 10),
            const GenreChips(),
            const SizedBox(height: 22),
            SectionHeader(
              icon: Icons.local_fire_department_outlined,
              title: 'Trending Now',
              onAction: () => onNavigate(_searchTabIndex),
            ),
            const SizedBox(height: 12),
            PosterRow(movies: MovieCatalog.trending),
            const SizedBox(height: 22),
            SectionHeader(
              icon: Icons.thumb_up_outlined,
              title: 'Popular Movies',
              onAction: () => onNavigate(_searchTabIndex),
            ),
            const SizedBox(height: 12),
            PosterRow(movies: MovieCatalog.popular),
            const SizedBox(height: 22),
            SectionHeader(
              icon: Icons.calendar_today_outlined,
              title: 'Coming Soon',
              actionLabel: 'Calendar',
              onAction: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ReleaseCalendarPage()),
              ),
            ),
            const SizedBox(height: 12),
            for (final movie in MovieCatalog.upcoming.take(3)) ComingSoonTile(movie: movie),
          ],
        ),
      ),
    );
  }
}
