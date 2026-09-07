import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../data/models/user.dart';

const _reward = 0.0;

class BalanceCard extends StatefulWidget {
  const BalanceCard({super.key, required this.user});

  final User user;

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  bool _revealed = false;
  Timer? _hide;

  void _toggle() {
    _hide?.cancel();
    setState(() => _revealed = !_revealed);

    // Auto-hide so a balance is never left on screen after the user walks away.
    if (_revealed) {
      _hide = Timer(const Duration(seconds: 5), () {
        if (mounted) setState(() => _revealed = false);
      });
    }
  }

  @override
  void dispose() {
    _hide?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.brandRamp,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.brandDeep.withValues(alpha: 0.34),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: Stack(
          children: [
            const Positioned(bottom: -64, right: -34, child: _Ring(size: 168)),
            const Positioned(top: -52, right: 42, child: _Ring(size: 120)),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Main Balance',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const _AddMoneyButton(),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    _revealed ? user.formattedBalance : '********',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    crossAxisAlignment: .end,
                    children: [
                      Expanded(
                        child: _Figure(
                          label: 'Reward',
                          value: _revealed ? formatRewardFor(user) : '****',
                        ),
                      ),
                      Expanded(
                        child: _Figure(
                          label: 'End Balance',
                          value: _revealed ? user.formattedBalance : '****',
                        ),
                      ),
                      InkWell(
                        onTap: _toggle,
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.xs),
                          child: Icon(
                            _revealed ? Iconsax.eye_slash : Iconsax.eye,
                            size: 26,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddMoneyButton extends StatelessWidget {
  const _AddMoneyButton();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('Add money is not part of this build.'),
              behavior: SnackBarBehavior.floating,
            ),
          ),
        child: const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.sm + AppSpacing.xs,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            mainAxisSize: .min,
            children: [
              Icon(Iconsax.add, color: Colors.white, size: 18),
              SizedBox(width: 5),
              Text(
                'Add money',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Ring extends StatelessWidget {
  const _Ring({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.14),
          width: 16,
        ),
      ),
    );
  }
}

String formatRewardFor(User user) =>
    '${user.currency} ${_reward.toStringAsFixed(2)}';

class _Figure extends StatelessWidget {
  const _Figure({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      mainAxisSize: .min,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
