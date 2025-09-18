import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:havenote/app/constants/app_sizes.dart';
import 'package:havenote/app/router/routes.dart';
import 'package:havenote/core/logger.dart';
import 'package:havenote/features/auth/state/auth_providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      final user = ref.read(currentUserProvider);
      // No user → route to auth.
      if (user == null) {
        Log.i('Splash: no user → /auth');
        if (!mounted) return;
        context.go(AppRoute.auth());
        return;
      }

      // User exists → refresh verification state and route accordingly.
      final repo = ref.read(authRepositoryProvider);
      final verified = await repo.refreshEmailVerification();
      Log.i('Splash: verified=$verified');

      if (!mounted) return;
      context.go(verified ? AppRoute.home() : AppRoute.verifyEmail());
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: _SplashBody()));
  }
}

class _SplashBody extends StatelessWidget {
  const _SplashBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircleAvatar(radius: AppSizes.iconXL, child: _HBadge()),
        const SizedBox(height: AppSizes.space),
        Text(
          S.of(context).appTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: AppSizes.spaceSM),
        const CircularProgressIndicator(),
      ],
    );
  }
}

class _HBadge extends StatelessWidget {
  const _HBadge();

  @override
  Widget build(BuildContext context) {
    return Text(
      'H',
      style: Theme.of(
        context,
      ).textTheme.headlineMedium?.copyWith(color: Colors.white),
    );
  }
}
