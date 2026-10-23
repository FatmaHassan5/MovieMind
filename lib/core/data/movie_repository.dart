import '../models/movie.dart';
import '../services/tmdb_client.dart';
import '../utils/app_dates.dart';
import 'movie_catalog.dart';
import 'tmdb_mapper.dart';

enum SearchKind { all, movies, tvShows, people }

class _CacheEntry {
  _CacheEntry(this.value) : at = DateTime.now();

  final Object? value;
  final DateTime at;
}

/// الوصول لبيانات الأفلام الحقيقية من TMDB (مع كاش 10 دقايق لتقليل الطلبات).
/// كل فيلم بيرجع بيتسجّل في [MovieCatalog] عشان باقي الشاشات تلاقيه بالـ id.
class MovieRepository {
  MovieRepository._();
  static final MovieRepository instance = MovieRepository._();

  static const _ttl = Duration(minutes: 10);

  final _client = TmdbClient.instance;
  final Map<String, _CacheEntry> _cache = {};

  void clearCache() => _cache.clear();

  Future<T> _cached<T>(String key, Future<T> Function() loader) async {
    final hit = _cache[key];
    if (hit != null && DateTime.now().difference(hit.at) < _ttl) return hit.value as T;
    final value = await loader();
    _cache[key] = _CacheEntry(value);
    return value;
  }

  List<Movie> _parse(Object? results, {bool? tv}) {
    final out = <Movie>[];
    if (results is List) {
      for (final item in results) {
        if (item is Map<String, dynamic>) {
          final movie = TmdbMapper.fromList(item, tv: tv);
          if (movie != null) out.add(movie);
        }
      }
    }
    MovieCatalog.register(out);
    return out;
  }

