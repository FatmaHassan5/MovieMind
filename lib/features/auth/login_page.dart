

import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_theme.dart';
import '../../core/services/auth_service.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/bottom_link.dart';
import '../../core/widgets/choice_shapes.dart';
import '../../core/widgets/motion.dart';
import '../../core/widgets/section_divider.dart';
import '../../core/widgets/social_button.dart';
import '../main/main_shell.dart';
import '../onboarding/widgets/onboarding_buttons.dart';
import 'forgot_password_page.dart';
import 'signup_page.dart';
import 'widgets/auth_header.dart';
import 'widgets/auth_message_banner.dart';
import 'widgets/quote_card.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.successMessage, this.initialEmail});

  /// رسالة نجاح تظهر فوق الفورم (مثلاً بعد إنشاء الحساب).
  final String? successMessage;

  /// إيميل يتملى تلقائيًا في الحقل (مثلاً الإيميل اللي اتسجل بيه).
  final String? initialEmail;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late final _emailCtrl = TextEditingController(text: widget.initialEmail);
  final _passwordCtrl = TextEditingController();

  bool _obscure = true;
  bool _remember = true;
  bool _demoErrors = false;
  bool _submitting = false;
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;

  // أخطاء جاية من Firebase (بتظهر تحت الحقل المناسب أو في الشريط العام).
  String? _emailError;
  String? _passwordError;
  String? _bannerError;
  late String? _bannerSuccess = widget.successMessage;
  bool _needsVerification = false; // الحساب موجود بس الإيميل لسه ما اتأكدش
  DateTime? _resendAvailableAt; // فترة انتظار بين طلبات إعادة الإرسال

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  /// مفتاح "Demo validation error state": بيفعّل التحقق الفوري ويعرض
  /// كل رسائل الخطأ الحالية دفعة واحدة، مفيد لمعاينة شكل الأخطاء.
  void _toggleDemo(bool value) {
    setState(() {
      _demoErrors = value;
      _autovalidate = AutovalidateMode.onUserInteraction;
    });
    if (value) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _formKey.currentState?.validate());
    }
  }

  void _clearServerErrors() {
    _emailError = null;
    _passwordError = null;
    _bannerError = null;
    _bannerSuccess = null;
    _needsVerification = false;
  }

  /// إعادة إرسال رابط التحقق بنفس الإيميل والباسورد المكتوبين في الفورم.
  Future<void> _resendVerification() async {
    final wait = _resendAvailableAt?.difference(DateTime.now()).inSeconds ?? 0;
    if (wait > 0) {
      setState(() => _bannerError = 'Please wait $wait seconds before requesting another email.');
      return;
    }
    if (Validators.email(_emailCtrl.text) != null || _passwordCtrl.text.isEmpty) {
      setState(() => _bannerError = 'Enter your email and password first, then resend.');
      return;
    }
    setState(() => _submitting = true);
    final result = await AuthService.instance
        .resendVerification(email: _emailCtrl.text, password: _passwordCtrl.text);
    if (!mounted) return;
    setState(() {
      _submitting = false;
      _clearServerErrors();
      if (result.ok) {
        _resendAvailableAt = DateTime.now().add(const Duration(seconds: 30));
        _bannerSuccess = 'Verification email sent to ${_emailCtrl.text.trim()}.';
      } else if (!result.cancelled) {
        _bannerError = result.message;
      }
    });
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _autovalidate = AutovalidateMode.onUserInteraction;
      _clearServerErrors();
    });
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _submitting = true);
    final result = await AuthService.instance.signIn(
      email: _emailCtrl.text,
      password: _passwordCtrl.text,
      remember: _remember,
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    _handleResult(result);
  }

  Future<void> _continueWithGoogle() async {
    setState(() {
      _submitting = true;
      _clearServerErrors();
    });
    final result = await AuthService.instance.signInWithGoogle();
    if (!mounted) return;
    setState(() => _submitting = false);
    _handleResult(result);
  }

  /// نجاح → التطبيق الرئيسي. فشل → الرسالة تظهر في المكان المناسب.
  void _handleResult(AuthResult result) {
    if (result.ok) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainShell()),
        (route) => false,
      );
      return;
    }
    if (result.cancelled) return;
    setState(() {
      switch (result.field) {
        case AuthField.email:
          _emailError = result.message;
        case AuthField.password:
          _passwordError = result.message;
        case AuthField.general:
          _bannerError = result.message;
        case AuthField.unverified:
          _bannerError = result.message;
          _needsVerification = true;
      }
    });
    _formKey.currentState?.validate();
  }

  void _goSignup() => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SignupPage()),
      );

  void _goForgotPassword() => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.75),
            radius: 1.0,
            colors: [AppColors.glow, AppColors.background],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 30),
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AuthHeader(
                    title: 'Welcome Back',
                    subtitle: 'Sign in to continue your movie journey.',
                  ),
                  const SizedBox(height: 22),
                  FadeSlideIn(child: _DemoErrorToggle(
                    value: _demoErrors,
                    onChanged: _toggleDemo,
                  )),
                  const SizedBox(height: 18),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 80),
                    child: AppTextField(
                      label: 'Email address',
                      controller: _emailCtrl,
                      hint: 'you@example.com',
                      prefixIcon: Icons.mail_outline,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (v) => _emailError ?? Validators.email(v),
                      onChanged: (_) {
                        if (_emailError != null) setState(() => _emailError = null);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 140),
                    child: AppTextField(
                      label: 'Password',
                      controller: _passwordCtrl,
                      hint: 'Enter your password',
                      prefixIcon: Icons.lock_outline,
                      showObscureToggle: true,
                      isObscured: _obscure,
                      onToggleObscure: () => setState(() => _obscure = !_obscure),
                      textInputAction: TextInputAction.done,
                      validator: (v) => _passwordError ?? Validators.loginPassword(v),
                      onChanged: (_) {
                        if (_passwordError != null) setState(() => _passwordError = null);
                      },
                      trailing: GestureDetector(
                        onTap: _goForgotPassword,
                        child: Text('Forgot Password?',
                            style: AppText.body(12.5,
                                color: AppColors.primary, weight: FontWeight.w600)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => setState(() => _remember = !_remember),
                        child: Row(
                          children: [
                            CircleCheck(value: _remember),
                            const SizedBox(width: 8),
                            Text('Remember for 30 days',
                                style: AppText.body(12.5)),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.shield_outlined,
                              size: 13, color: AppColors.textDim),
                          const SizedBox(width: 4),
                          Text('Encrypted',
                              style: AppText.body(11, color: AppColors.textDim)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  if (_bannerError != null) ...[
                    AuthMessageBanner(
                      message: _bannerError!,
                      actionLabel: _needsVerification ? 'Resend verification email' : null,
                      onAction: _submitting ? null : _resendVerification,
                    ),
                    const SizedBox(height: 14),
                  ],
                  if (_bannerSuccess != null) ...[
                    AuthMessageBanner(message: _bannerSuccess!, isError: false),
                    const SizedBox(height: 14),
                  ],
                  PrimaryButton(
                    label: _submitting ? 'Logging in…' : 'Log In',
                    onPressed: _submitting ? () {} : _submit,
                    height: 52,
                  ),
                  const SizedBox(height: 18),
                  const SectionDivider(),
                  const SizedBox(height: 16),
                  SocialButton(
                    label: 'Continue with Google',
                    icon: const GoogleGlyph(),
                    onTap: _submitting ? null : _continueWithGoogle,
                  ),
                  const SizedBox(height: 20),
                  const QuoteCard(
                    quote:
                        '"Cinema is a matter of what\'s in the frame and what\'s out."',
                    author: '— Martin Scorsese',
                  ),
                  const SizedBox(height: 22),
                  Center(
                    child: BottomLink(
                      text: "Don't have an account?  ",
                      action: 'Create Account',
                      onTap: _goSignup,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// مفتاح Demo (طبقًا للتصميم) لمعاينة كل حالات الخطأ فورًا.
class _DemoErrorToggle extends StatelessWidget {
  const _DemoErrorToggle({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.science_outlined, size: 15, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text('Demo validation error state',
                style: AppText.body(12, weight: FontWeight.w600)),
          ),
          Transform.scale(
            scale: 0.75,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.onPrimary,
              activeTrackColor: AppColors.primary,
              inactiveThumbColor: AppColors.text,
              inactiveTrackColor: AppColors.surfaceHigh,
            ),
          ),
        ],
      ),
    );
  }
}
