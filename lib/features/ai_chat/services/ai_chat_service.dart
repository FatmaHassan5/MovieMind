

import 'dart:async';
import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart';

import '../../../core/data/movie_catalog.dart';
import '../../../core/data/movie_repository.dart';
import '../../../core/models/movie.dart';
import '../../../core/services/app_firebase.dart';
import '../../../core/state/user_controller.dart';
import '../../../core/state/watchlist_controller.dart';
import '../models/ai_reply.dart';

/// خطأ بيحمل رسالة جاهزة للعرض للمستخدم.
class AiChatException implements Exception {
  const AiChatException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// الاتصال بـ Gemini عن طريق Firebase AI Logic.
class AiChatService {
  AiChatService._();

  static final AiChatService instance = AiChatService._();

  static const _modelName = 'gemini-3.8-flash';
  static const _timeout = Duration(seconds: 45);

  /// عدد المحاولات الإضافية عند أخطاء السيرفر المؤقتة.
  static const _maxRetries = 2;

  final _repo = MovieRepository.instance;
  ChatSession? _chat;

  /// بداية محادثة جديدة.
  void resetConversation() => _chat = null;

  Future<AiReply> send(String userText) async {
    if (!AppFirebase.ready) {
      throw const AiChatException(
        "Firebase isn't set up yet. Run `flutterfire configure` and restart the app.",
      );
    }

    try {
      _chat ??= _createChat();

      final response = await _sendWithRetry(userText);
      final raw = response.text;

      if (raw == null || raw.trim().isEmpty) {
        throw const AiChatException(
          'The AI returned an empty answer. Try rephrasing.',
        );
      }

      return await _parse(raw);
    } on AiChatException {
      rethrow;
    } on TimeoutException {
      throw const AiChatException(
        'The AI took too long to answer. Please try again.',
      );
    } catch (e, stackTrace) {
      _logError(e, stackTrace);
      throw AiChatException(_friendly(e));
    }
  }

  /// يعيد المحاولة عند أخطاء السيرفر المؤقتة فقط.
  ///
  /// لا يعيد إرسال الطلب عند أخطاء الصلاحيات أو الطلبات غير الصحيحة.
  Future<GenerateContentResponse> _sendWithRetry(
    String userText,
  ) async {
    for (var attempt = 0; ; attempt++) {
      try {
        return await _chat!
            .sendMessage(Content.text(userText))
            .timeout(_timeout);
      } on TimeoutException {
        rethrow;
      } catch (e, stackTrace) {
        _logError(e, stackTrace);

        if (attempt >= _maxRetries || !_isTemporaryServerError(e)) {
          throw AiChatException(_friendly(e));
        }

        // 2 ثانية، ثم 4 ثوانٍ قبل المحاولة الأخيرة.
        final waitSeconds = 2 * (attempt + 1);

        debugPrint(
          'Gemini temporary server error. '
          'Retry ${attempt + 1}/$_maxRetries in $waitSeconds seconds.',
        );

        await Future<void>.delayed(Duration(seconds: waitSeconds));
      }
    }
  }

  bool _isTemporaryServerError(Object error) {
    final t = error.toString().toLowerCase();

    return t.contains('high demand') ||
        t.contains('internal') ||
        t.contains('500') ||
        t.contains('502') ||
        t.contains('503') ||
        t.contains('504') ||
        t.contains('deadline_exceeded') ||
        t.contains('temporarily unavailable');
  }

  void _logError(Object error, StackTrace stackTrace) {
    debugPrint('========== AI CHAT ERROR ==========');
    debugPrint('Error type: ${error.runtimeType}');
    debugPrint('Error details: $error');
    debugPrintStack(stackTrace: stackTrace);
    debugPrint('===================================');
  }

  // ------------------------------------------------------------------
  // Setup
  // ------------------------------------------------------------------

  ChatSession _createChat() {
    final model = FirebaseAI.googleAI().generativeModel(
      model: _modelName,
      systemInstruction: Content.system(_systemPrompt()),
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        temperature: 0.8,
      ),
    );

    return model.startChat();
  }

