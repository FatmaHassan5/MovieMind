


import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_theme.dart';
import '../../core/data/movie_repository.dart';
import '../../core/models/movie.dart';
import '../../core/state/user_controller.dart';
import '../../core/widgets/brand_header.dart';
import '../../core/widgets/future_section.dart';
import '../calendar/release_calendar_page.dart';
import 'widgets/ai_promo_card.dart';
import 'widgets/coming_soon_tile.dart';
import 'widgets/genre_chips.dart';
import 'widgets/home_search_bar.dart';
import 'widgets/poster_row.dart';
import 'widgets/section_header.dart';

/// شاشة Home — بيانات حقيقية من TMDB (Trending / Popular / Coming Soon).
/// onNavigate بتسمحلها تنقل لأي تاب تاني في MainShell.
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.onNavigate});

  final ValueChanged<int> onNavigate;

  static const _searchTabIndex = 1;
  static const _aiTabIndex = 2;
  static const _profileTabIndex = 4;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _repo = MovieRepository.instance;

  String? _genre; // null = كل التصنيفات
  late Future<List<Movie>> _trending = _repo.trending();
  late Future<List<Movie>> _popular = _repo.popular();
  late Future<List<Movie>> _upcoming = _repo.upcoming();

  void _reloadTrending() => setState(() => _trending = _repo.trending());
  void _reloadPopular() => setState(() => _popular = _repo.popular(genre: _genre));
  void _reloadUpcoming() => setState(() => _upcoming = _repo.upcoming());

  void _selectGenre(String? genre) {
    _genre = genre;
    _reloadPopular();
  }

  /// سحب للتحديث: بنمسح الكاش ونجيب كل حاجة من الأول.
  Future<void> _refresh() async {
    _repo.clearCache();
    setState(() {
      _trending = _repo.trending();
      _popular = _repo.popular(genre: _genre);
      _upcoming = _repo.upcoming();
    });
    await Future.wait([_trending, _popular, _upcoming].map((f) => f.catchError((_) => <Movie>[])));
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.surface,
          onRefresh: _refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
            children: [
              BrandHeader(
                sectionLabel: 'HOME',
                onAvatarTap: () => widget.onNavigate(HomePage._profileTabIndex),
              ),
              const SizedBox(height: 18),
              ValueListenableBuilder<String>(
                valueListenable: UserController.instance.name,
                builder: (_, name, __) {
                  final first = name.trim().split(' ').first;
                  return Text('${_greeting()}, $first 👋',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.heading(21, weight: FontWeight.w700));
                },
              ),
              const SizedBox(height: 2),
              Text('What are you watching today?',
                  style: AppText.body(13, color: AppColors.textMuted)),
              const SizedBox(height: 16),
              HomeSearchBar(onTap: () => widget.onNavigate(HomePage._searchTabIndex)),
              const SizedBox(height: 16),
              AiPromoCard(onStartChat: () => widget.onNavigate(HomePage._aiTabIndex)),
              const SizedBox(height: 20),
              SectionHeader(
                icon: Icons.filter_list,
                title: 'Explore Genres',
                actionLabel: 'All',
                onAction: () => widget.onNavigate(HomePage._searchTabIndex),
              ),
              const SizedBox(height: 10),
              GenreChips(onChanged: _selectGenre),
              const SizedBox(height: 22),
              SectionHeader(
                icon: Icons.local_fire_department_outlined,
                title: 'Trending Now',
                onAction: () => widget.onNavigate(HomePage._searchTabIndex),
              ),
              const SizedBox(height: 12),
              FutureSection<List<Movie>>(
                future: _trending,
                loadingHeight: 272,
                onRetry: _reloadTrending,
                builder: (movies) => PosterRow(movies: movies),
              ),
              const SizedBox(height: 22),
              SectionHeader(
                icon: Icons.thumb_up_outlined,
                title: _genre == null ? 'Popular Movies' : 'Popular $_genre Movies',
                onAction: () => widget.onNavigate(HomePage._searchTabIndex),
              ),
              const SizedBox(height: 12),
              FutureSection<List<Movie>>(
                future: _popular,
                loadingHeight: 272,
                onRetry: _reloadPopular,
                builder: (movies) => PosterRow(movies: movies),
              ),
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
              FutureSection<List<Movie>>(
                future: _upcoming,
                loadingHeight: 120,
                onRetry: _reloadUpcoming,
                builder: (movies) => Column(
                  children: [for (final m in movies.take(3)) ComingSoonTile(movie: m)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
