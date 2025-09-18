import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:havenote/app/constants/app_icons.dart';
import 'package:havenote/app/constants/app_sizes.dart';
import 'package:havenote/app/router/routes.dart';
import 'package:havenote/core/logger.dart';
import 'package:havenote/features/auth/presentation/widgets/auth_widgets.dart';
import 'package:havenote/features/auth/state/auth_providers.dart';
import 'package:havenote/features/auth/utils/auth_error_mapper.dart';
import 'package:havenote/l10n/app_localizations.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;
  String? _backendError;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  String? _validateEmail(String? v, S t) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return t.authErrorInvalidEmail;
    final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(s);
    return ok ? null : t.authErrorInvalidEmail;
  }

  Future<void> _submit() async {
    final t = S.of(context);
    final repo = ref.read(authRepositoryProvider);

    if (!(_formKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _loading = true;
      _backendError = null;
    });

    final email = _emailCtrl.text.trim();

    try {
      await repo.sendPasswordResetEmail(email);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.authForgotSuccess)));
      context.go(AppRoute.auth());
    } on FirebaseAuthException catch (e, st) {
      Log.w('ForgotPassword: reset failed', e, st);
      if (!mounted) return;
      setState(() => _backendError = mapAuthError(e, t));
    } catch (e, st) {
      Log.w('ForgotPassword: unexpected error', e, st);
      if (!mounted) return;
      setState(() => _backendError = t.errorGeneric);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(t.authForgotTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.padding),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.authForgotSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSizes.space),

                // Email field
                AuthEmailField(
                  controller: _emailCtrl,
                  label: t.labelEmail,
                  validator: (v) => _validateEmail(v, t),
                ),

                if (_backendError != null) ...[
                  const SizedBox(height: AppSizes.spaceSM),
                  Text(
                    _backendError!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],

                const SizedBox(height: AppSizes.space),

                // Submit button
                AuthSubmitButton(
                  loading: _loading,
                  icon: AppIcons.send,
                  label: t.authForgotSend,
                  onPressed: _submit,
                ),

                const SizedBox(height: AppSizes.space),

                // Back to Sign-In
                Center(
                  child: TextButton.icon(
                    onPressed: () => context.go(AppRoute.auth()),
                    icon: const Icon(AppIcons.back),
                    label: Text(t.authForgotBack),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
