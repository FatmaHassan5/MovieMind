

/// فيلم رشّحه الـ AI (بعد ما اتحوّل لفيلم حقيقي من TMDB) مع سبب الترشيح.
class AiPick {
  const AiPick({required this.movieId, required this.justification});

  final String movieId;
  final String justification;
}

/// رد الـ AI بعد تحليله: نص + (اختياري) تصنيف الذوق ونسبة التطابق + ترشيحات + أسئلة مقترحة.
class AiReply {
  const AiReply({
    required this.text,
    this.theme,
    this.matchPercent,
    this.picks = const [],
    this.mentionIds = const [],
    this.suggestions = const [],
  });

  final String text;
  final String? theme;
  final int? matchPercent;
  final List<AiPick> picks;

  /// أفلام اتذكرت في الإجابة (مش ترشيحات) — بتظهر كبطاقات صغيرة تفتح التفاصيل.
  final List<String> mentionIds;
  final List<String> suggestions;
}