  String _systemPrompt() {
    return '''
You are MovieMind AI, a friendly and knowledgeable film and TV expert inside a movie discovery app.
You can answer ANY question about movies, TV series, actors, directors, plots, endings, themes, trivia,
awards, franchises, watch order, comparisons and recommendations.

Reply with ONLY a JSON object (no markdown, no extra text) in exactly this shape:
{
  "reply": "your answer, conversational, as long as the question needs (short for simple questions)",
  "theme": "short label of the shared vibe when you recommend titles, e.g. Cosmic & Emotional Echoes, otherwise null",
  "matchPercent": 60-99 as an integer when you recommend titles, otherwise null,
  "recommendations": [
    {
      "title": "exact title",
      "year": "YYYY",
      "type": "movie" or "tv",
      "justification": "1-2 sentences on why it fits"
    }
  ],
  "mentions": [
    {
      "title": "exact title",
      "year": "YYYY",
      "type": "movie" or "tv"
    }
  ],
  "suggestions": [
    "2-3 short follow-up questions the user could tap"
  ]
}

Rules:
- Only mention real titles that actually exist. Use the exact original English title and the correct release year.
  If you are not sure a title or its year is right, leave it out instead of guessing.
- "recommendations": 0-3 titles, ONLY when the user wants suggestions. Never recommend something the user already watched.
- "mentions": 0-3 titles that are central to a factual answer, so the app can show them as cards.
- Avoid spoilers unless the user asks for them.
- For things after your knowledge cutoff, say you may not have the latest information. Use the "Right now" lists below when relevant.
- If the question is unrelated to movies or TV, politely steer back to cinema.
- Always answer in the same language the user writes in, including the suggestions.

${_liveContext()}
${_userContext()}
''';
  }

