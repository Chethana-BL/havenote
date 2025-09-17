import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:havenote/app/constants/app_icons.dart';
import 'package:havenote/app/constants/app_sizes.dart';
import 'package:havenote/app/router/routes.dart';
import 'package:havenote/core/logger.dart';
import 'package:havenote/features/auth/state/auth_providers.dart';
import 'package:havenote/features/auth/utils/auth_error_mapper.dart';
import 'package:havenote/l10n/app_localizations.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});
  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  bool _checking = false;
  int _cooldown = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Start or restart the cooldown timer.
  void _startCooldown([int secs = 30]) {
    setState(() => _cooldown = secs);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_cooldown <= 1) {
        t.cancel();
        setState(() => _cooldown = 0);
      } else {
        setState(() => _cooldown -= 1);
      }
    });
  }

  // Resend verification email.
  Future<void> _resend() async {
    final t = S.of(context);
    final repo = ref.read(authRepositoryProvider);

    try {
      await repo.sendEmailVerification();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.authVerifyResent)));
      _startCooldown();
    } catch (e, st) {
      Log.w('VerifyEmail: resend failed', e, st);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(mapAuthError(e, t))));
    }
  }

  // Check verification status.
  Future<void> _check() async {
    final t = S.of(context);
    final repo = ref.read(authRepositoryProvider);

    setState(() => _checking = true);
    try {
      final verified = await repo.refreshEmailVerification();

      Log.i('Email verified: $verified');
      if (!mounted) return;
      if (!verified) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(t.authVerifyNotVerified)));
      }
    } catch (e, st) {
      Log.w('VerifyEmail: check failed', e, st);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(mapAuthError(e, t))));
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    final user = ref.watch(currentUserProvider);
    final email = user?.email ?? '';
    final verified = user?.emailVerified ?? false;
    Log.i('Email verified build: $verified');

    return Scaffold(
      appBar: AppBar(title: Text(t.authVerifyTitle)),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.padding),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (verified)
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppSizes.spaceSM,
                        ),
                        child: Text(
                          t.authVerifyAlreadyVerified,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    Text(
                      t.authVerifyBody(email),
                      style: Theme.of(context).textTheme.bodyMedium,
                      softWrap: true,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: AppSizes.spaceLG),

                    Wrap(
                      spacing: AppSizes.spaceSM,
                      runSpacing: AppSizes.spaceSM,
                      children: [
                        FilledButton.icon(
                          onPressed:
                              (_checking || user == null) ? null : _check,
                          icon:
                              _checking
                                  ? const SizedBox(
                                    width: AppSizes.iconSM,
                                    height: AppSizes.iconSM,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Icon(AppIcons.check),
                          label: Text(
                            _checking
                                ? t.authVerifyChecking
                                : t.authVerifyIveVerified,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed:
                              (_cooldown > 0 || user == null) ? null : _resend,
                          icon: const Icon(AppIcons.send),
                          label: Text(
                            _cooldown > 0
                                ? t.authVerifyWait(_cooldown)
                                : t.authVerifyResend,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSizes.space),

                    // Back to Sign-In
                    TextButton.icon(
                      onPressed:
                          user == null
                              ? null
                              : () async {
                                // Sign out and back to Sign-In
                                await ref
                                    .read(authRepositoryProvider)
                                    .signOut();
                                if (!context.mounted) return;
                                context.go(AppRoute.auth());
                              },
                      icon: const Icon(AppIcons.back),
                      label: Text(t.actionSignIn),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
