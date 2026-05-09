import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_scan/l10n/app_localizations.dart';
import '../providers/settings_provider.dart';

class OnboardingScreen extends StatefulWidget {

  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _direction = 1; //pour animation

  List<_OnboardingStep> _getSteps(AppLocalizations l10n) => [
    //2eme page :+10 lanagages
    _OnboardingStep(
      title: l10n.onboarding1Title,
      description: l10n.onboarding1Desc,
      gradientColors: [const Color(0xFFEFF6FF), const Color(0xFFECFEFF)],
      accentColor: const Color(0xFF3B82F6),
      dotColor: const Color(0xFF3B82F6),
      illustrationBuilder: () => const _LanguagesIllustration(),
      //illustrationBuilder : C’est une fonction qui retourne un widget : () => Widget.
    ),
    //3eme page : camera 
    _OnboardingStep(
      title: l10n.onboarding2Title,
      description: l10n.onboarding2Desc,
    gradientColors: [const Color(0xFFEFF6FF), const Color(0xFFECFEFF)],
      accentColor: const Color(0xFF3B82F6),
      dotColor: const Color(0xFF3B82F6),
      illustrationBuilder: () => const _CameraIllustration(),
    ),
    //4eme page : lecture
    _OnboardingStep(
      title: l10n.onboarding3Title,
      description: l10n.onboarding3Desc,
      gradientColors: [const Color(0xFFEFF6FF), const Color(0xFFECFEFF)],
      accentColor: const Color(0xFF3B82F6),
      dotColor: const Color(0xFF3B82F6),
      illustrationBuilder: () => const _VoiceIllustration(),
    ),
    //5eme page : offline translation
    _OnboardingStep(
      title: l10n.onboarding4Title,
      description: l10n.onboarding4Desc,
     gradientColors: [const Color(0xFFEFF6FF), const Color(0xFFECFEFF)],
      accentColor: const Color(0xFF3B82F6),
      dotColor: const Color(0xFF3B82F6),
      illustrationBuilder: () => const _OfflineIllustration(),
    ),
  ];

  void _onFinish() { //button finish
    Navigator.pushReplacementNamed(context, '/');
    // Va vers la page principale
    // Supprime l’écran actuel (onboarding)
    // Empêche le retour arrière
  }

  void _nextPage(int stepsCount) {
    if (_currentPage < stepsCount) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _onFinish();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final steps = _getSteps(l10n);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _direction = page > _currentPage ? 1 : -1;
                _currentPage = page;
              });
            },
            children: [
              _buildWelcomePage(l10n),
              ...steps.map((step) => _buildStepPage(step)),
            ],
          ),
          if (_currentPage > 0)
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              right: 20,
              child: TextButton(
                onPressed: _onFinish,
                child: Text(
                  l10n.onboardingSkip,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          if (_currentPage > 0)
            Positioned(
              bottom: 120,
              left: 0,
              right: 0,
              child: _buildPageIndicator(steps.length),
            ),
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: _buildMainButton(l10n, steps),
          ),
        ],
      ),
    );
  }

