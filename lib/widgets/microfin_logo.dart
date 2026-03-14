import 'package:flutter/material.dart';
import '../theme.dart';

class MicroFinLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final double textFontSize;

  const MicroFinLogo({
    super.key,
    this.size = 40.0,
    this.showText = true,
    this.textFontSize = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Interlocking Icon
        SizedBox(
          width: size + (size * 0.2), // Accounts for the offset
          height: size + (size * 0.2),
          child: Stack(
            children: [
              // Back Cyan Shape
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: AppTheme.accentCyan,
                    borderRadius: BorderRadius.circular(size * 0.25),
                  ),
                ),
              ),
              // Front Purple Shape
              Positioned(
                left: 0,
                bottom: 0,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(size * 0.25),
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(right: size * 0.05),
                      child: Text(
                        'P',
                        style: TextStyle(
                          color: AppTheme.background, // Cutout effect showing background
                          fontSize: size * 0.65,
                          fontWeight: FontWeight.w900,
                          height: 1.0,
                          letterSpacing: 0,
                          fontFamily: 'Outfit',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showText) ...[
          const SizedBox(width: 12),
          Text(
            'MicroFin',
            style: TextStyle(
              fontSize: textFontSize,
              fontWeight: FontWeight.w800,
              color: AppTheme.label,
              letterSpacing: -0.5,
              fontFamily: 'Outfit',
            ),
          ),
        ]
      ],
    );
  }
}
