// import '../models/movie.dart';

// /// حساب تقريبي لإجمالي ساعات مشاهدة قائمة أفلام/مسلسلات، لعرضه في Watchlist.
// abstract class DurationUtils {
//   /// تقدير متوسط لساعات موسم مسلسل واحد لما تكون المدة "Season N" بدل "Xh Ym".
//   static const _averageSeasonHours = 8.0;

//   static double _toHours(String? duration) {
//     if (duration == null) return 0;
//     if (duration.toLowerCase().contains('season')) return _averageSeasonHours;

//     final hMatch = RegExp(r'(\d+)\s*h').firstMatch(duration);
//     final mMatch = RegExp(r'(\d+)\s*m').firstMatch(duration);
//     final hours = hMatch != null ? int.parse(hMatch.group(1)!) : 0;
//     final minutes = mMatch != null ? int.parse(mMatch.group(1)!) : 0;
//     return hours + minutes / 60;
//   }

//   static String totalHoursLabel(Iterable<Movie> movies) {
//     final total = movies.fold<double>(0, (sum, m) => sum + _toHours(m.duration));
//     return '~${total.round()}h total';
//   }
// }

import '../models/movie.dart';

/// حساب تقريبي لإجمالي ساعات مشاهدة قائمة أفلام/مسلسلات، لعرضه في Watchlist.
abstract class DurationUtils {
  /// تقدير متوسط لساعات موسم مسلسل واحد لما تكون المدة "Season N" بدل "Xh Ym".
  static const _averageSeasonHours = 8.0;

  static double _toHours(String? duration) {
    if (duration == null) return 0;
    if (duration.toLowerCase().contains('season')) return _averageSeasonHours;

    final hMatch = RegExp(r'(\d+)\s*h').firstMatch(duration);
    final mMatch = RegExp(r'(\d+)\s*m').firstMatch(duration);
    final hours = hMatch != null ? int.parse(hMatch.group(1)!) : 0;
    final minutes = mMatch != null ? int.parse(mMatch.group(1)!) : 0;
    return hours + minutes / 60;
  }

  /// إجمالي الساعات (رقم صحيح) لقائمة أفلام.
  static int totalHours(Iterable<Movie> movies) =>
      movies.fold<double>(0, (sum, m) => sum + _toHours(m.duration)).round();

  static String totalHoursLabel(Iterable<Movie> movies) {
    final total = movies.fold<double>(0, (sum, m) => sum + _toHours(m.duration));
    return '~${total.round()}h total';
  }
}
