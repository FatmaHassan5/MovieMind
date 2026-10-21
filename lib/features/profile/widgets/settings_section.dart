import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_theme.dart';
import '../../../core/state/user_controller.dart';

/// إعدادات التطبيق (مفاتيح تشغيل/إيقاف). كل مفتاح مربوط بـ UserController
/// و"Release reminders" بيتحكم فعليًا في زر Remind Me.
class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final user = UserController.instance;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _SettingRow(
            icon: Icons.notifications_none_rounded,
            title: 'Push notifications',
            subtitle: 'Alerts about new picks and updates',
            notifier: user.pushNotifications,
          ),
          const _RowDivider(),
          _SettingRow(
            icon: Icons.event_available_outlined,
            title: 'Release reminders',
            subtitle: 'Allow "Remind Me" on upcoming movies',
            notifier: user.releaseReminders,
          ),
          const _RowDivider(),
          _SettingRow(
            icon: Icons.auto_awesome_outlined,
            title: 'AI personalization',
            subtitle: 'Use your taste to tailor recommendations',
            notifier: user.aiPersonalization,
          ),
        ],
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, indent: 14, endIndent: 14, color: Colors.white10);
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.notifier,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final ValueNotifier<bool> notifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: notifier,
      builder: (_, value, __) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                  color: AppColors.surfaceHigh, shape: BoxShape.circle),
              child: Icon(icon, size: 17, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppText.body(13.5, weight: FontWeight.w600)),
                  Text(subtitle,
                      style: AppText.body(11, color: AppColors.textMuted)),
                ],
              ),
            ),
            Transform.scale(
              scale: 0.8,
              child: Switch(
                value: value,
                onChanged: (v) => notifier.value = v,
                activeColor: AppColors.onPrimary,
                activeTrackColor: AppColors.primary,
                inactiveThumbColor: AppColors.text,
                inactiveTrackColor: AppColors.surfaceHigh,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
