import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/application/auth_controller.dart';
import '../../features/auth/application/auth_state.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import 'routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authChanged = ValueNotifier<Object?>(null);
  ref.onDispose(authChanged.dispose);
  ref.listen(authControllerProvider, (_, next) => authChanged.value = next);

  return GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: authChanged,
    redirect: (context, state) {
      if (state.matchedLocation == Routes.splash) return null;

      final signedIn = ref.read(authControllerProvider) is Authenticated;
      if (!signedIn) {
        return state.matchedLocation == Routes.login ? null : Routes.login;
      }

      return state.matchedLocation == Routes.login ? Routes.home : null;
    },
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
});
