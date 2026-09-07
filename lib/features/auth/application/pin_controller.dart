import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import 'auth_controller.dart';

const pinLength = 4;
const maxAttempts = 3;
const lockoutDuration = Duration(seconds: 30);

class PinFormState {
  const PinFormState({
    this.pin = '',
    this.failedAttempts = 0,
    this.lockedUntil,
    this.status = const AsyncData<void>(null),
  });

  PinFormState.lockedOut(DateTime this.lockedUntil, this.status)
    : pin = '',
      failedAttempts = 0;

  final String pin;
  final int failedAttempts;
  final DateTime? lockedUntil;
  final AsyncValue<void> status;

  bool get isComplete => pin.length == pinLength;
  bool get isSubmitting => status.isLoading;
  int get attemptsLeft => maxAttempts - failedAttempts;

  bool get isLocked {
    final until = lockedUntil;
    return until != null && until.isAfter(DateTime.now());
  }

  int get secondsUntilUnlock {
    final until = lockedUntil;
    if (until == null) return 0;

    return until.difference(DateTime.now()).inSeconds.clamp(0, 999);
  }

  String? get errorText => switch (status) {
    AsyncError(:final error) when error is ApiException => error.message,
    AsyncError() => 'Something went wrong. Please try again.',
    _ => null,
  };

  PinFormState copyWith({
    String? pin,
    int? failedAttempts,
    AsyncValue<void>? status,
  }) => PinFormState(
    pin: pin ?? this.pin,
    failedAttempts: failedAttempts ?? this.failedAttempts,
    lockedUntil: lockedUntil,
    status: status ?? this.status,
  );
}

class PinController extends Notifier<PinFormState> {
  Timer? _ticker;

  @override
  PinFormState build() {
    ref.onDispose(() => _ticker?.cancel());

    return const PinFormState();
  }

  void append(String digit) {
    if (state.isLocked || state.isSubmitting || state.pin.length >= pinLength) {
      return;
    }

    state = state.copyWith(
      pin: state.pin + digit,
      status: const AsyncData<void>(null),
    );
  }

  void backspace() {
    if (state.isLocked || state.isSubmitting || state.pin.isEmpty) return;

    state = state.copyWith(pin: state.pin.substring(0, state.pin.length - 1));
  }

  Future<void> submit() async {
    if (!state.isComplete || state.isSubmitting || state.isLocked) return;

    state = state.copyWith(status: const AsyncLoading<void>());
    try {
      await ref.read(authControllerProvider.notifier).signIn(state.pin);
      state = const PinFormState();
    } on ApiException catch (error, stackTrace) {
      _registerFailure(error, stackTrace);
    }
  }

  void _registerFailure(ApiException error, StackTrace stackTrace) {
    // Only a rejected PIN burns an attempt. A dropped connection is not the
    // customer's fault and must not push them towards a lockout.
    final failed = error is InvalidPin
        ? state.failedAttempts + 1
        : state.failedAttempts;

    if (failed >= maxAttempts) {
      state = PinFormState.lockedOut(
        DateTime.now().add(lockoutDuration),
        AsyncError(error, stackTrace),
      );
      _startTicker();
      return;
    }

    state = state.copyWith(
      pin: '',
      failedAttempts: failed,
      status: AsyncError(error, stackTrace),
    );
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.isLocked) {
        state = state.copyWith();
        return;
      }

      timer.cancel();
      state = const PinFormState();
    });
  }
}

final pinControllerProvider = NotifierProvider<PinController, PinFormState>(
  PinController.new,
);
