import 'package:flutter/material.dart';
import 'dart:async';
import 'fundline_dashboard_screen.dart';

class FundlineSplashScreen extends StatefulWidget {
  const FundlineSplashScreen({super.key});

  @override
  State<FundlineSplashScreen> createState() => _FundlineSplashScreenState();
}

class _FundlineSplashScreenState extends State<FundlineSplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const FundlineDashboardScreen()),
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
                Text(
                  'fundline',
                  style: TextStyle(
                    color: Color(0xFFDC2626), // red primary color
                    fontSize: 48,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -2,
                  ),
                ),
                SizedBox(width: 4),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'FINANCE CORPORATION',
                    style: TextStyle(
                      color: Color(0xFFDC2626),
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            CircularProgressIndicator(
              color: const Color(0xFFDC2626).withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}
