

import 'dart:math' as math;

import '../models/movie.dart';
import '../state/user_controller.dart';

/// تحليل بسيط لذوق المستخدم من الأفلام المحفوظة.
abstract class TasteUtils {
  static const genres = [
    'Sci-Fi', 'Drama', 'Action', 'Thriller', 'Comedy', 'Romance', 'Crime', 'Mystery',
    'Adventure', 'Animation', 'Fantasy', 'Horror',
  ];

  /// نسبة تطابق الفيلم مع ذوقك (تقدير): التقييم + عدد التصنيفات المفضلة اللي بيشاركها.
  /// بترجع null لو الفيلم من غير تقييم (لسه ما طلعش).
  static String? matchPercent(Movie movie) {
    final rating = double.tryParse(movie.rating ?? '');
    if (rating == null) return null;
    final text = movie.genre.toLowerCase();
    final overlap = UserController.instance.favoriteGenres.value
        .where((g) => text.contains(g.toLowerCase()))
        .length;
    final score = 55 + rating * 3 + math.min(overlap, 3) * 5;
    return score.round().clamp(50, 99).toString();
  }

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