  /// أفلام رائجة وقادمة من بيانات TMDB الموجودة في الكاش.
  String _liveContext() {
    String line(Movie m) =>
        m.year.isEmpty ? m.title : '${m.title} (${m.year})';

    final trending = _repo
        .peekTrending()
        .take(10)
        .map(line)
        .join(', ');

    final upcoming = _repo.peekUpcoming().take(10).map((m) {
      final d = m.releaseDate;

      return d == null
          ? line(m)
          : '${m.title} (${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')})';
    }).join(', ');

    if (trending.isEmpty && upcoming.isEmpty) {
      return '';
    }

    return '''
Right now (live data from TMDB, today is ${DateTime.now().toIso8601String().substring(0, 10)}):
- Trending movies this week: ${trending.isEmpty ? 'n/a' : trending}
- Upcoming releases: ${upcoming.isEmpty ? 'n/a' : upcoming}
''';
  }

  String _userContext() {
    final user = UserController.instance;

    if (!user.aiPersonalization.value) {
      return 'Personalization is OFF: do not assume anything about this user\'s taste.';
    }

    String titles(Iterable<String> ids) {
      final names = ids
          .map(MovieCatalog.byId)
          .whereType<Movie>()
          .map((m) => m.title);

      return names.isEmpty ? 'none' : names.join(', ');
    }

    final watchlist = WatchlistController.instance;
    final genres = user.favoriteGenres.value;

    return '''
About the user (use it to personalize, never repeat it back verbatim):
- Name: ${user.name.value}
- Favorite genres: ${genres.isEmpty ? 'none' : genres.join(', ')}
- Saved in watchlist: ${titles(watchlist.ids.value)}
- Already watched: ${titles(watchlist.watchedIds.value)}''';
  }

  // ------------------------------------------------------------------
  // Parsing
  // ------------------------------------------------------------------

  Future<AiReply> _parse(String raw) async {
    final cleaned = raw
        .trim()
        .replaceAll(RegExp(r'^```(?:json)?\s*|\s*```$'), '')
        .trim();

    Object? decoded;

    try {
      decoded = jsonDecode(cleaned);
    } catch (_) {
      return AiReply(text: raw.trim());
    }

    if (decoded is! Map) {
      return AiReply(text: raw.trim());
    }

    final recRefs = _refs(decoded['recommendations']);
    final mentionRefs = _refs(decoded['mentions']);

    final resolved = await Future.wait([
      for (final r in [...recRefs, ...mentionRefs]) _resolve(r),
    ]);

    final picks = <AiPick>[];
    final seen = <String>{};

    for (var i = 0; i < recRefs.length; i++) {
      final movie = resolved[i];

      if (movie == null || !seen.add(movie.id)) {
        continue;
      }

      picks.add(
        AiPick(
          movieId: movie.id,
          justification: recRefs[i].note,
        ),
      );
    }

    final mentionIds = <String>[];

    for (var i = 0; i < mentionRefs.length; i++) {
      final movie = resolved[recRefs.length + i];

      if (movie == null || !seen.add(movie.id)) {
        continue;
      }

      mentionIds.add(movie.id);
    }

    final match = decoded['matchPercent'];

    final matchPercent = (picks.isNotEmpty && match is num)
        ? match.round().clamp(1, 100).toInt()
        : null;

    final themeRaw = decoded['theme'];

    final theme = (themeRaw is String && themeRaw.trim().isNotEmpty)
        ? themeRaw.trim()
        : null;

    final suggestionsRaw = decoded['suggestions'];

    final suggestions = suggestionsRaw is List
        ? suggestionsRaw
            .whereType<String>()
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .take(3)
            .toList()
        : <String>[];

    final replyRaw = decoded['reply'];

    var text = replyRaw is String ? replyRaw.trim() : '';

    if (text.isEmpty) {
      text = picks.isNotEmpty
          ? 'Here are my picks for you:'
          : raw.trim();
    }

    return AiReply(
      text: text,
      theme: theme,
      matchPercent: matchPercent,
      picks: picks,
      mentionIds: mentionIds,
      suggestions: suggestions,
    );
  }

  List<_TitleRef> _refs(Object? value) {
    if (value is! List) {
      return const [];
    }

    final refs = <_TitleRef>[];

    for (final item in value) {
      if (item is! Map) {
        continue;
      }

      final title = item['title'];

      if (title is! String || title.trim().isEmpty) {
        continue;
      }

      final year = item['year'];
      final type = item['type'];
      final note = item['justification'];

      refs.add(
        _TitleRef(
          title: title.trim(),
          year: year is String
              ? year
              : (year is num ? '${year.toInt()}' : null),
          tv: type == 'tv',
          note: note is String ? note.trim() : '',
        ),
      );
    }

    return refs.take(3).toList();
  }

  /// فشل البحث في TMDB لا يوقف الرد.
  Future<Movie?> _resolve(_TitleRef ref) async {
    try {
      return await _repo.resolveTitle(
        ref.title,
        year: ref.year,
        tv: ref.tv,
      );
    } catch (e) {
      debugPrint('resolveTitle failed for ${ref.title}: $e');
      return null;
    }
  }

  // ------------------------------------------------------------------
  // Errors
  // ------------------------------------------------------------------

  String _friendly(Object e) {
    final t = e.toString().toLowerCase();

    if (t.contains('quota') ||
        t.contains('429') ||
        t.contains('resource_exhausted')) {
      return 'Too many requests right now. Please wait a moment and try again.';
    }

    if (t.contains('high demand') ||
        t.contains('500') ||
        t.contains('502') ||
        t.contains('503') ||
        t.contains('504') ||
        t.contains('internal') ||
        t.contains('temporarily unavailable')) {
      return 'The AI service is temporarily busy. Please try again in a moment.';
    }

    if (t.contains('socketexception') ||
        t.contains('failed host lookup') ||
        t.contains('network')) {
      return 'No internet connection. Check your network and try again.';
    }

    if (t.contains('permission') ||
        t.contains('403') ||
        t.contains('api key') ||
        t.contains('not enabled') ||
        t.contains('has not been used')) {
      return "AI isn't enabled for this Firebase project yet. Turn on Firebase AI Logic in the console.";
    }

    if (t.contains('safety') || t.contains('blocked')) {
      return 'That request was blocked by the safety filters. Try rephrasing.';
    }

    if (t.contains('not found') || t.contains('404')) {
      return 'The AI model or requested resource was not found. Check the model configuration.';
    }

    if (t.contains('model')) {
      return 'There is a problem with the AI model configuration. Please check the model name.';
    }

    return 'Something went wrong while contacting the AI. Please try again.';
  }
}

class _TitleRef {
  const _TitleRef({
    required this.title,
    this.year,
    this.tv = false,
    this.note = '',
  });

  final String title;
  final String? year;
  final bool tv;
  final String note;
}
