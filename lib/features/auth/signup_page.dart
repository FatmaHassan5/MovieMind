

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
import 'login_page.dart';
import 'widgets/auth_header.dart';
import 'widgets/auth_message_banner.dart';
import 'widgets/password_strength_meter.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreed = false;
  bool _submitting = false;
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;

  // أخطاء جاية من Firebase (بتظهر تحت الحقل المناسب أو في الشريط العام).
  String? _emailError;
  String? _passwordError;
  String? _bannerError;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _autovalidate = AutovalidateMode.onUserInteraction;
      _emailError = _passwordError = _bannerError = null;
    });
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _submitting = true);
    final result = await AuthService.instance.signUp(
      name: _nameCtrl.text,
      email: _emailCtrl.text,
      password: _passwordCtrl.text,
    );
    if (!mounted) return;
    setState(() => _submitting = false);

    if (result.ok) {
      // الحساب اتعمل → نروح للوجين عشان المستخدم يدخل بنفسه.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => LoginPage(
            successMessage: 'Account created! We sent a verification link to '
                '${_emailCtrl.text.trim()}. Verify your email, then log in.',
            initialEmail: _emailCtrl.text.trim(),
          ),
        ),
      );
      return;
    }
    _showError(result);
  }

  Future<void> _continueWithGoogle() async {
    setState(() {
      _submitting = true;
      _emailError = _passwordError = _bannerError = null;
    });
    final result = await AuthService.instance.signInWithGoogle();
    if (!mounted) return;
    setState(() => _submitting = false);

    if (result.ok) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainShell()),
        (route) => false,
      );
      return;
    }
    _showError(result);
  }

  void _showError(AuthResult result) {
    if (result.cancelled) return;
    setState(() {
      switch (result.field) {
        case AuthField.email:
          _emailError = result.message;
        case AuthField.password:
          _passwordError = result.message;
        case AuthField.general:
        case AuthField.unverified:
          _bannerError = result.message;
      }
    });
    _formKey.currentState?.validate();
  }

  void _goLogin() => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
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
                    title: 'Create Your Account',
                    subtitle: 'Join MovieMind and discover movies made for you.',
                  ),
                  const SizedBox(height: 22),
                  FadeSlideIn(
                    child: AppTextField(
                      label: 'Full Name',
                      controller: _nameCtrl,
                      hint: 'Fatma Hassan',
                      prefixIcon: Icons.person_outline,
                      textInputAction: TextInputAction.next,
                      validator: Validators.fullName,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 60),
                    child: AppTextField(
                      label: 'Email Address',
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
                    delay: const Duration(milliseconds: 120),
                    child: AppTextField(
                      label: 'Password',
                      controller: _passwordCtrl,
                      hint: 'Create a strong password',
                      prefixIcon: Icons.lock_outline,
                      showObscureToggle: true,
                      isObscured: _obscurePassword,
                      onToggleObscure: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      textInputAction: TextInputAction.next,
                      onChanged: (_) => setState(() => _passwordError = null),
                      validator: (_) =>
                          _passwordError ?? Validators.signupPassword(_passwordCtrl.text),
                    ),
                  ),
                  const SizedBox(height: 10),
                  PasswordStrengthMeter(password: _passwordCtrl.text),
                  const SizedBox(height: 16),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 180),
                    child: AppTextField(
                      label: 'Confirm Password',
                      controller: _confirmCtrl,
                      hint: 'Re-enter your password',
                      prefixIcon: Icons.lock_clock_outlined,
                      showObscureToggle: true,
                      isObscured: _obscureConfirm,
                      onToggleObscure: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                      textInputAction: TextInputAction.done,
                      validator: (v) =>
                          Validators.confirmPassword(v, _passwordCtrl.text),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _TermsField(
                    value: _agreed,
                    onChanged: (v) => setState(() => _agreed = v),
                  ),
                  const SizedBox(height: 20),
                  if (_bannerError != null) ...[
                    AuthMessageBanner(message: _bannerError!),
                    const SizedBox(height: 14),
                  ],
                  PrimaryButton(
                    label: _submitting ? 'Creating account…' : 'Create Account',
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
                  const SizedBox(height: 22),
                  Center(
                    child: BottomLink(
                      text: 'Already have an account?  ',
                      action: 'Log In',
                      onTap: _goLogin,
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

/// FormField مخصص لمربع الموافقة على الشروط، عشان يشارك في التحقق العام
/// للفورم ويظهر رسالة خطأ زي باقي الحقول لو المستخدم مضغطش عليه.
class _TermsField extends FormField<bool> {
  _TermsField({required bool value, required ValueChanged<bool> onChanged})
      : super(
          initialValue: value,
          validator: Validators.termsAgreement,
          builder: (state) {
            void toggle() {
              final next = !(state.value ?? false);
              state.didChange(next);
              onChanged(next);
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: toggle,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: SquareCheck(value: state.value ?? false),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: AppText.body(12.5,
                                color: AppColors.textMuted,
                                weight: FontWeight.w400),
                            children: const [
                              TextSpan(text: 'I agree to the '),
                              TextSpan(
                                text: 'Terms & Conditions',
                                style: TextStyle(
                                    color: AppColors.primary,
                                    decoration: TextDecoration.underline),
                              ),
                              TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                    color: AppColors.primary,
                                    decoration: TextDecoration.underline),
                              ),
                              TextSpan(text: '.'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 30),
                    child: Text(state.errorText!,
                        style: AppText.body(11.5, color: AppColors.error)),
                  ),
              ],
            );
          },
        );
}
