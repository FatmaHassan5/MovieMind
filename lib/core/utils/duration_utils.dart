

import '../models/movie.dart';

/// حساب تقريبي لإجمالي ساعات مشاهدة قائمة أفلام/مسلسلات، لعرضه في Watchlist.
abstract class DurationUtils {
  /// تقدير متوسط لساعات موسم مسلسل واحد لما تكون المدة "Season N" بدل "Xh Ym".
  static const _averageSeasonHours = 8.0;

  static const _unknownMovieHours = 2.0; // تقدير لما مدة الفيلم مش معروفة

  static double _hoursFor(Movie movie) {
    final duration = movie.duration;
    if (duration == null) return movie.isTvShow ? _averageSeasonHours : _unknownMovieHours;
    if (duration.toLowerCase().contains('season')) {
      final seasons = int.tryParse(RegExp(r'\d+').firstMatch(duration)?.group(0) ?? '') ?? 1;
      return seasons * _averageSeasonHours;
    }
    final hMatch = RegExp(r'(\d+)\s*h').firstMatch(duration);
    final mMatch = RegExp(r'(\d+)\s*m').firstMatch(duration);
    final hours = hMatch != null ? int.parse(hMatch.group(1)!) : 0;
    final minutes = mMatch != null ? int.parse(mMatch.group(1)!) : 0;
    return hours + minutes / 60;
  }

  /// إجمالي الساعات (رقم صحيح) لقائمة أفلام.
  static int totalHours(Iterable<Movie> movies) =>
      movies.fold<double>(0, (sum, m) => sum + _hoursFor(m)).round();

  static String totalHoursLabel(Iterable<Movie> movies) {
    final total = movies.fold<double>(0, (sum, m) => sum + _hoursFor(m));
    return '~${total.round()}h total';
  }
}