//les pages 2,3,4,5
  Widget _buildStepPage(_OnboardingStep step) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: step.gradientColors,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Expanded(
              child: Center(
                child: step.illustrationBuilder(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 140),
              child: Column(
                children: [
                  Text(
                    step.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    step.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6B7280),
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// 1er page
  Widget _buildWelcomePage(AppLocalizations l10n) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.5, 1.0],
          colors: [
            Color(0xFF2563EB),
            Color(0xFF0891B2),
            Color(0xFF0D9488),
          ],
        ),
      ),
      child: Stack(
        children: [
          ..._floatingWords.map((w) => _FloatingWordWidget(word: w)),
          Center(
            child: FractionalTranslation(
              translation: const Offset(0, -0.1),
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const _LogoWithRings(),
                      const SizedBox(height: 40),
                      _FadeSlideIn(
                        delay: const Duration(milliseconds: 500),
                        child: const Text(
                          'SmartScan',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _FadeSlideIn(
                        delay: const Duration(milliseconds: 700),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            l10n.onboardingWelcome,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Color(0xCCFFFFFF),
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _FadeSlideIn(
                        delay: const Duration(milliseconds: 1000),
                        child: const Icon(
                          Icons.auto_awesome,
                          color: Color(0x66FFFFFF),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 120),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int stepsCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        stepsCount + 1,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: _currentPage == index ? 24 : 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? (_currentPage == 0 ? Colors.white : Colors.blueAccent)
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
//*********************************************************************************** */
  Widget _buildMainButton(AppLocalizations l10n, List<_OnboardingStep> steps) {
    final bool isWelcome = _currentPage == 0;
    final bool isLast = _currentPage == steps.length;
    final String text = isWelcome ? l10n.onboardingStart : (isLast ? l10n.onboardingFinish : l10n.onboardingNext);
    final Color backgroundColor = isWelcome
        ? Colors.white
        : steps[_currentPage - 1].accentColor;
    final Color foregroundColor = isWelcome ? const Color(0xFF2563EB) : Colors.white;

    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () => _nextPage(steps.length),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: isWelcome ? 0 : 4,
          shadowColor: isWelcome ? Colors.transparent : backgroundColor.withOpacity(0.4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (!isWelcome && !isLast) ...[
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward, size: 20),
            ]
          ],
        ),
      ),
    );
  }
}

class _OnboardingStep {
  final String title;
  final String description;
  final List<Color> gradientColors;
  final Color accentColor;
  final Color dotColor;
  final Widget Function() illustrationBuilder;

  const _OnboardingStep({
    required this.title,
    required this.description,
    required this.gradientColors,
    required this.accentColor,
    required this.dotColor,
    required this.illustrationBuilder,
  });
}

// ─── Floating word data ──────────────────────────────────────────────────────
class _FloatingWord {
  final String text;
  final double x;
  final double y;
  final double delay;
  final double fontSize;

  const _FloatingWord({
    required this.text,
    required this.x,
    required this.y,
    required this.delay,
    required this.fontSize,
  });
}

const _floatingWords = [
  _FloatingWord(text: 'Hello', x: 0.12, y: 0.18, delay: 0.0, fontSize: 14),
  _FloatingWord(text: 'مرحبا', x: 0.75, y: 0.14, delay: 0.4, fontSize: 16),
  _FloatingWord(text: '你好', x: 0.20, y: 0.72, delay: 0.8, fontSize: 16),
  _FloatingWord(text: 'Hola', x: 0.78, y: 0.68, delay: 1.2, fontSize: 14),
  _FloatingWord(text: 'こんにちは', x: 0.65, y: 0.38, delay: 0.6, fontSize: 12),
  _FloatingWord(text: 'Ciao', x: 0.08, y: 0.45, delay: 1.0, fontSize: 14),
  _FloatingWord(text: '안녕', x: 0.85, y: 0.50, delay: 0.2, fontSize: 14),
  _FloatingWord(text: 'Olá', x: 0.30, y: 0.85, delay: 1.4, fontSize: 12),
];

// ─── Logo with animated rings ────────────────────────────────────────────────
class _LogoWithRings extends StatefulWidget {
  const _LogoWithRings();

  @override
  State<_LogoWithRings> createState() => _LogoWithRingsState();
}

class _LogoWithRingsState extends State<_LogoWithRings> with TickerProviderStateMixin {
  late final AnimationController _logoCtrl;
  final List<AnimationController> _ringCtrs = [];
  final List<Animation<double>> _ringScales = [];
  final List<Animation<double>> _ringOpacities = [];

  @override
  void initState() {
    super.initState();

    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    for (int i = 0; i < 3; i++) {
      final ctrl = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 3),
      );
      _ringCtrs.add(ctrl);

      _ringScales.add(Tween<double>(begin: 1.0, end: 1.0 + (i + 1) * 0.25)
          .animate(CurvedAnimation(parent: ctrl, curve: Curves.easeOut)));

      _ringOpacities.add(TweenSequence([
        TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.3), weight: 20),
        TweenSequenceItem(tween: Tween(begin: 0.3, end: 0.0), weight: 80),
      ]).animate(ctrl));

      Future.delayed(Duration(milliseconds: 600 * i), () {
        if (mounted) ctrl.repeat();
      });
    }
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    for (final c in _ringCtrs) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logoAnim = CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut);

    return ScaleTransition(
      scale: Tween<double>(begin: 0.5, end: 1.0).animate(logoAnim),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _logoCtrl, curve: Curves.easeOut),
        ),
        child: SizedBox(
          width: 160,
          height: 160,
          child: Stack(
            alignment: Alignment.center,
            children: [
              for (int i = 0; i < 3; i++)
                AnimatedBuilder(
                  animation: _ringCtrs[i],
                  builder: (_, __) => Transform.scale(
                    scale: _ringScales[i].value,
                    child: Opacity(
                      opacity: _ringOpacities[i].value,
                      child: Container(
                        width: 112,
                        height: 112,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.4),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  color: Colors.white.withOpacity(0.15),
                  border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 60,
                      offset: const Offset(0, 20),
                    ),
                  ],
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white.withOpacity(0.20), Colors.transparent],
                  ),
                ),
                child: const Icon(Icons.document_scanner_outlined, size: 56, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Floating word widget ────────────────────────────────────────────────────
class _FloatingWordWidget extends StatefulWidget {
  final _FloatingWord word;
  const _FloatingWordWidget({required this.word});

  @override
  State<_FloatingWordWidget> createState() => _FloatingWordWidgetState();
}

class _FloatingWordWidgetState extends State<_FloatingWordWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;
  late final Animation<double> _translateY;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 6));

    _opacity = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 15),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 55),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 30),
    ]).animate(_ctrl);

    _translateY = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -12.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: -12.0, end: 0.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));

    Future.delayed(
      Duration(milliseconds: (widget.word.delay * 1000).round()),
      () { if (mounted) _ctrl.repeat(); },
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) => Transform.translate(
          offset: Offset(
            widget.word.x * MediaQuery.of(context).size.width,
            widget.word.y * MediaQuery.of(context).size.height + _translateY.value,
          ),
          child: Opacity(
            opacity: _opacity.value * 0.12,
            child: Text(
              widget.word.text,
              style: TextStyle(
                fontSize: widget.word.fontSize,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    });
  }
}

