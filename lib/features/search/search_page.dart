

import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_theme.dart';
import '../../core/data/movie_repository.dart';
import '../../core/models/movie.dart';
import '../../core/widgets/future_section.dart';
import 'widgets/ai_insight_banner.dart';
import 'widgets/category_filter_tabs.dart';
import 'widgets/empty_results_view.dart';
import 'widgets/filter_panel_view.dart';
import 'widgets/recent_searches_view.dart';
import 'widgets/results_header.dart';
import 'widgets/search_input_bar.dart';
import 'widgets/search_result_card.dart';
import 'widgets/search_state_tabs.dart';

/// شاشة Explore Cinema — بحث حقيقي في TMDB (أفلام، مسلسلات، ممثلين).
/// البحث بيتنفذ تلقائيًا بعد ما تقفي عن الكتابة، والفلاتر والترتيب بتتطبق على النتايج.
/// لو مفيش بحث بيظهر الـ Trending.
class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.onNavigate});

  final ValueChanged<int> onNavigate;

  static const _aiTabIndex = 2;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static const _debounce = Duration(milliseconds: 450);

  final _controller = TextEditingController();
  final _repo = MovieRepository.instance;
  final List<String> _recent = [];
  Timer? _timer;

  SearchViewState _state = SearchViewState.results;
  int _category = 0;
  String _sortBy = 'Relevance';
  late Future<List<Movie>> _future = _fetch();

  // الفلاتر
  final Set<String> _genres = {};
  String? _era;
  double _minRating = 0;

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  SearchKind get _kind => SearchKind.values[_category];

  Future<List<Movie>> _fetch() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return _repo.trending(tv: _kind == SearchKind.tvShows);
    final results = await _repo.search(query, _kind);
    _remember(query);
    return results;
  }

  void _remember(String query) {
    _recent
      ..removeWhere((q) => q.toLowerCase() == query.toLowerCase())
      ..insert(0, query);
    if (_recent.length > 8) _recent.removeLast();
  }

  void _load() => setState(() => _future = _fetch());

  void _onQueryChanged(String _) {
    setState(() {}); // عشان زرار المسح يظهر/يختفي
    _timer?.cancel();
    _timer = Timer(_debounce, _load);
  }

  void _clearQuery() {
    _controller.clear();
    _timer?.cancel();
    _load();
  }

  void _setState(SearchViewState s) => setState(() => _state = s);

  // ------------------------------------------------------- فلاتر وترتيب

  bool _passesFilters(Movie m) {
    if (_genres.isNotEmpty) {
      final text = m.genre.toLowerCase();
      if (!_genres.any((g) => text.contains(g.toLowerCase()))) return false;
    }
    if (_minRating > 0) {
      final rating = double.tryParse(m.rating ?? '');
      if (rating == null || rating < _minRating) return false;
    }
    if (_era != null) {
      final year = int.tryParse(m.year);
      if (year == null) return false;
      switch (_era) {
        case '2020s':
          if (year < 2020) return false;
        case '2010s':
          if (year < 2010 || year > 2019) return false;
        case '2000s':
          if (year < 2000 || year > 2009) return false;
        case 'Classic':
          if (year >= 2000) return false;
      }
    }
    return true;
  }

  List<Movie> _prepare(List<Movie> raw) {
    final list = raw.where(_passesFilters).toList();
    switch (_sortBy) {
      case 'Top Rated':
        list.sort((a, b) => (double.tryParse(b.rating ?? '') ?? 0)
            .compareTo(double.tryParse(a.rating ?? '') ?? 0));
      case 'Newest':
        list.sort((a, b) => (b.releaseDate ?? DateTime(1900))
            .compareTo(a.releaseDate ?? DateTime(1900)));
      case 'A-Z':
        list.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    }
    return list;
  }

  void _resetFilters() => setState(() {
        _genres.clear();
        _era = null;
        _minRating = 0;
      });

  // ------------------------------------------------------------------ UI

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Explore Cinema',
                      style: AppText.heading(20, weight: FontWeight.w700)),
                ),
                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                      color: AppColors.surface, shape: BoxShape.circle),
                  child: const Icon(Icons.play_arrow_rounded,
                      size: 18, color: AppColors.primary),
                ),
              ],
            ),
            Text('Find your next movie, show, or actor',
                style: AppText.body(12.5, color: AppColors.textMuted)),
            const SizedBox(height: 14),
            SearchStateTabs(value: _state, onChanged: _setState),
            const SizedBox(height: 14),
            SearchInputBar(
              controller: _controller,
              onChanged: _onQueryChanged,
              onClear: _clearQuery,
              onFilterTap: () => _setState(SearchViewState.filterUI),
            ),
            const SizedBox(height: 14),
            CategoryFilterTabs(
              selected: _category,
              onChanged: (i) {
                setState(() => _category = i);
                _load();
              },
            ),
            const SizedBox(height: 18),
            _buildBody(),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_state) {
      case SearchViewState.recent:
        return RecentSearchesView(
          items: _recent,
          onTap: (q) {
            _controller.text = q;
            _setState(SearchViewState.results);
            _load();
          },
        );
      case SearchViewState.filterUI:
        return FilterPanelView(
          genres: _genres,
          era: _era,
          minRating: _minRating,
          onToggleGenre: (g) => setState(() {
            if (!_genres.add(g)) _genres.remove(g);
          }),
          onEraChanged: (e) => setState(() => _era = e),
          onRatingChanged: (v) => setState(() => _minRating = v),
          onReset: _resetFilters,
        );
      case SearchViewState.empty:
        return const EmptyResultsView();
      case SearchViewState.results:
        return FutureSection<List<Movie>>(
          future: _future,
          loadingHeight: 240,
          emptyText: 'No results found. Try a different title, actor, or genre.',
          onRetry: _load,
          builder: (raw) {
            final results = _prepare(raw);
            if (results.isEmpty) return const EmptyResultsView();
            final query = _controller.text.trim();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResultsHeader(
                  count: results.length,
                  sortBy: _sortBy,
                  onSortChanged: (v) => setState(() => _sortBy = v),
                ),
                const SizedBox(height: 14),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: results.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.62,
                  ),
                  itemBuilder: (_, i) => SearchResultCard(movie: results[i]),
                ),
                const SizedBox(height: 18),
                AiInsightBanner(
                  query: query.isEmpty ? 'a movie' : query,
                  onAskAi: () => widget.onNavigate(SearchPage._aiTabIndex),
                ),
              ],
            );
          },
        );
    }
  }
}
