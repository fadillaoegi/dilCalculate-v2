import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key, required this.nextPage});

  final Widget nextPage;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _backgroundController;
  late final AnimationController _pulseController;
  late final AnimationController _fadeController;
  Timer? _autoContinueTimer;

  Offset? _tapPosition;
  double _tapRadius = 0;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat(reverse: true);
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
      value: 1,
    );

    _autoContinueTimer = Timer(
      const Duration(milliseconds: 2600),
      _continueToApp,
    );
  }

  @override
  void dispose() {
    _autoContinueTimer?.cancel();
    _backgroundController.dispose();
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _continueToApp() async {
    if (_isNavigating || !mounted) return;
    _isNavigating = true;
    await _fadeController.reverse();
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => widget.nextPage));
  }

  void _handleTapDown(TapDownDetails details) {
    if (_isNavigating) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    final localPosition = box.globalToLocal(details.globalPosition);
    setState(() {
      _tapPosition = localPosition;
      _tapRadius = 0;
    });

    Future.microtask(() {
      if (!mounted) return;
      setState(() {
        _tapRadius = math.max(box.size.width, box.size.height) * 0.75;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final backgroundTop = isDark
        ? const Color(0xFF0F172A)
        : const Color(0xFFE0ECFF);
    final backgroundBottom = isDark
        ? const Color(0xFF172554)
        : const Color(0xFFF4F8FF);
    final orbOne = isDark ? const Color(0xFF38BDF8) : const Color(0xFF60A5FA);
    final orbTwo = isDark ? const Color(0xFF6366F1) : const Color(0xFFA78BFA);
    final titleColor = colorScheme.onSurface;

    return FadeTransition(
      opacity: _fadeController,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _handleTapDown,
        onTap: _continueToApp,
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [backgroundTop, backgroundBottom],
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _backgroundController,
                builder: (context, _) {
                  final t = _backgroundController.value * 2 * math.pi;
                  return Stack(
                    children: [
                      _movingOrb(
                        left: 36 + math.sin(t) * 22,
                        top: 86 + math.cos(t) * 16,
                        size: 150,
                        color: orbOne.withValues(alpha: 0.22),
                      ),
                      _movingOrb(
                        right: 20 + math.cos(t * 0.8) * 26,
                        top: 188 + math.sin(t * 0.9) * 18,
                        size: 210,
                        color: orbTwo.withValues(alpha: 0.18),
                      ),
                      _movingOrb(
                        left: 116 + math.cos(t * 0.6) * 18,
                        bottom: 88 + math.sin(t * 0.7) * 20,
                        size: 180,
                        color: orbTwo.withValues(alpha: 0.12),
                      ),
                    ],
                  );
                },
              ),
              if (_tapPosition != null)
                Positioned.fill(
                  child: IgnorePointer(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 520),
                      curve: Curves.easeOutCubic,
                      foregroundDecoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment(
                            (_tapPosition!.dx /
                                        MediaQuery.of(context).size.width) *
                                    2 -
                                1,
                            (_tapPosition!.dy /
                                        MediaQuery.of(context).size.height) *
                                    2 -
                                1,
                          ),
                          radius:
                              _tapRadius /
                              math.max(
                                MediaQuery.of(context).size.width,
                                MediaQuery.of(context).size.height,
                              ),
                          colors: [
                            colorScheme.primary.withValues(alpha: 0.16),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  child: Column(
                    children: [
                      const Spacer(),
                      Hero(
                        tag: 'app-splash-logo',
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorScheme.surface.withValues(alpha: 0.9),
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.24,
                                ),
                                blurRadius: 24,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(18),
                          child: Image.asset('assets/icon/launcher_icon.png'),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'DilCalculate',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: titleColor,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Smart. Fast. Accurate.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: titleColor.withValues(alpha: 0.72),
                          letterSpacing: 0,
                        ),
                      ),
                      const Spacer(),
                      FadeTransition(
                        opacity: Tween<double>(
                          begin: 0.35,
                          end: 1,
                        ).animate(_pulseController),
                        child: Text(
                          'Tap anywhere to continue',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: titleColor.withValues(alpha: 0.72),
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _movingOrb({
    double? left,
    double? right,
    double? top,
    double? bottom,
    required double size,
    required Color color,
  }) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