// ─── Fade + Slide in helper ──────────────────────────────────────────────────
class _FadeSlideIn extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Offset slideOffset;

  const _FadeSlideIn({
    required this.child,
    required this.delay,
    this.slideOffset = const Offset(0, 24),
  });

  @override
  State<_FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<_FadeSlideIn> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _opacity = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut)
        .drive(Tween(begin: 0.0, end: 1.0));
    _slide = Tween<Offset>(begin: widget.slideOffset, end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    Future.delayed(widget.delay, () { if (mounted) _ctrl.forward(); });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) => Opacity(
        opacity: _opacity.value,
        child: Transform.translate(offset: _slide.value, child: child),
      ),
      child: widget.child,
    );
  }
}

// ─── Illustration 1: Languages ────────────────────────────────────────────────
const _languages = ['EN', 'FR', 'ES', 'DE', 'JP', '中文', 'AR', 'PT', 'KO', 'IT', 'RU', 'HI'];

class _LanguagesIllustration extends StatefulWidget {
  const _LanguagesIllustration();
  @override
  State<_LanguagesIllustration> createState() => _LanguagesIllustrationState();
}

class _LanguagesIllustrationState extends State<_LanguagesIllustration>
    with TickerProviderStateMixin {
  late final AnimationController _ring1;
  late final AnimationController _ring2;
  late final AnimationController _globeCtrl;
  final List<AnimationController> _pillCtrs = [];

  @override
  void initState() {
    super.initState();
    _ring1 = AnimationController(vsync: this, duration: const Duration(seconds: 30))..repeat();
    _ring2 = AnimationController(vsync: this, duration: const Duration(seconds: 20))..repeat();
    _globeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..forward();

    for (int i = 0; i < _languages.length; i++) {
      final c = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
      _pillCtrs.add(c);
      Future.delayed(Duration(milliseconds: 400 + i * 60), () { if (mounted) c.forward(); });
    }
  }

  @override
  void dispose() {
    _ring1.dispose();
    _ring2.dispose();
    _globeCtrl.dispose();
    for (final c in _pillCtrs) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 260,
        height: 260,
        child: Stack(
          alignment: Alignment.center,
          children: [
            RotationTransition(
              turns: _ring1,
              child: Container(
                width: 208, height: 208,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF93C5FD).withOpacity(0.5), width: 1),
                ),
              ),
            ),
            RotationTransition(
              turns: Tween(begin: 0.0, end: -1.0).animate(_ring2),
              child: Container(
                width: 144, height: 144,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF93C5FD).withOpacity(0.3), width: 1),
                ),
              ),
            ),
            ScaleTransition(
              scale: CurvedAnimation(parent: _globeCtrl, curve: Curves.elasticOut),
              child: Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFDBEAFE),
                  boxShadow: [BoxShadow(color: const Color(0xFF93C5FD).withOpacity(0.5), blurRadius: 20)],
                ),
                child: const Icon(Icons.language, size: 40, color: Color(0xFF3B82F6)),
              ),
            ),
            for (int i = 0; i < _languages.length; i++)
              _LanguagePill(
                lang: _languages[i],
                index: i,
                total: _languages.length,
                controller: _pillCtrs[i],
              ),
          ],
        ),
      ),
    );
  }
}

