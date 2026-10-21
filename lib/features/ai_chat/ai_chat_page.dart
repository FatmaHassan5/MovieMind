// import 'package:flutter/material.dart';

// import '../../core/app_assets.dart';
// import '../../core/app_colors.dart';
// import '../../core/app_theme.dart';
// import '../../core/widgets/match_badge.dart';
// import 'models/chat_message.dart';
// import 'widgets/ai_chat_header.dart';
// import 'widgets/ai_recommendation_card.dart';
// import 'widgets/chat_date_divider.dart';
// import 'widgets/chat_input_bar.dart';
// import 'widgets/suggested_prompts_row.dart';
// import 'widgets/user_message_bubble.dart';

// /// شاشة محادثة MovieMind AI.
// class AiChatPage extends StatefulWidget {
//   const AiChatPage({super.key});

//   @override
//   State<AiChatPage> createState() => _AiChatPageState();
// }

// class _AiChatPageState extends State<AiChatPage> {
//   final _inputCtrl = TextEditingController();
//   final _scrollCtrl = ScrollController();

//   late List<ChatMessage> _messages = [
//     const ChatMessage(
//       fromUser: true,
//       text: 'Recommend something like Interstellar with mind-bending '
//           'concepts and emotional depth.',
//     ),
//   ];

//   static const _recommendations = [
//     AiRecommendation(
//       title: 'Arrival',
//       year: '2016',
//       genre: 'Sci-Fi • Drama • Mystery',
//       posterAsset: AppAssets.arrival,
//       rating: '8.0',
//       runtimeOrQuality: '4K UHD',
//       justification:
//           "Non-linear exploration of time, heptapod linguistics, and deep "
//           "parental grief mirroring Cooper and Murph's timeless bond.",
//     ),
//     AiRecommendation(
//       title: 'Contact',
//       year: '1997',
//       genre: 'Sci-Fi • Mystery • Thriller',
//       posterAsset: AppAssets.contact,
//       rating: '7.5',
//       runtimeOrQuality: '2h 30m',
//       justification:
//           "Carl Sagan's vision of humanity's first extraterrestrial "
//           "broadcast, grappling with faith, science, and a daughter "
//           "longing for her lost father.",
//     ),
//   ];

//   static const _prompts = ["Explain Arrival's ending", 'Give me something lighter'];

//   @override
//   void dispose() {
//     _inputCtrl.dispose();
//     _scrollCtrl.dispose();
//     super.dispose();
//   }

//   void _handleSend(String text) {
//     setState(() {
//       _messages = [
//         ..._messages,
//         ChatMessage(fromUser: true, text: text),
//         // TODO: استبدلي الرد الثابت ده بنداء API المساعد الحقيقي.
//         const ChatMessage(
//           fromUser: false,
//           text: "That's a great question — connect the real MovieMind AI "
//               "backend here to generate a tailored answer.",
//         ),
//       ];
//     });
//   }

//   void _reset() => setState(() => _messages = const [
//         ChatMessage(
//           fromUser: true,
//           text: 'Recommend something like Interstellar with mind-bending '
//               'concepts and emotional depth.',
//         ),
//       ]);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SafeArea(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.fromLTRB(18, 12, 18, 10),
//               child: AiChatHeader(onReset: _reset),
//             ),
//             Expanded(
//               child: ListView(
//                 controller: _scrollCtrl,
//                 padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
//                 children: [
//                   const ChatDateDivider(label: 'Today • 9:41 PM'),
//                   for (final m in _messages)
//                     m.fromUser
//                         ? UserMessageBubble(text: m.text, highlight: 'Interstellar')
//                         : _AiTextReply(text: m.text),
//                   const _AiIntro(),
//                   for (final r in _recommendations)
//                     AiRecommendationCard(
//                       recommendation: r,
//                       onViewDetails: () {},
//                       onWatchlist: () {},
//                     ),
//                   const SizedBox(height: 4),
//                   Row(
//                     children: [
//                       const Icon(Icons.lightbulb_outline,
//                           size: 14, color: AppColors.textDim),
//                       const SizedBox(width: 6),
//                       Text('Suggested deep-dives',
//                           style: AppText.body(11.5, color: AppColors.textDim)),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   SuggestedPromptsRow(prompts: _prompts, onTap: _handleSend),
//                 ],
//               ),
//             ),
//             ChatInputBar(controller: _inputCtrl, onSend: _handleSend),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _AiIntro extends StatelessWidget {
//   const _AiIntro();

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               const MatchBadge(percent: '98'),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Text('Cosmic & Emotional Echoes',
//                     style: AppText.body(11, color: AppColors.textMuted)),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Text.rich(
//             TextSpan(
//               style: AppText.body(13.5, height: 1.5),
//               children: const [
//                 TextSpan(text: "If you loved "),
//                 TextSpan(
//                     text: 'Interstellar',
//                     style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
//                 TextSpan(
//                     text: "'s grand existential scale and heart-wrenching human "
//                         "stakes, these cinematic journeys mirror that precise resonance:"),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12),
//         ],
//       ),
//     );
//   }
// }

// class _AiTextReply extends StatelessWidget {
//   const _AiTextReply({required this.text});

//   final String text;

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 14),
//         constraints: const BoxConstraints(maxWidth: 280),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
//         decoration: BoxDecoration(
//           color: AppColors.surface,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Text(text, style: AppText.body(13.5, color: AppColors.textMuted, height: 1.4)),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_theme.dart';
import '../../core/data/movie_catalog.dart';
import '../../core/widgets/match_badge.dart';
import 'models/chat_message.dart';
import 'widgets/ai_chat_header.dart';
import 'widgets/ai_recommendation_card.dart';
import 'widgets/chat_date_divider.dart';
import 'widgets/chat_input_bar.dart';
import 'widgets/suggested_prompts_row.dart';
import 'widgets/user_message_bubble.dart';

