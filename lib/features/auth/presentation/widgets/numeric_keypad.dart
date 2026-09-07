import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/theme/app_colors.dart';

const _rows = [
  ['1', '2', '3'],
  ['4', '5', '6'],
  ['7', '8', '9'],
  ['', '0', '<'],
];

class NumericKeypad extends StatelessWidget {
  const NumericKeypad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
    this.enabled = true,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: Column(
        mainAxisSize: .min,
        children: [
          for (final row in _rows)
            Row(
              children: [
                for (final key in row)
                  Expanded(
                    child: switch (key) {
                      '' => const SizedBox(height: 62),
                      '<' => _Key(
                        enabled: enabled,
                        onTap: onBackspace,
                        child: const Icon(Iconsax.arrow_left, size: 24),
                      ),
                      _ => _Key(
                        enabled: enabled,
                        onTap: () => onDigit(key),
                        child: Text(
                          key,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                    },
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _Key extends StatelessWidget {
  const _Key({required this.child, required this.onTap, required this.enabled});

  final Widget child;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(40),
        onTap: enabled
            ? () {
                HapticFeedback.selectionClick();
                onTap();
              }
            : null,
        child: SizedBox(height: 62, child: Center(child: child)),
      ),
    );
  }
}