class _LanguagePill extends StatelessWidget {
  final String lang;
  final int index;
  final int total;
  final AnimationController controller;

  const _LanguagePill({
    required this.lang,
    required this.index,
    required this.total,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final angle = (index * 360 / total - 90) * pi / 180;
    final radius = index % 2 == 0 ? 105.0 : 80.0;
    final dx = cos(angle) * radius;
    final dy = sin(angle) * radius;

    return AnimatedBuilder(
      animation: controller,
      builder: (_, child) {
        final v = CurvedAnimation(parent: controller, curve: Curves.elasticOut).value;
        return Transform.translate(
          offset: Offset(dx * v, dy * v),
          child: Opacity(opacity: controller.value.clamp(0.0, 1.0), child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFBFDBFE), width: 1),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6)],
        ),
        child: Text(
          lang,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
        ),
      ),
    );
  }
}

// ─── Illustration 2: Camera ───────────────────────────────────────────────────
class _CameraIllustration extends StatefulWidget {
  const _CameraIllustration();
  @override
  State<_CameraIllustration> createState() => _CameraIllustrationState();
}

class _CameraIllustrationState extends State<_CameraIllustration>
    with TickerProviderStateMixin {
  late final AnimationController _boxCtrl;
  late final AnimationController _scanCtrl;
  final List<AnimationController> _lineCtrs = [];

  @override
  void initState() {
    super.initState();
    _boxCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..forward();
    _scanCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2500))..repeat(reverse: true);

    for (int i = 0; i < 3; i++) {
      final c = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
      _lineCtrs.add(c);
      Future.delayed(Duration(milliseconds: 600 + i * 100), () { if (mounted) c.forward(); });
    }
  }

  @override
  void dispose() {
    _boxCtrl.dispose();
    _scanCtrl.dispose();
    for (final c in _lineCtrs) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: CurvedAnimation(parent: _boxCtrl, curve: Curves.easeOutBack),
        child: FadeTransition(
          opacity: _boxCtrl,
          child: Container(
            width: 192, height: 224,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF93C5FD).withOpacity(0.6), width: 2),
              boxShadow: [BoxShadow(color: const Color(0xFFDBEAFE).withOpacity(0.5), blurRadius: 24, offset: const Offset(0, 8))],
            ),
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (int i = 0; i < 3; i++)
                          _AnimatedLine(controller: _lineCtrs[i], widthFactor: i == 1 ? 0.75 : 1.0),
                      ],
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: _scanCtrl,
                  builder: (_, __) => Transform.translate(
                    offset: Offset(0, 40 + _scanCtrl.value * 144),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6),
                          boxShadow: [BoxShadow(color: const Color(0xFF3B82F6).withOpacity(0.5), blurRadius: 8, spreadRadius: 2)],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedLine extends StatelessWidget {
  final AnimationController controller;
  final double widthFactor;
  const _AnimatedLine({required this.controller, required this.widthFactor});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: controller,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: FractionallySizedBox(
          widthFactor: widthFactor,
          alignment: Alignment.centerLeft,
          child: Container(height: 12, decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6))),
        ),
      ),
    );
  }
}

