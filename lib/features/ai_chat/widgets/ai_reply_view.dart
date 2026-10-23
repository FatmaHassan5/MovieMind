

import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../../core/data/movie_catalog.dart';
import '../../../core/widgets/match_badge.dart';
import '../models/ai_reply.dart';
import 'ai_recommendation_card.dart';
import 'mentioned_movies_row.dart';
import 'suggested_prompts_row.dart';

/// عرض رد الـ AI: (نسبة التطابق + الثيم) ← النص ← كروت الترشيحات ← الأسئلة المقترحة.
/// لو الرد نص بس (من غير ترشيحات) بيظهر في فقاعة عادية.
class AiReplyView extends StatelessWidget {
  const AiReplyView({
    super.key,
    required this.reply,
    required this.showSuggestions,
    required this.onSuggestion,
  });

  final AiReply reply;
  final bool showSuggestions;
  final ValueChanged<String> onSuggestion;

  @override
  Widget build(BuildContext context) {
    final hasPicks = reply.picks.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (reply.matchPercent != null) ...[
            Row(
              children: [
                MatchBadge(percent: '${reply.matchPercent}'),
                if (reply.theme != null) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(reply.theme!,
                        style: AppText.body(11, color: AppColors.textMuted)),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
          ],
          _text(hasPicks),
          if (reply.mentionIds.isNotEmpty) ...[
            const SizedBox(height: 10),
            MentionedMoviesRow(ids: reply.mentionIds),
          ],
          if (hasPicks) ...[
            const SizedBox(height: 12),
            for (final pick in reply.picks)
              AiRecommendationCard(
                movie: MovieCatalog.byId(pick.movieId)!,
                justification: pick.justification.isEmpty
                    ? 'A strong match for what you asked.'
                    : pick.justification,
              ),
          ],
          if (showSuggestions && reply.suggestions.isNotEmpty) ...[
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.lightbulb_outline, size: 14, color: AppColors.textDim),
                const SizedBox(width: 6),
                Text('Suggested deep-dives',
                    style: AppText.body(11.5, color: AppColors.textDim)),
              ],
            ),
            const SizedBox(height: 8),
            SuggestedPromptsRow(prompts: reply.suggestions, onTap: onSuggestion),
          ],
        ],
      ),
    );
  }

  Widget _text(bool hasPicks) {
    final text = Text(reply.text, style: AppText.body(13.5, height: 1.5));
    if (hasPicks || reply.matchPercent != null) return text;

    // رد نصي بسيط → فقاعة
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(reply.text,
          style: AppText.body(13.5, color: AppColors.textMuted, height: 1.45)),
    );
  }
}
