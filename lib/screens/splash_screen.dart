import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import '../theme.dart';
import '../widgets/microfin_logo.dart';
import 'main_layout.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _bgAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.70, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOutBack),
      ),
    );

    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 1.0, curve: Curves.easeOut),
      ),
    );

    _bgAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _startSplashSequence();
  }

  void _startSplashSequence() async {
    FlutterNativeSplash.remove();
    await _controller.forward();
    await Future.delayed(const Duration(milliseconds: 700));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (context, animation, secondaryAnimation) =>
              const MainLayout(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: child,
            );
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              // Cyan gradient background blob top-right
              Positioned(
                top: -100,
                right: -100,
                child: Opacity(
                  opacity: _bgAnimation.value * 0.08,
                  child: Container(
                    width: 360,
                    height: 360,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.accentCyan,
                    ),
                  ),
                ),
              ),
              // Blue gradient background blob bottom-left
              Positioned(
                bottom: -80,
                left: -80,
                child: Opacity(
                  opacity: _bgAnimation.value * 0.06,
                  child: Container(
                    width: 280,
                    height: 280,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primaryDark,
                    ),
                  ),
                ),
              ),
              // Main Content
              Center(
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo with shadow glowing effect
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: AppTheme.surface,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primary.withOpacity(0.15),
                                  blurRadius: 36,
                                  offset: const Offset(0, 14),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: MicroFinLogo(
                                size: 50.0,
                                showText: false,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          const Text(
                            'MicroFin',
                            style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.label,
                              letterSpacing: -1.5,
                              fontFamily: 'Outfit',
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Your Unified Lending Hub',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppTheme.primaryLight,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 64),
                          _PulsingDots(animation: _controller),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PulsingDots extends StatelessWidget {
  final Animation<double> animation;
  const _PulsingDots({required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: (animation.value * 2.5).clamp(0.0, 1.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (i) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.35 + i * 0.25),
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