// ─── Illustration 3: read ────────────────────────────────────────────────────
class _VoiceIllustration extends StatefulWidget {
  const _VoiceIllustration();
  @override
  State<_VoiceIllustration> createState() => _VoiceIllustrationState();
}

class _VoiceIllustrationState extends State<_VoiceIllustration>
    with TickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  final List<AnimationController> _waveCtrs = [];

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    for (int i = 0; i < 5; i++) {
      final c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
      _waveCtrs.add(c);
      Future.delayed(Duration(milliseconds: i * 300), () { if (mounted) c.repeat(); });
    }
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    for (final c in _waveCtrs) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200, height: 200,
        child: Stack(
          alignment: Alignment.center,
          children: [
            for (int i = 0; i < 5; i++)
              AnimatedBuilder(
                animation: _waveCtrs[i],
                builder: (_, __) {
                  final v = _waveCtrs[i].value;
                  return Container(
                    width: 60 + v * 140, height: 60 + v * 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF60A5FA).withOpacity((1 - v) * 0.4), width: 2),
                    ),
                  );
                },
              ),
            ScaleTransition(
              scale: Tween<double>(begin: 1.0, end: 1.1).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut)),
              child: Container(
                width: 72, height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF3B82F6),
                  boxShadow: [BoxShadow(color: const Color(0xFF3B82F6).withOpacity(0.4), blurRadius: 20, spreadRadius: 4)],
                ),
                child: const Icon(Icons.volume_up_rounded, size: 36, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Illustration 4: Offline ──────────────────────────────────────────────────
class _OfflineIllustration extends StatefulWidget {
  const _OfflineIllustration();
  @override
  State<_OfflineIllustration> createState() => _OfflineIllustrationState();
}

class _OfflineIllustrationState extends State<_OfflineIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) {
              return Container(
                width: 160 + sin(_ctrl.value * 2 * pi) * 10,
                height: 160 + sin(_ctrl.value * 2 * pi) * 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFDBEAFE).withOpacity(0.5),
                ),
              );
            },
          ),
          Container(
            width: 100, height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF3B82F6),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3B82F6).withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                )
              ],
            ),
            child: const Icon(Icons.wifi_off_rounded, size: 48, color: Colors.white),
          ),
          ...List.generate(3, (i) {
            final angle = (i * 120) * pi / 180;
            return AnimatedBuilder(
              animation: _ctrl,
              builder: (_, __) {
                final offset = 70 + sin(_ctrl.value * 2 * pi + i) * 5;
                return Transform.translate(
                  offset: Offset(cos(angle) * offset, sin(angle) * offset),
                  child: Container(
                    width: 12, height: 12,
                    decoration: const BoxDecoration(color: Color(0xFF3B82F6), shape: BoxShape.circle),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}