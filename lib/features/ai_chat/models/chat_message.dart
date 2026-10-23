



import 'ai_reply.dart';

/// رسالة في المحادثة: من المستخدم، أو رد من الـ AI، أو رسالة خطأ (مع إمكانية إعادة المحاولة).
class ChatMessage {
  ChatMessage.user(this.text)
      : fromUser = true,
        reply = null,
        isError = false,
        retryText = null;

  ChatMessage.ai(AiReply this.reply)
      : fromUser = false,
        text = reply.text,
        isError = false,
        retryText = null;

  ChatMessage.error(this.text, {this.retryText})
      : fromUser = false,
        reply = null,
        isError = true;

  final bool fromUser;
  final String text;
  final AiReply? reply;
  final bool isError;

  /// نص الرسالة اللي فشلت (بيتبعت تاني لما المستخدم يدوس Retry).
  final String? retryText;
}
