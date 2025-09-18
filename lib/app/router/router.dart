import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:havenote/app/router/routes.dart';
import 'package:havenote/core/logger.dart';
import 'package:havenote/features/auth/presentation/forgot_password_screen.dart';
import 'package:havenote/features/auth/presentation/reauth_screen.dart';
import 'package:havenote/features/auth/presentation/sign_in_screen.dart';
import 'package:havenote/features/auth/presentation/sign_up_screen.dart';
import 'package:havenote/features/auth/presentation/verify_email_screen.dart';
import 'package:havenote/features/home/presentation/home_screen.dart';
import 'package:havenote/features/settings/presentation/settings_screen.dart';
import 'package:havenote/features/splash/presentation/splash_screen.dart';

/// [ChangeNotifier] wrapper around a [Stream].
/// Notifies its listeners whenever the stream emits a new event.
class StreamListenable extends ChangeNotifier {
  /// Subscribes to the given [stream] and notifies listeners on every event.
  StreamListenable(Stream<dynamic> stream) {
    _sub = stream.listen(
      (_) => notifyListeners(),
      onError: (_) {},
      cancelOnError: false,
    );
  }

  late final StreamSubscription _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

/// The main app router, using GoRouter.
/// Uses [FirebaseAuth.userChanges] so email-verified/token refreshes trigger router refresh.
final routerProvider = Provider<GoRouter>((ref) {
  // Listen to token/auth changes
  final authStreamListenable = StreamListenable(
    FirebaseAuth.instance.userChanges(),
  );

  // Ensure proper cleanup if provider is ever disposed/recreated.
  ref.onDispose(authStreamListenable.dispose);

  return GoRouter(
    initialLocation: AppRoutePath.splash,
    refreshListenable: authStreamListenable,
    routes: [
      GoRoute(
        name: AppRouteName.splash,
        path: AppRoutePath.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        name: AppRouteName.auth,
        path: AppRoutePath.auth,
        builder: (_, __) => const SignInScreen(),
      ),
      GoRoute(
        name: AppRouteName.signUp,
        path: AppRoutePath.signUp,
        builder: (_, __) => const SignUpScreen(),
      ),
      GoRoute(
        name: AppRouteName.verifyEmail,
        path: AppRoutePath.verifyEmail,
        builder: (_, __) => const VerifyEmailScreen(),
      ),
      GoRoute(
        name: AppRouteName.forgotPassword,
        path: AppRoutePath.forgotPassword,
        builder: (_, __) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        name: AppRouteName.home,
        path: AppRoutePath.home,
        builder: (_, __) => const HomeScreen(),
      ),
      GoRoute(
        name: AppRouteName.settings,
        path: AppRoutePath.settings,
        builder: (_, __) => const SettingsScreen(),
      ),
      GoRoute(
        name: AppRouteName.reauth,
        path: AppRoutePath.reauth,
        builder: (_, __) => const ReauthScreen(),
      ),
    ],

    redirect: (context, state) async {
      final user = FirebaseAuth.instance.currentUser;
      final location = state.uri.path;
      Log.d('GoRouter: location=$location');

      final inAuthFlow = location.startsWith(AppRoutePath.auth);
      final atVerify = location == AppRoutePath.verifyEmail;
      final atReauth = location == AppRoutePath.reauth;
      final atSplash = location == AppRoutePath.splash;

      // Not signed in → allow /auth/* and /splash; otherwise go to /auth.
      if (user == null) {
        if (inAuthFlow || atSplash) return null;
        Log.i('GoRouter: redirect → /auth (unauthenticated)');
        return AppRoutePath.auth;
      }

      // Signed in but not email-verified → force /verify-email (allow reauth & splash)
      if (!user.emailVerified && !atVerify && !atReauth && !atSplash) {
        Log.i('GoRouter: redirect → /verify-email (unverified)');
        return AppRoutePath.verifyEmail;
      }

      // Signed in & verified → block navigating into /auth/* (except /reauth) → /home
      if (inAuthFlow && user.emailVerified && !atReauth) {
        Log.i('GoRouter: redirect → /home (already authenticated)');
        return AppRoutePath.home;
      }

      return null;
    },
    errorBuilder:
        (_, state) => Scaffold(
          body: Center(child: Text('Route not found: ${state.uri}')),
        ),
  );
});
