import '../models/movie.dart';
import '../utils/taste_utils.dart';

/// تحويل JSON بتاع TMDB لموديل [Movie].
abstract class TmdbMapper {
  static const _images = 'https://image.tmdb.org/t/p/';

  /// أسماء التصنيفات المختصرة بتاعتنا (نفس الأسماء المستخدمة في Profile).
  static const _genreNames = <int, String>{
    28: 'Action', 12: 'Adventure', 16: 'Animation', 35: 'Comedy', 80: 'Crime',
    99: 'Documentary', 18: 'Drama', 10751: 'Family', 14: 'Fantasy', 36: 'History',
    27: 'Horror', 10402: 'Music', 9648: 'Mystery', 10749: 'Romance', 878: 'Sci-Fi',
    10770: 'TV Movie', 53: 'Thriller', 10752: 'War', 37: 'Western',
    10759: 'Action', 10762: 'Family', 10763: 'News', 10764: 'Reality',
    10765: 'Sci-Fi', 10766: 'Soap', 10767: 'Talk', 10768: 'War',
  };

  /// تصنيفات الأفلام اللي نقدر نفلتر بيها (اسم → id في TMDB).
  static const _discoverIds = <String, int>{
    'Action': 28, 'Adventure': 12, 'Animation': 16, 'Comedy': 35, 'Crime': 80,
    'Drama': 18, 'Family': 10751, 'Fantasy': 14, 'Horror': 27, 'Mystery': 9648,
    'Romance': 10749, 'Sci-Fi': 878, 'Thriller': 53,
  };

  static int? genreIdFor(String name) => _discoverIds[name];

  static String _shortName(String tmdbName) {
    switch (tmdbName) {
      case 'Science Fiction':
      case 'Sci-Fi & Fantasy':
        return 'Sci-Fi';
      case 'Action & Adventure':
        return 'Action';
      case 'War & Politics':
        return 'War';
      default:
        return tmdbName;
    }
  }

  static String _str(Object? value) => value is String ? value : '';

  static String _joinGenres(Iterable<String> names, {required bool isTv}) {
    final unique = <String>[];
    for (final n in names) {
      if (!unique.contains(n)) unique.add(n);
    }
    return unique.isEmpty ? (isTv ? 'TV Show' : 'Movie') : unique.take(3).join(' • ');
  }

  static String? _image(Object? path, String size) {
    final p = _str(path);
    return p.isEmpty ? null : '$_images$size$p';
  }

  static String? _votesLabel(int votes) {
    if (votes >= 1000) return '${(votes / 1000).toStringAsFixed(1)}k votes';
    if (votes >= 50) return '$votes votes';
    return null;
  }

  static String? _rating(num? average, int votes) =>
      (votes > 0 && average != null && average > 0) ? average.toStringAsFixed(1) : null;

  /// عنصر من قائمة نتائج (trending / search / discover ...).
  static Movie? fromList(Map<String, dynamic> j, {bool? tv}) {
    final rawId = j['id'];
    if (rawId is! num) return null;
    final isTv = tv ?? (j['media_type'] == 'tv' || (j['title'] == null && j['name'] != null));
    final title = _str(isTv ? j['name'] : j['title']);
    if (title.isEmpty) return null;

    final date = _str(isTv ? j['first_air_date'] : j['release_date']);
    final votes = (j['vote_count'] as num?)?.toInt() ?? 0;
    final genreIds = (j['genre_ids'] as List?)?.whereType<num>().map((e) => e.toInt()) ?? const <int>[];

    final movie = Movie(
      id: '${isTv ? 't' : 'm'}${rawId.toInt()}',
      title: title,
      year: date.length >= 4 ? date.substring(0, 4) : '',
      genre: _joinGenres(genreIds.map((id) => _genreNames[id]).whereType<String>(), isTv: isTv),
      posterAsset: _image(j['poster_path'], 'w500') ?? '',
      rating: _rating(j['vote_average'] as num?, votes),
      badge: _votesLabel(votes),
      description: _str(j['overview']),
      releaseDate: date.isEmpty ? null : DateTime.tryParse(date),
      isTvShow: isTv,
      backdropUrl: _image(j['backdrop_path'], 'w780'),
    );
    return movie.copyWith(matchPercent: TasteUtils.matchPercent(movie));
  }

  /// استجابة صفحة التفاصيل (/movie/{id} أو /tv/{id} مع credits).
  static Movie? fromDetails(Map<String, dynamic> j, {required bool isTv}) {
    final rawId = j['id'];
    if (rawId is! num) return null;
    final title = _str(isTv ? j['name'] : j['title']);
    if (title.isEmpty) return null;

    final date = _str(isTv ? j['first_air_date'] : j['release_date']);
    final votes = (j['vote_count'] as num?)?.toInt() ?? 0;
    final genreNames = (j['genres'] as List?)
            ?.whereType<Map>()
            .map((g) => _shortName(_str(g['name'])))
            .where((n) => n.isNotEmpty) ??
        const <String>[];

    String? duration;
    if (isTv) {
      final seasons = (j['number_of_seasons'] as num?)?.toInt() ?? 0;
      if (seasons > 0) duration = '$seasons Season${seasons == 1 ? '' : 's'}';
    } else {
      final minutes = (j['runtime'] as num?)?.toInt() ?? 0;
      if (minutes > 0) duration = '${minutes ~/ 60}h ${minutes % 60}m';
    }

    final castJson = (j['credits'] is Map ? (j['credits'] as Map)['cast'] : null);
    final cast = castJson is List
        ? castJson.whereType<Map>().take(12).map((c) {
            final character = _str(c['character']);
            return CastMember(
              name: _str(c['name']),
              character: character.isEmpty ? null : character,
              photoUrl: _image(c['profile_path'], 'w185'),
            );
          }).where((c) => c.name.isNotEmpty).toList()
        : <CastMember>[];

    final tagline = _str(j['tagline']);
    final movie = Movie(
      id: '${isTv ? 't' : 'm'}${rawId.toInt()}',
      title: title,
      year: date.length >= 4 ? date.substring(0, 4) : '',
      genre: _joinGenres(genreNames, isTv: isTv),
      posterAsset: _image(j['poster_path'], 'w500') ?? '',
      rating: _rating(j['vote_average'] as num?, votes),
      badge: _votesLabel(votes),
      duration: duration,
      description: _str(j['overview']),
      releaseDate: date.isEmpty ? null : DateTime.tryParse(date),
      isTvShow: isTv,
      backdropUrl: _image(j['backdrop_path'], 'w780'),
      tagline: tagline.isEmpty ? null : tagline,
      cast: cast,
    );
    return movie.copyWith(matchPercent: TasteUtils.matchPercent(movie));
  }
}