  static String _iso(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  // ---------------------------------------------------------------- lists

  /// الأكتر رواجًا هذا الأسبوع.
  Future<List<Movie>> trending({bool tv = false}) => _cached('trending-$tv', () async {
        final json = await _client.get('/trending/${tv ? 'tv' : 'movie'}/week');
        return _parse(json['results'], tv: tv);
      });

  /// الأفلام الشائعة، أو الأشهر في تصنيف معيّن (مثلاً "Sci-Fi").
  Future<List<Movie>> popular({String? genre}) {
    final genreId = genre == null ? null : TmdbMapper.genreIdFor(genre);
    return _cached('popular-${genreId ?? 'all'}', () async {
      final json = genreId == null
          ? await _client.get('/movie/popular')
          : await _client.get('/discover/movie', {
              'with_genres': '$genreId',
              'sort_by': 'popularity.desc',
              'vote_count.gte': '200',
              'include_adult': 'false',
            });
      return _parse(json['results'], tv: false);
    });
  }

  /// الأفلام اللي هتنزل خلال 6 شهور، مرتبة بالتاريخ.
  Future<List<Movie>> upcoming() => _cached('upcoming', () async {
        final from = _iso(AppDates.today());
        final to = _iso(AppDates.daysFromToday(180));
        final pages = await Future.wait([
          for (var page = 1; page <= 3; page++)
            _client.get('/discover/movie', {
              'primary_release_date.gte': from,
              'primary_release_date.lte': to,
              'sort_by': 'popularity.desc',
              'include_adult': 'false',
              'page': '$page',
            }),
        ]);
        final seen = <String>{};
        final movies = <Movie>[];
        for (final json in pages) {
          for (final m in _parse(json['results'], tv: false)) {
            if (m.releaseDate != null && seen.add(m.id)) movies.add(m);
          }
        }
        movies.sort((a, b) => a.releaseDate!.compareTo(b.releaseDate!));
        return movies;
      });

  // --------------------------------------------------------------- search

  Future<List<Movie>> search(String query, SearchKind kind) {
    final q = query.trim();
    return _cached('search-${kind.name}-${q.toLowerCase()}', () async {
      switch (kind) {
        case SearchKind.movies:
          final json = await _client.get('/search/movie', {'query': q, 'include_adult': 'false'});
          return _parse(json['results'], tv: false);
        case SearchKind.tvShows:
          final json = await _client.get('/search/tv', {'query': q, 'include_adult': 'false'});
          return _parse(json['results'], tv: true);
        case SearchKind.all:
          final json = await _client.get('/search/multi', {'query': q, 'include_adult': 'false'});
          final results = (json['results'] as List?)
              ?.where((r) => r is Map && (r['media_type'] == 'movie' || r['media_type'] == 'tv'))
              .toList();
          return _parse(results);
        case SearchKind.people:
          // نبحث عن الشخص ونعرض الأعمال المشهور بيها.
          final json = await _client.get('/search/person', {'query': q, 'include_adult': 'false'});
          final known = <Object?>[];
          for (final person in (json['results'] as List? ?? const []).take(3)) {
            if (person is Map && person['known_for'] is List) known.addAll(person['known_for'] as List);
          }
          final movies = _parse(known.where((k) => k is Map && k['media_type'] != 'person').toList());
          final seen = <String>{};
          return movies.where((m) => seen.add(m.id)).toList();
      }
    });
  }

  /// بيدوّر على فيلم/مسلسل باسمه (وسنته لو معروفة) — بيستخدمه الشات لتحويل
  /// أسماء الأفلام اللي الـ AI رشّحها لبيانات حقيقية. بيرجع null لو ملقاش.
  Future<Movie?> resolveTitle(String title, {String? year, bool tv = false}) async {
    final q = title.trim();
    if (q.isEmpty) return null;
    final y = int.tryParse(year ?? '');

    Future<List<Movie>> run(Map<String, String> extra) async {
      final json = await _client.get(tv ? '/search/tv' : '/search/movie', {
        'query': q,
        'include_adult': 'false',
        ...extra,
      });
      return _parse(json['results'], tv: tv);
    }

    var results = await run({if (y != null) (tv ? 'first_air_date_year' : 'year'): '$y'});
    if (results.isEmpty && y != null) results = await run({});
    if (results.isEmpty) return null;

    final lower = q.toLowerCase();
    return results.take(5).firstWhere(
          (m) => m.title.toLowerCase() == lower,
          orElse: () => results.first,
        );
  }

  // -------------------------------------------------------------- details

  /// التفاصيل الكاملة (المدة، الطاقم، الشعار...). بتتسجل في الـ catalog.
  Future<Movie> details(Movie base) async {
    final tmdbId = base.tmdbId;
    if (tmdbId == null) return base;
    return _cached('details-${base.id}', () async {
      final json = await _client.get(
        '/${base.isTvShow ? 'tv' : 'movie'}/$tmdbId',
        {'append_to_response': 'credits'},
      );
      final detailed = TmdbMapper.fromDetails(json, isTv: base.isTvShow);
      if (detailed == null) return base;
      MovieCatalog.register([detailed]);
      return MovieCatalog.byId(detailed.id) ?? detailed;
    });
  }

  /// أعمال مشابهة/مقترحة بناءً على فيلم.
  Future<List<Movie>> similar(Movie base) async {
    final tmdbId = base.tmdbId;
    if (tmdbId == null) return const [];
    return _cached('similar-${base.id}', () async {
      final json =
          await _client.get('/${base.isTvShow ? 'tv' : 'movie'}/$tmdbId/recommendations');
      return _parse(json['results'], tv: base.isTvShow)
          .where((m) => m.posterAsset.isNotEmpty)
          .toList();
    });
  }

  /// ترندات محفوظة في الكاش (من غير أي طلب شبكة) — للـ AI كسياق.
  List<Movie> peekTrending() {
    final hit = _cache['trending-false'];
    return hit == null ? const [] : (hit.value as List<Movie>);
  }

  List<Movie> peekUpcoming() {
    final hit = _cache['upcoming'];
    return hit == null ? const [] : (hit.value as List<Movie>);
  }
}
