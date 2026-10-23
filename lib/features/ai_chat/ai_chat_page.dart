

import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/data/movie_catalog.dart';
import 'models/ai_reply.dart';
import 'models/chat_message.dart';
import 'services/ai_chat_service.dart';
import 'widgets/ai_chat_header.dart';
import 'widgets/ai_reply_view.dart';
import 'widgets/chat_date_divider.dart';
import 'widgets/chat_error_bubble.dart';
import 'widgets/chat_input_bar.dart';
import 'widgets/typing_indicator.dart';
import 'widgets/user_message_bubble.dart';

/// شاشة محادثة MovieMind AI — متصلة بـ Gemini عن طريق Firebase AI Logic.
class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final _inputCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final _startedAt = DateTime.now();

  bool _loading = false;
  int _session = 0; // بيتغير عند الـ Reset عشان نتجاهل أي رد متأخر من محادثة قديمة
  late List<ChatMessage> _messages = [_welcome()];

  static ChatMessage _welcome() => ChatMessage.ai(const AiReply(
        text: "Hi! I'm MovieMind AI 🎬\n"
            "Tell me what you're in the mood for — a movie like one you loved, "
            "a genre, or a vibe — and I'll find your match.",
        suggestions: [
          'Something like Interstellar',
          'A feel-good comedy tonight',
          'Mind-bending thrillers',
        ],
      ));

  @override
  void dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _send(String raw, {bool addUserBubble = true}) async {
    final text = raw.trim();
    if (text.isEmpty || _loading) return;

    final session = _session;
    setState(() {
      if (addUserBubble) _messages = [..._messages, ChatMessage.user(text)];
      _loading = true;
    });
    _scrollToBottom();

    ChatMessage result;
    try {
      result = ChatMessage.ai(await AiChatService.instance.send(text));
    } on AiChatException catch (e) {
      result = ChatMessage.error(e.message, retryText: text);
    }

    if (!mounted || session != _session) return;
    setState(() {
      _messages = [..._messages, result];
      _loading = false;
    });
    _scrollToBottom();
  }

  void _retry(int index) {
    final text = _messages[index].retryText;
    if (text == null || _loading) return;
    setState(() => _messages = [..._messages]..removeAt(index));
    _send(text, addUserBubble: false);
  }

  void _reset() {
    AiChatService.instance.resetConversation();
    setState(() {
      _session++;
      _loading = false;
      _messages = [_welcome()];
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollCtrl.hasClients) return;
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  /// لو رسالة المستخدم فيها اسم فيلم من الكاتالوج، بنلوّنه (زي "Interstellar").
  String? _highlightFor(String text) {
    final lower = text.toLowerCase();
    for (final movie in MovieCatalog.all) {
      final i = lower.indexOf(movie.title.toLowerCase());
      if (i >= 0) return text.substring(i, i + movie.title.length);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final lastAiIndex = _messages.lastIndexWhere((m) => !m.fromUser && !m.isError);

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
                  ChatDateDivider(
                    label: 'Today • ${TimeOfDay.fromDateTime(_startedAt).format(context)}',
                  ),
                  for (var i = 0; i < _messages.length; i++)
                    _buildMessage(i, showSuggestions: i == lastAiIndex && !_loading),
                  if (_loading) const TypingIndicator(),
                ],
              ),
            ),
            ChatInputBar(controller: _inputCtrl, onSend: _send, enabled: !_loading),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(int index, {required bool showSuggestions}) {
    final message = _messages[index];
    if (message.fromUser) {
      return UserMessageBubble(
        text: message.text,
        highlight: _highlightFor(message.text),
      );
    }
    if (message.isError) {
      return ChatErrorBubble(
        message: message.text,
        onRetry: message.retryText == null ? null : () => _retry(index),
      );
    }
    return AiReplyView(
      reply: message.reply!,
      showSuggestions: showSuggestions,
      onSuggestion: _send,
    );
  }
}
