

import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_theme.dart';
import '../../core/data/movie_catalog.dart';
import '../../core/models/movie.dart';
import '../../core/state/watchlist_controller.dart';
import '../../core/utils/duration_utils.dart';
import '../../core/widgets/brand_header.dart';
import '../../core/widgets/pill_chip.dart';
import 'widgets/ai_prioritizer_banner.dart';
import 'widgets/watchlist_item_tile.dart';
import 'widgets/watchlist_tabs.dart';

/// شاشة My Watchlist — بتعرض كل فيلم اتحفظ من أي شاشة تانية في التطبيق،
/// وبتتحدث فورًا أول ما حد يضيف/يشيل عنصر (WatchlistController).
class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key, required this.onNavigate});

  final ValueChanged<int> onNavigate;

  static const _aiTabIndex = 2;

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  WatchlistFilter _filter = WatchlistFilter.all;
  String _sortBy = 'Recently Added';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ValueListenableBuilder<List<String>>(
          valueListenable: WatchlistController.instance.ids,
          builder: (_, ids, __) {
            final saved = ids.map(MovieCatalog.byId).whereType<Movie>().toList();
            final movies = _applySort(_applyFilter(saved));
            final moviesCount = saved.where((m) => !m.isTvShow).length;
            final tvCount = saved.where((m) => m.isTvShow).length;
            final sciFiCount =
                saved.where((m) => m.genre.toLowerCase().contains('sci-fi')).length;

            return ListView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
              children: [
                BrandHeader(
                  sectionLabel: 'WATCHLIST',
                  onAvatarTap: () => widget.onNavigate(4),
                ),
                const SizedBox(height: 16),
                AiPrioritizerBanner(
                  sciFiCount: sciFiCount,
                  onDecide: () => widget.onNavigate(WatchlistPage._aiTabIndex),
                ),
                const SizedBox(height: 22),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('My Watchlist',
                              style: AppText.heading(23, weight: FontWeight.w700)),
                          const SizedBox(height: 3),
                          Text(
                            '${saved.length} ${saved.length == 1 ? "title" : "titles"} '
                            'curated & saved to watch',
                            style: AppText.body(12, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                    PillChip(
                      label: DurationUtils.totalHoursLabel(saved),
                      icon: Icons.schedule,
                      background: AppColors.surface,
                      foreground: AppColors.textMuted,
                      iconColor: AppColors.textDim,
                      fontSize: 11,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                WatchlistTabs(
                  value: _filter,
                  onChanged: (f) => setState(() => _filter = f),
                  allCount: saved.length,
                  moviesCount: moviesCount,
                  tvCount: tvCount,
                ),
                const SizedBox(height: 14),
                _SortRow(sortBy: _sortBy, onChanged: (v) => setState(() => _sortBy = v)),
                const SizedBox(height: 16),
                if (movies.isEmpty)
                  const _EmptyWatchlist()
                else
                  for (final movie in movies) WatchlistItemTile(movie: movie),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Movie> _applyFilter(List<Movie> movies) {
    switch (_filter) {
      case WatchlistFilter.movies:
        return movies.where((m) => !m.isTvShow).toList();
      case WatchlistFilter.tvShows:
        return movies.where((m) => m.isTvShow).toList();
      case WatchlistFilter.all:
        return movies;
    }
  }

  List<Movie> _applySort(List<Movie> movies) {
    final sorted = [...movies];
    if (_sortBy == 'A-Z') {
      sorted.sort((a, b) => a.title.compareTo(b.title));
    } else if (_sortBy == 'Top Rated') {
      sorted.sort((a, b) => (b.rating ?? '0').compareTo(a.rating ?? '0'));
    }
    // "Recently Added" بيسيب ترتيب الإضافة الأصلي زي ما هو.
    return sorted;
  }
}

class _SortRow extends StatelessWidget {
  const _SortRow({required this.sortBy, required this.onChanged});

  final String sortBy;
  final ValueChanged<String> onChanged;

  static const _options = ['Recently Added', 'Top Rated', 'A-Z'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PopupMenuButton<String>(
          color: AppColors.surfaceHigh,
          onSelected: onChanged,
          itemBuilder: (_) => _options
              .map((o) => PopupMenuItem(value: o, child: Text(o, style: AppText.body(13))))
              .toList(),
          child: PillChip(
            label: sortBy,
            icon: Icons.sort,
            background: AppColors.surface,
            foreground: AppColors.text,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 8),
        const PillChip(
          label: 'Genre',
          icon: Icons.filter_list,
          background: AppColors.surface,
          foreground: AppColors.text,
          fontSize: 12,
        ),
      ],
    );
  }
}

class _EmptyWatchlist extends StatelessWidget {
  const _EmptyWatchlist();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
                color: AppColors.surface, shape: BoxShape.circle),
            child: const Icon(Icons.bookmark_border, size: 30, color: AppColors.textDim),
          ),
          const SizedBox(height: 16),
          Text('Nothing here yet',
              style: AppText.heading(16, weight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text('Save movies and shows to watch them later.',
              style: AppText.body(12.5, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
