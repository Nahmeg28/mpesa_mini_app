import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../application/pin_controller.dart';

class PinDots extends StatefulWidget {
  const PinDots({super.key, required this.filled, required this.hasError});

  final int filled;
  final bool hasError;

  @override
  State<PinDots> createState() => _PinDotsState();
}

class _PinDotsState extends State<PinDots> with SingleTickerProviderStateMixin {
  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );

  @override
  void didUpdateWidget(PinDots oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hasError && !oldWidget.hasError) _shake.forward(from: 0);
  }

  @override
  void dispose() {
    _shake.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shake,
      builder: (context, child) {
        final offset =
            math.sin(_shake.value * math.pi * 4) * 12 * (1 - _shake.value);

        return Transform.translate(offset: Offset(offset, 0), child: child);
      },
      child: Row(
        mainAxisAlignment: .center,
        children: [
          for (var i = 0; i < pinLength; i++)
            _PinBox(
              filled: i < widget.filled,
              hasError: widget.hasError,
              isLast: i == pinLength - 1,
            ),
        ],
      ),
    );
  }
}

class _PinBox extends StatelessWidget {
  const _PinBox({
    required this.filled,
    required this.hasError,
    required this.isLast,
  });

  final bool filled;
  final bool hasError;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final accent = hasError ? AppColors.danger : AppColors.ink;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      margin: EdgeInsets.only(right: isLast ? 0 : 14),
      width: 62,
      height: 62,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent, width: 1.6),
      ),
      alignment: Alignment.center,
      child: filled
          ? Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: hasError ? AppColors.danger : AppColors.brand,
              ),
            )
          : null,
    );
  }
}
