import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.size = 88, this.onDarkBackground = false});

  final double size;
  final bool onDarkBackground;

  @override
  Widget build(BuildContext context) {
    final tileColor = onDarkBackground ? Colors.white : AppColors.brand;
    final glyphColor = onDarkBackground ? AppColors.brand : Colors.white;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: [
          BoxShadow(
            color: AppColors.brandDeep.withValues(alpha: 0.18),
            blurRadius: size * 0.3,
            offset: Offset(0, size * 0.1),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        'M',
        style: TextStyle(
          color: glyphColor,
          fontSize: size * 0.52,
          fontWeight: FontWeight.w800,
          height: 1,
        ),
      ),
    );
  }
}

class MpesaWordmark extends StatelessWidget {
  const MpesaWordmark({super.key, required this.color, this.fontSize = 30});

  final Color color;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      'M-PESA',
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.5,
        height: 1,
      ),
    );
  }
}
