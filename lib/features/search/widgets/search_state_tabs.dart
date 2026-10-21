import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/widgets/pill_chip.dart';

enum SearchViewState { results, recent, filterUI, empty }

/// شريط تبديل حالات المعاينة أعلى شاشة البحث (Results / Recent / Filter UI / Empty).
class SearchStateTabs extends StatelessWidget {
  const SearchStateTabs({super.key, required this.value, required this.onChanged});

  final SearchViewState value;
  final ValueChanged<SearchViewState> onChanged;

  static const _tabs = [
    (SearchViewState.results, Icons.auto_awesome, 'Results'),
    (SearchViewState.recent, Icons.history, 'Recent'),
    (SearchViewState.filterUI, Icons.tune, 'Filter UI'),
    (SearchViewState.empty, Icons.search_off, 'Empty'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final (state, icon, label) = _tabs[i];
          final selected = state == value;
          return GestureDetector(
            onTap: () => onChanged(state),
            child: PillChip(
              label: label,
              icon: icon,
              fontSize: 11.5,
              background: selected ? AppColors.primary : AppColors.surface,
              foreground: selected ? AppColors.onPrimary : AppColors.textMuted,
              iconColor: selected ? AppColors.onPrimary : AppColors.textDim,
              weight: selected ? FontWeight.w700 : FontWeight.w600,
            ),
          );
        },
      ),
    );
  }
}
