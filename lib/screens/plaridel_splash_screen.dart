import 'package:flutter/material.dart';
import 'dart:async';
import 'plaridel_web_ui_screen.dart';

class PlaridelSplashScreen extends StatefulWidget {
  const PlaridelSplashScreen({super.key});

  @override
  State<PlaridelSplashScreen> createState() => _PlaridelSplashScreenState();
}

class _PlaridelSplashScreenState extends State<PlaridelSplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PlaridelWebUiScreen()),
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(Icons.grass_rounded, color: Color(0xFF059669), size: 56),
                SizedBox(width: 8),
                Text(
                  'Plaridel',
                  style: TextStyle(
                    color: Color(0xFF059669), // Green primary color
                    fontSize: 48,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'MICROFIN',
              style: TextStyle(
                color: Color(0xFF059669),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 40),
            CircularProgressIndicator(
              color: const Color(0xFF059669).withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}