/// شاشة محادثة MovieMind AI.
class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final _inputCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  late List<ChatMessage> _messages = [
    const ChatMessage(
      fromUser: true,
      text: 'Recommend something like Interstellar with mind-bending '
          'concepts and emotional depth.',
    ),
  ];

  // التوصيات بتتسحب من الكاتالوج المركزي، مع سبب ترشيح خاص بالمحادثة دي.
  static const _recommendations = [
    (
      movie: arrival,
      justification:
          "Non-linear exploration of time, heptapod linguistics, and deep "
          "parental grief mirroring Cooper and Murph's timeless bond.",
    ),
    (
      movie: contact,
      justification:
          "Carl Sagan's vision of humanity's first extraterrestrial "
          "broadcast, grappling with faith, science, and a daughter "
          "longing for her lost father.",
    ),
  ];

  static const _prompts = ["Explain Arrival's ending", 'Give me something lighter'];

  @override
  void dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _handleSend(String text) {
    setState(() {
      _messages = [
        ..._messages,
        ChatMessage(fromUser: true, text: text),
        // TODO: استبدلي الرد الثابت ده بنداء API المساعد الحقيقي.
        const ChatMessage(
          fromUser: false,
          text: "That's a great question — connect the real MovieMind AI "
              "backend here to generate a tailored answer.",
        ),
      ];
    });
  }

  void _reset() => setState(() => _messages = const [
        ChatMessage(
          fromUser: true,
          text: 'Recommend something like Interstellar with mind-bending '
              'concepts and emotional depth.',
        ),
      ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 10),
              child: AiChatHeader(onReset: _reset),
            ),
            Expanded(
              child: ListView(
                controller: _scrollCtrl,
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
                children: [
                  const ChatDateDivider(label: 'Today • 9:41 PM'),
                  for (final m in _messages)
                    m.fromUser
                        ? UserMessageBubble(text: m.text, highlight: 'Interstellar')
                        : _AiTextReply(text: m.text),
                  const _AiIntro(),
                  for (final r in _recommendations)
                    AiRecommendationCard(
                      movie: r.movie,
                      justification: r.justification,
                    ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.lightbulb_outline,
                          size: 14, color: AppColors.textDim),
                      const SizedBox(width: 6),
                      Text('Suggested deep-dives',
                          style: AppText.body(11.5, color: AppColors.textDim)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SuggestedPromptsRow(prompts: _prompts, onTap: _handleSend),
                ],
              ),
            ),
            ChatInputBar(controller: _inputCtrl, onSend: _handleSend),
          ],
        ),
      ),
    );
  }
}

class _AiIntro extends StatelessWidget {
  const _AiIntro();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const MatchBadge(percent: '98'),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Cosmic & Emotional Echoes',
                    style: AppText.body(11, color: AppColors.textMuted)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              style: AppText.body(13.5, height: 1.5),
              children: const [
                TextSpan(text: "If you loved "),
                TextSpan(
                    text: 'Interstellar',
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                TextSpan(
                    text: "'s grand existential scale and heart-wrenching human "
                        "stakes, these cinematic journeys mirror that precise resonance:"),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _AiTextReply extends StatelessWidget {
  const _AiTextReply({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        constraints: const BoxConstraints(maxWidth: 280),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text, style: AppText.body(13.5, color: AppColors.textMuted, height: 1.4)),
      ),
    );
  }
}
