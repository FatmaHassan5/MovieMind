

import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_theme.dart';
import '../../core/data/movie_repository.dart';
import '../../core/models/movie.dart';
import '../../core/utils/app_dates.dart';
import '../../core/widgets/future_section.dart';
import '../../core/widgets/pill_chip.dart';
import '../home/widgets/coming_soon_tile.dart';
import 'widgets/calendar_grid.dart';
import 'widgets/calendar_month_header.dart';

/// تقويم الإصدارات: أفلام حقيقية هتنزل خلال 6 شهور (من TMDB). بتنقلي بين الشهور،
/// بتختاري يوم عشان تشوفي أفلامه، وتقدري تفعّلي "Remind Me" لأي فيلم.
class ReleaseCalendarPage extends StatefulWidget {
  const ReleaseCalendarPage({super.key});

  @override
  State<ReleaseCalendarPage> createState() => _ReleaseCalendarPageState();
}

class _ReleaseCalendarPageState extends State<ReleaseCalendarPage> {
  late DateTime _month = DateTime(AppDates.today().year, AppDates.today().month);
  DateTime? _selected;
  late Future<List<Movie>> _future = MovieRepository.instance.upcoming();

  void _reload() => setState(() => _future = MovieRepository.instance.upcoming());

  void _shiftMonth(int delta) => setState(() {
        _month = DateTime(_month.year, _month.month + delta);
        _selected = null;
      });

  void _goToToday() => setState(() {
        final today = AppDates.today();
        _month = DateTime(today.year, today.month);
        _selected = today;
      });

  void _select(DateTime day) => setState(() {
        final same = _selected != null && AppDates.isSameDay(_selected!, day);
        _selected = same ? null : day;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FutureBuilder<List<Movie>>(
          future: _future,
          builder: (context, snapshot) {
            final loading = snapshot.connectionState != ConnectionState.done;
            final scheduled = snapshot.data ?? const <Movie>[];
            return _buildContent(scheduled, loading: loading, error: snapshot.error);
          },
        ),
      ),
    );
  }

  Widget _buildContent(List<Movie> scheduled, {required bool loading, Object? error}) {
    bool hasRelease(DateTime d) =>
        scheduled.any((m) => AppDates.isSameDay(m.releaseDate!, d));

    final visible = _selected != null
        ? scheduled.where((m) => AppDates.isSameDay(m.releaseDate!, _selected!)).toList()
        : scheduled.where((m) => AppDates.isSameMonth(m.releaseDate!, _month)).toList();

    final heading = _selected != null
        ? 'Releases on ${AppDates.shortDate(_selected!)}'
        : 'Releases in ${AppDates.monthName(_month.month)}';

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
      children: [
        _TopBar(onToday: _goToToday),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            children: [
              CalendarMonthHeader(
                month: _month,
                onPrevious: () => _shiftMonth(-1),
                onNext: () => _shiftMonth(1),
              ),
              const SizedBox(height: 12),
              CalendarGrid(
                month: _month,
                selected: _selected,
                hasRelease: hasRelease,
                onSelect: _select,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Text(heading, style: AppText.heading(16, weight: FontWeight.w700)),
            ),
            if (!loading && error == null)
              PillChip(
                label: '${visible.length} ${visible.length == 1 ? "release" : "releases"}',
                background: AppColors.surfaceHigh,
                foreground: AppColors.textMuted,
                fontSize: 11,
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (loading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 36),
            child: Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
              ),
            ),
          )
        else if (error != null)
          ErrorRetry(message: error.toString(), onRetry: _reload)
        else if (visible.isEmpty)
          const _EmptyReleases()
        else
          for (final movie in visible) ComingSoonTile(movie: movie),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onToday});

  final VoidCallback onToday;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
          child: Container(
            width: 38,
            height: 38,
            decoration:
                const BoxDecoration(color: AppColors.surface, shape: BoxShape.circle),
            child: const Icon(Icons.arrow_back, size: 19, color: AppColors.text),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Release Calendar',
                  style: AppText.heading(20, weight: FontWeight.w700)),
              Text('Never miss a premiere',
                  style: AppText.body(12, color: AppColors.textMuted)),
            ],
          ),
        ),
        GestureDetector(
          onTap: onToday,
          child: const PillChip(
            label: 'Today',
            icon: Icons.today,
            fontSize: 12,
            background: AppColors.surface,
          ),
        ),
      ],
    );
  }
}

class _EmptyReleases extends StatelessWidget {
  const _EmptyReleases();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 36),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration:
                const BoxDecoration(color: AppColors.surface, shape: BoxShape.circle),
            child: const Icon(Icons.event_busy, size: 26, color: AppColors.textDim),
          ),
          const SizedBox(height: 14),
          Text('No releases here', style: AppText.body(14, weight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text('Pick a day marked with a green dot.',
              style: AppText.body(12, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
