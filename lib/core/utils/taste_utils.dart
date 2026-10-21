import '../models/movie.dart';

/// تحليل بسيط لذوق المستخدم من الأفلام المحفوظة.
abstract class TasteUtils {
  static const genres = [
    'Sci-Fi', 'Drama', 'Action', 'Thriller', 'Comedy', 'Romance', 'Crime', 'Mystery',
  ];

  /// أكتر التصنيفات تكرارًا في قائمة الأفلام (مرتبة من الأكتر للأقل).
  static List<String> topGenres(Iterable<Movie> movies, {int take = 3}) {
    final counts = <String, int>{};
    for (final movie in movies) {
      final text = movie.genre.toLowerCase();
      for (final genre in genres) {
        if (text.contains(genre.toLowerCase())) {
          counts[genre] = (counts[genre] ?? 0) + 1;
        }
      }
    }
    final sorted = counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(take).map((e) => e.key).toList();
  }
}
