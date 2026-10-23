

import '../models/movie.dart';

/// سجل في الذاكرة لكل الأفلام اللي ظهرت في التطبيق (من TMDB أو من حفظ المستخدم).
/// أي شاشة تقدر تجيب فيلم بالـ id بتاعه، وده اللي بيخلي الـ Watchlist
/// والتذكيرات والشات يشتغلوا على نفس البيانات.
abstract class MovieCatalog {
  static final Map<String, Movie> _byId = {};

  static Movie? byId(String id) => _byId[id];

  static List<Movie> get all => _byId.values.toList();

  /// بيسجّل الأفلام ويدمجها مع اللي موجود (البيانات الأغنى بتفضل).
  static void register(Iterable<Movie> movies) {
    for (final movie in movies) {
      final existing = _byId[movie.id];
      _byId[movie.id] = existing == null ? movie : movie.mergedWith(existing);
    }
  }
}
