import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../application/pin_controller.dart';
import 'widgets/numeric_keypad.dart';
import 'widgets/pin_dots.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(pinControllerProvider, (previous, next) {
      if (next.status.hasError && previous?.status.hasError != true) {
        HapticFeedback.mediumImpact();
      }
    });

    final state = ref.watch(pinControllerProvider);
    final controller = ref.read(pinControllerProvider.notifier);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        children: [
          const _BrandHeader(),
          const SizedBox(height: AppSpacing.lg),
          const Text(
            'Please enter your M-PESA PIN',
            textAlign: .center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          PinDots(filled: state.pin.length, hasError: state.status.hasError),
          SizedBox(
            height: 68,
            child: Center(child: _StatusMessage(state: state)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
              child: NumericKeypad(
                enabled: !state.isSubmitting && !state.isLocked,
                onDigit: controller.append,
                onBackspace: controller.backspace,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: FilledButton(
              onPressed:
                  state.isComplete && !state.isSubmitting && !state.isLocked
                  ? controller.submit
                  : null,
              child: state.isSubmitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Continue'),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: Text(
              'Forgot password?',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.ink.withValues(alpha: 0.75),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Center(
            child: Text(
              'Demo PIN · 1111',
              style: TextStyle(color: AppColors.inkMuted, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.brandRamp,
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppSpacing.radiusLg + 12),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x4D6E2E14),
            blurRadius: 28,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(AppSpacing.radiusLg + 12),
        ),
        child: Stack(
          children: [
            const Positioned(top: -78, right: -56, child: _Ring(size: 210)),
            const Positioned(top: -30, right: -96, child: _Ring(size: 180)),
            const Positioned(bottom: -70, left: -48, child: _Ring(size: 150)),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.xl,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Row(
                      children: [
                        for (var i = 0; i < 3; i++)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(right: 6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.55),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Center(
                      child: Image.asset(
                        mpesaLogo,
                        height: 68,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      children: [
                        const _AvatarPhoto(),
                        const SizedBox(width: AppSpacing.md),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: .start,
                            mainAxisSize: .min,
                            children: [
                              Text(
                                'Welcome Back',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 21,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Sign in to continue',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
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
          color: Colors.white.withValues(alpha: 0.16),
          width: 18,
        ),
      ),
    );
  }
}

class _AvatarPhoto extends StatelessWidget {
  const _AvatarPhoto();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 82,
      height: 82,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(colors: [AppColors.gold, Colors.white]),
        boxShadow: [
          BoxShadow(
            color: AppColors.brandDeep.withValues(alpha: 0.35),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.network(
          avatarPhotoUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const _AvatarFallback(),
          loadingBuilder: (context, child, progress) =>
              progress == null ? child : const _AvatarFallback(),
        ),
      ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFBFD4E3), Color(0xFF8FA9BC)],
        ),
      ),
      child: Icon(Iconsax.user, color: Colors.white, size: 36),
    );
  }
}

class _StatusMessage extends StatelessWidget {
  const _StatusMessage({required this.state});

  final PinFormState state;

  @override
  Widget build(BuildContext context) {
    if (state.isLocked) {
      return Text(
        'Too many attempts. Try again in ${state.secondsUntilUnlock}s',
        textAlign: .center,
        style: const TextStyle(color: AppColors.danger, fontSize: 13.5),
      );
    }

    final error = state.errorText;
    if (error == null) return const SizedBox.shrink();

    return Column(
      mainAxisSize: .min,
      children: [
        Text(
          error,
          textAlign: .center,
          style: const TextStyle(color: AppColors.danger, fontSize: 13.5),
        ),
        if (state.attemptsLeft < maxAttempts) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${state.attemptsLeft} attempt${state.attemptsLeft == 1 ? '' : 's'} left',
            style: const TextStyle(color: AppColors.inkMuted, fontSize: 12),
          ),
        ],
      ],
    );
  }
}
