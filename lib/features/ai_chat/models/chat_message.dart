// /// رسالة نصية بسيطة في محادثة الـ AI (من المستخدم أو رد نصي بسيط من الـ AI).
// class ChatMessage {
//   const ChatMessage({required this.fromUser, required this.text});

//   final bool fromUser;
//   final String text;
// }

// /// توصية فيلم تظهر كـ كارت داخل رد الـ AI.
// class AiRecommendation {
//   const AiRecommendation({
//     required this.title,
//     required this.year,
//     required this.genre,
//     required this.posterAsset,
//     required this.rating,
//     required this.runtimeOrQuality,
//     required this.justification,
//   });

//   final String title;
//   final String year;
//   final String genre;
//   final String posterAsset;
//   final String rating;
//   final String runtimeOrQuality;
//   final String justification;
// }


/// رسالة نصية بسيطة في محادثة الـ AI (من المستخدم أو رد نصي بسيط من الـ AI).
class ChatMessage {
  const ChatMessage({required this.fromUser, required this.text});

  final bool fromUser;
  final String text;
}

