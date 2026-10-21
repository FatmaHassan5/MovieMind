import 'package:flutter/material.dart';

import '../../../core/app_assets.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/motion.dart';
import '../../../core/widgets/pill_chip.dart';
import '../widgets/onboarding_text.dart';

/// الصفحة 3: محادثة الـ AI.
class AskAiPage extends StatelessWidget {
  const AskAiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        children: [
          const Expanded(
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: _ChatCard(),
            ),
          ),
          const SizedBox(height: 14),
          const FadeSlideIn(
            child: PillChip(
              label: 'Next-Gen Discovery',
              icon: Icons.auto_awesome,
              fontSize: 12,
              padding: EdgeInsets.symmetric(horizontal: 13, vertical: 8),
            ),
          ),
          const SizedBox(height: 10),
          const OnboardingText(
            title: 'Ask MovieMind AI',
            description:
                'Tell us what you\'re in the mood for and let AI help you find the perfect movie, explain twists, and curate deep-dives.',
            centered: true,
          ),
        ],
      ),
    );
  }
}

class _ChatCard extends StatelessWidget {
  const _ChatCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF26262E), Color(0xFF1B1B21)],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                      color: AppColors.green, shape: BoxShape.circle),
                ),
                const SizedBox(width: 7),
                Text('CINEPULSE AI ACTIVE',
                    style: AppText.body(10,
                        color: AppColors.textMuted, letterSpacing: 0.8)),
              ]),
              const PillChip(
                label: 'Deep Match',
                icon: Icons.psychology_outlined,
                background: Color(0xFF2E2E36),
                fontSize: 10,
              ),
            ],
          ),
          const SizedBox(height: 13),
          const FadeSlideIn(
            delay: Duration(milliseconds: 200),
            offset: Offset(0.1, 0),
            child: _UserBubble(),
          ),
          const SizedBox(height: 12),
          const FadeSlideIn(
            delay: Duration(milliseconds: 600),
            offset: Offset(-0.1, 0),
            child: _AiReply(),
          ),
        ],
      ),
    );
  }
}

class _UserBubble extends StatelessWidget {
  const _UserBubble();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
            decoration: BoxDecoration(
              color: const Color(0xFF34343C),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text.rich(
              TextSpan(
                style: AppText.body(13, weight: FontWeight.w400),
                children: const [
                  TextSpan(text: 'I want a movie like '),
                  TextSpan(
                    text: 'Interstellar',
                    style: TextStyle(
                        color: AppColors.primary, fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: '.'),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
              color: Color(0xFF34343C), shape: BoxShape.circle),
          child: const Icon(Icons.person_outline,
              color: AppColors.textMuted, size: 16),
        ),
      ],
    );
  }
}

class _AiReply extends StatelessWidget {
  const _AiReply();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: const BoxDecoration(
              color: Color(0xFF34343C), shape: BoxShape.circle),
          child: const Icon(Icons.auto_awesome,
              color: AppColors.primary, size: 16),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text('MovieMind',
                    style: AppText.body(13,
                        color: AppColors.primary, weight: FontWeight.w600)),
                const SizedBox(width: 6),
                Text('just now',
                    style: AppText.body(10, color: AppColors.textMuted)),
              ]),
              const SizedBox(height: 4),
              Text(
                'Here are cinematic journeys matching that existential scale, profound emotional gravity, and scientific awe:',
                style: AppText.body(12.5,
                    color: AppColors.textMuted,
                    weight: FontWeight.w400,
                    height: 1.45),
              ),
              const SizedBox(height: 9),
              const _MovieTile(
                path: AppAssets.arrival,
                title: 'Arrival',
                match: '98% Match',
                highlightMatch: true,
                desc: 'Linguistic puzzle transcending...',
                rating: '8.0',
                tags: ['Sci-Fi', 'Mind-Bending'],
                liked: true,
              ),
              const SizedBox(height: 8),
              const _MovieTile(
                path: AppAssets.contact,
                title: 'Contact',
                match: '94% Match',
                desc: 'First extraterrestrial contact meet...',
                rating: '7.5',
                tags: ['Cosmic', 'Drama'],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MovieTile extends StatelessWidget {
  const _MovieTile({
    required this.path,
    required this.title,
    required this.match,
    required this.desc,
    required this.rating,
    required this.tags,
    this.highlightMatch = false,
    this.liked = false,
  });

  final String path;
  final String title;
  final String match;
  final String desc;
  final String rating;
  final List<String> tags;
  final bool highlightMatch;
  final bool liked;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF26262C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 42,
            height: 52,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: AppImage(path),
                ),
                if (liked)
                  const Positioned(
                    left: 4,
                    bottom: 4,
                    child: Icon(Icons.thumb_up_outlined,
                        size: 10, color: AppColors.green),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: AppText.body(14, weight: FontWeight.w600)),
                    PillChip(
                      label: match,
                      background: highlightMatch
                          ? const Color(0xFF1B3A34)
                          : const Color(0xFF34343C),
                      foreground:
                          highlightMatch ? AppColors.green : AppColors.textMuted,
                      fontSize: 9,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                    ),
                  ],
                ),
                const SizedBox(height: 1),
                Text(desc,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.body(9.5,
                        color: AppColors.textMuted, weight: FontWeight.w400)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: [
                    PillChip(
                      label: rating,
                      icon: Icons.star_border,
                      background: const Color(0xFF34343C),
                      foreground: AppColors.text,
                      fontSize: 9.5,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 4),
                    ),
                    for (final t in tags)
                      PillChip(
                        label: t,
                        background: const Color(0xFF34343C),
                        foreground: AppColors.textMuted,
                        fontSize: 9,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 4),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
