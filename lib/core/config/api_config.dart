/// إعدادات الـ APIs. التوكن بيتمرر وقت التشغيل ومش بيتكتب في الكود:
///   flutter run --dart-define=TMDB_TOKEN=xxxxx
/// أو من ملف:  flutter run --dart-define-from-file=env.json
abstract class ApiConfig {
  /// "API Read Access Token" من حسابك في themoviedb.org.
  static const tmdbToken = String.fromEnvironment('TMDB_TOKEN');

  static bool get hasTmdbToken => tmdbToken.isNotEmpty;

  static const missingTokenMessage =
      'Movie data is not configured. Run the app with --dart-define=TMDB_TOKEN=your_token.';
}
