import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';

/// شريط إدخال الرسائل السفلي الثابت في شاشة المحادثة.
class ChatInputBar extends StatelessWidget {
  const ChatInputBar({super.key, required this.controller, required this.onSend});

  final TextEditingController controller;
  final ValueChanged<String> onSend;

  void _submit() {
    final text = controller.text.trim();
    if (text.isEmpty) return;
    onSend(text);
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Row(
            children: [
              const Icon(Icons.attach_file, size: 20, color: AppColors.textDim),
              const SizedBox(width: 10),
              const Icon(Icons.mic_none_rounded, size: 20, color: AppColors.textDim),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  onSubmitted: (_) => _submit(),
                  style: AppText.body(13.5, color: AppColors.text),
                  cursorColor: AppColors.primary,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: AppColors.surfaceHigh,
                    hintText: 'Ask MovieMind anything about movies...',
                    hintStyle: AppText.body(12.5, color: AppColors.textDim),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _submit,
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                      color: AppColors.primary, shape: BoxShape.circle),
                  child: const Icon(Icons.arrow_upward_rounded,
                      size: 18, color: AppColors.onPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
