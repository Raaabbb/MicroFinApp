import 'package:flutter/material.dart';
import 'dart:async';
import 'sacredheart_web_ui_screen.dart';

class SacredheartSplashScreen extends StatefulWidget {
  const SacredheartSplashScreen({super.key});

  @override
  State<SacredheartSplashScreen> createState() =>
      _SacredheartSplashScreenState();
}

class _SacredheartSplashScreenState extends State<SacredheartSplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SacredheartWebUiScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'lib/assets/SacredLogo.png',
                    width: 64,
                    height: 64,
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SacredHeart',
                      style: TextStyle(
                        color: Color(0xFF7C3AED), // Purple primary color
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1,
                      ),
                    ),
                    Text(
                      'COOPERATIVE',
                      style: TextStyle(
                        color: Color(0xFF7C3AED),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 48),
            CircularProgressIndicator(
              color: const Color(0xFF7C3AED).withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}
