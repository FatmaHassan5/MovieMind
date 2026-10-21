// import 'package:flutter/material.dart';

// import '../../core/app_colors.dart';
// import '../../core/app_theme.dart';
// import 'data/demo_results.dart';
// import 'widgets/ai_insight_banner.dart';
// import 'widgets/category_filter_tabs.dart';
// import 'widgets/empty_results_view.dart';
// import 'widgets/filter_panel_view.dart';
// import 'widgets/recent_searches_view.dart';
// import 'widgets/results_header.dart';
// import 'widgets/search_input_bar.dart';
// import 'widgets/search_result_card.dart';
// import 'widgets/search_state_tabs.dart';

// /// شاشة Explore Cinema (البحث). onNavigate بتوديك لتاب AI Mind من بانر التحليل.
// class SearchPage extends StatefulWidget {
//   const SearchPage({super.key, required this.onNavigate});

//   final ValueChanged<int> onNavigate;

//   static const _aiTabIndex = 2;

//   @override
//   State<SearchPage> createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   final _controller = TextEditingController(text: 'Interstellar');
//   SearchViewState _state = SearchViewState.results;
//   int _category = 0;
//   String _sortBy = 'Top Rated';

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _setState(SearchViewState s) => setState(() => _state = s);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SafeArea(
//         child: ListView(
//           padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: Text('Explore Cinema',
//                       style: AppText.heading(20, weight: FontWeight.w700)),
//                 ),
//                 Container(
//                   width: 34,
//                   height: 34,
//                   decoration: const BoxDecoration(
//                       color: AppColors.surface, shape: BoxShape.circle),
//                   child: const Icon(Icons.play_arrow_rounded,
//                       size: 18, color: AppColors.primary),
//                 ),
//               ],
//             ),
//             Text('Find your next movie, show, or actor',
//                 style: AppText.body(12.5, color: AppColors.textMuted)),
//             const SizedBox(height: 14),
//             SearchStateTabs(value: _state, onChanged: _setState),
//             const SizedBox(height: 14),
//             SearchInputBar(
//               controller: _controller,
//               onChanged: (_) => setState(() {}),
//               onClear: () => setState(_controller.clear),
//               onFilterTap: () => _setState(SearchViewState.filterUI),
//             ),
//             const SizedBox(height: 14),
//             CategoryFilterTabs(
//                 selected: _category, onChanged: (i) => setState(() => _category = i)),
//             const SizedBox(height: 18),
//             _buildBody(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBody() {
//     switch (_state) {
//       case SearchViewState.recent:
//         return RecentSearchesView(
//           items: DemoResults.recentSearches,
//           onTap: (q) {
//             _controller.text = q;
//             _setState(SearchViewState.results);
//           },
//         );
//       case SearchViewState.filterUI:
//         return const FilterPanelView();
//       case SearchViewState.empty:
//         return const EmptyResultsView();
//       case SearchViewState.results:
//         final results = DemoResults.interstellarQuery;
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ResultsHeader(
//               count: results.length * 4,
//               sortBy: _sortBy,
//               onSortChanged: (v) => setState(() => _sortBy = v),
//             ),
//             const SizedBox(height: 14),
//             GridView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: results.length,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 mainAxisSpacing: 16,
//                 crossAxisSpacing: 12,
//                 childAspectRatio: 0.62,
//               ),
//               itemBuilder: (_, i) => SearchResultCard(result: results[i]),
//             ),
//             const SizedBox(height: 18),
//             AiInsightBanner(
//               query: _controller.text.isEmpty ? 'this title' : _controller.text,
//               onAskAi: () => widget.onNavigate(SearchPage._aiTabIndex),
//             ),
//           ],
//         );
//     }
//   }
// }

import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_theme.dart';
import '../../core/data/movie_catalog.dart';
import '../../core/models/movie.dart';
import 'widgets/ai_insight_banner.dart';
import 'widgets/category_filter_tabs.dart';
import 'widgets/empty_results_view.dart';
import 'widgets/filter_panel_view.dart';
import 'widgets/recent_searches_view.dart';
import 'widgets/results_header.dart';
import 'widgets/search_input_bar.dart';
import 'widgets/search_result_card.dart';
import 'widgets/search_state_tabs.dart';

/// شاشة Explore Cinema (البحث). onNavigate بتوديك لتاب AI Mind من بانر التحليل.
/// البحث بيفلتر فعليًا على MovieCatalog كل ما المستخدم يكتب.
class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.onNavigate});

  final ValueChanged<int> onNavigate;

  static const _aiTabIndex = 2;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static const _recentSearches = [
    'Interstellar',
    'Dune: Part Two',
    'Christopher Nolan',
    'Oppenheimer',
    'Sci-Fi movies',
  ];

  final _controller = TextEditingController(text: 'Interstellar');
  SearchViewState _state = SearchViewState.results;
  int _category = 0;
  String _sortBy = 'Top Rated';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setState(SearchViewState s) => setState(() => _state = s);

  /// بيرجع النتائج المفلترة فعليًا حسب نص البحث + فئة الفلتر المختارة.
  List<Movie> get _filteredResults {
    final base = MovieCatalog.search(_controller.text);
    switch (_category) {
      case 1: // Movies
        return base.where((m) => !m.isTvShow).toList();
      case 2: // TV Shows
        return base.where((m) => m.isTvShow).toList();
      case 3: // People & Cast — لسه مفيش بيانات ممثلين في الكاتالوج
        return const [];
      default: // All
        return base;
    }
  }

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
              onChanged: (_) => setState(() {}),
              onClear: () => setState(_controller.clear),
              onFilterTap: () => _setState(SearchViewState.filterUI),
            ),
            const SizedBox(height: 14),
            CategoryFilterTabs(
                selected: _category, onChanged: (i) => setState(() => _category = i)),
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
          items: _recentSearches,
          onTap: (q) {
            _controller.text = q;
            _setState(SearchViewState.results);
          },
        );
      case SearchViewState.filterUI:
        return const FilterPanelView();
      case SearchViewState.empty:
        return const EmptyResultsView();
      case SearchViewState.results:
        final results = _filteredResults;
        if (results.isEmpty) return const EmptyResultsView();
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
              query: _controller.text.isEmpty ? 'this title' : _controller.text,
              onAskAi: () => widget.onNavigate(SearchPage._aiTabIndex),
            ),
          ],
        );
    }
  }
}
