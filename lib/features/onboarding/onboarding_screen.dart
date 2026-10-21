import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../auth/login_page.dart';
import 'pages/ask_ai_page.dart';
import 'pages/discover_page.dart';
import 'pages/recommend_page.dart';
import 'widgets/onboarding_buttons.dart';
import 'widgets/onboarding_header.dart';
import 'widgets/page_indicator.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _pageCount = 3;
  static const _pageDuration = Duration(milliseconds: 450);

  final _controller = PageController();
  int _index = 0;

  bool get _isFirst => _index == 0;
  bool get _isLast => _index == _pageCount - 1;

  void _goTo(int page) => _controller.animateToPage(
        page,
        duration: _pageDuration,
        curve: Curves.easeOutCubic,
      );

  void _next() => _isLast ? _finish() : _goTo(_index + 1);

  void _back() => _isFirst ? Navigator.of(context).maybePop() : _goTo(_index - 1);

  /// Skip و Get Started بيودّوا لشاشة تسجيل الدخول الحقيقية.
  void _finish() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            OnboardingHeader(onBack: _back),
            const SizedBox(height: 14),
            _buildTopBar(),
            const SizedBox(height: 6),
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (i) => setState(() => _index = i),
                children: const [
                  DiscoverPage(),
                  RecommendPage(),
                  AskAiPage(),
                ],
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  /// الصف العلوي: STEP 1 OF 3 / Back  +  Skip.
  Widget _buildTopBar() {
    return SizedBox(
      height: 46,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: switch (_index) {
                0 => const TopChip(
                    key: ValueKey('step'),
                    label: 'STEP 1 OF 3',
                    icon: Icons.movie_creation_outlined),
                1 => TopChip(
                    key: const ValueKey('back'),
                    label: 'Back',
                    icon: Icons.chevron_left,
                    onTap: _back),
                _ => const SizedBox.shrink(key: ValueKey('none')),
              },
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: _isLast ? 0 : 1,
              child: IgnorePointer(
                ignoring: _isLast,
                child: TopChip(label: 'Skip', onTap: _finish),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// الفوتر بيتغير حسب الصفحة (نقط + أزرار).
  Widget _buildFooter() {
    final indicator = PageIndicator(
      count: _pageCount,
      index: _index,
      onTap: _goTo,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 10, 22, 22),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 250),
        alignment: Alignment.topCenter,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: KeyedSubtree(
            key: ValueKey(_index),
            child: switch (_index) {
              0 => Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        indicator,
                        Text(
                          'Personalized feed in 3 steps',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: AppColors.textDim,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                            child: PrimaryButton(
                                label: 'Continue', onPressed: _next)),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 52,
                          child: SecondaryButton(
                              icon: Icons.tune, onPressed: () {}),
                        ),
                      ],
                    ),
                  ],
                ),
              1 => Column(
                  children: [
                    indicator,
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                            flex: 4,
                            child: SecondaryButton(
                                label: 'Back', onPressed: _back, height: 54)),
                        const SizedBox(width: 10),
                        Expanded(
                            flex: 6,
                            child: PrimaryButton(
                                label: 'Continue', onPressed: _next, height: 54)),
                      ],
                    ),
                  ],
                ),
              _ => Column(
                  children: [
                    indicator,
                    const SizedBox(height: 10),
                    PrimaryButton(
                        label: 'Get Started', onPressed: _next, height: 54),
                    const SizedBox(height: 4),
                    TextButton.icon(
                      onPressed: _back,
                      icon: const Icon(Icons.arrow_back,
                          color: AppColors.textMuted, size: 15),
                      label: Text('Back',
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 13, color: AppColors.textMuted)),
                    ),
                  ],
                ),
            },
          ),
        ),
      ),
    );
  }
}
