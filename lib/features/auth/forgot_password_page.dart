

import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_theme.dart';
import '../../core/services/auth_service.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/bottom_link.dart';
import '../../core/widgets/motion.dart';
import '../onboarding/widgets/onboarding_buttons.dart';
import 'widgets/auth_top_bar.dart';
import 'widgets/security_tip_card.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  bool _submitting = false;
  bool _sent = false;
  String? _emailError; // خطأ جاي من Firebase بيظهر تحت الحقل
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _autovalidate = AutovalidateMode.onUserInteraction);
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() {
      _submitting = true;
      _emailError = null;
    });
    final result = await AuthService.instance.sendPasswordReset(_emailCtrl.text);
    if (!mounted) return;
    setState(() {
      _submitting = false;
      _sent = result.ok;
      if (!result.ok && !result.cancelled) _emailError = result.message;
    });
    if (_emailError != null) _formKey.currentState?.validate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AuthTopBar(
              pageTitle: 'Reset Password',
              onBack: () => Navigator.of(context).maybePop(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 26),
                child: Column(
                  children: [
                    FadeSlideIn(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: Form(
                          key: _formKey,
                          autovalidateMode: _autovalidate,
                          child: Column(
                            children: [
                              const _IconBadge(),
                              const SizedBox(height: 14),
                              Text('Forgot Password?',
                                  textAlign: TextAlign.center,
                                  style: AppText.heading(21,
                                      weight: FontWeight.w700)),
                              const SizedBox(height: 6),
                              Text(
                                'Enter your email address and we\'ll send '
                                'you a secure link to reset your password.',
                                textAlign: TextAlign.center,
                                style: AppText.body(13,
                                    color: AppColors.textMuted, height: 1.5),
                              ),
                              const SizedBox(height: 18),
                              AppTextField(
                                label: 'Email address',
                                controller: _emailCtrl,
                                hint: 'you@example.com',
                                prefixIcon: Icons.mail_outline,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.done,
                                validator: (v) => _emailError ?? Validators.email(v),
                                onChanged: (_) {
                                  if (_sent || _emailError != null) {
                                    setState(() {
                                      _sent = false;
                                      _emailError = null;
                                    });
                                  }
                                },
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(Icons.lock_outline,
                                      size: 12, color: AppColors.green),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'End-to-end encrypted single-use link',
                                      style: AppText.body(11,
                                          color: AppColors.textMuted),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              if (!_sent)
                                PrimaryButton(
                                  label: _submitting
                                      ? 'Sending…'
                                      : 'Send Reset Link',
                                  onPressed: _submitting ? () {} : _submit,
                                  height: 52,
                                )
                              else
                                const _SentBanner(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const FadeSlideIn(
                        delay: Duration(milliseconds: 150),
                        child: SecurityTipCard()),
                    const SizedBox(height: 22),
                    Center(
                      child: BottomLink(
                        text: 'Remember your password?  ',
                        action: 'Back to Login',
                        trailingIcon: true,
                        onTap: () => Navigator.of(context).maybePop(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 62,
      height: 62,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: const BoxDecoration(
                color: AppColors.surfaceHigh, shape: BoxShape.circle),
            child: const Icon(Icons.lock_reset,
                color: AppColors.primary, size: 28),
          ),
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                  color: AppColors.background, shape: BoxShape.circle),
              padding: const EdgeInsets.all(3),
              child: const Icon(Icons.verified_user,
                  color: AppColors.green, size: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _SentBanner extends StatelessWidget {
  const _SentBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF17342C),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.green.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: AppColors.green, size: 18),
          const SizedBox(width: 8),
          Flexible(
            child: Text('Reset link sent! Check your inbox.',
                textAlign: TextAlign.center,
                style: AppText.body(13,
                    color: AppColors.green, weight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
