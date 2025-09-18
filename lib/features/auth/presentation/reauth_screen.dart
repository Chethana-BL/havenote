import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:havenote/app/constants/app_icons.dart';
import 'package:havenote/app/constants/app_sizes.dart';
import 'package:havenote/core/logger.dart';
import 'package:havenote/features/auth/presentation/widgets/auth_widgets.dart';
import 'package:havenote/features/auth/state/auth_providers.dart';
import 'package:havenote/features/auth/utils/auth_error_mapper.dart';
import 'package:havenote/l10n/app_localizations.dart';

class ReauthScreen extends ConsumerStatefulWidget {
  const ReauthScreen({super.key});
  @override
  ConsumerState<ReauthScreen> createState() => _ReauthScreenState();
}

class _ReauthScreenState extends ConsumerState<ReauthScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;
  bool _obscure = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    _email.text = user?.email ?? '';
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final t = S.of(context);
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    setState(() {
      _loading = true;
      _error = null;
    });

    final repo = ref.read(authRepositoryProvider);
    final email = _email.text.trim();
    final password = _password.text;

    try {
      await repo.reauthenticateWithEmail(email, password);
      if (!mounted) return;
      context.pop(true); // success → return true
    } on FirebaseAuthException catch (e, st) {
      Log.w('Reauth failed', e, st);
      if (!mounted) return;
      setState(() => _error = mapAuthError(e, t)); // inline error; stay
    } catch (e, st) {
      Log.w('Reauth unexpected error', e, st);
      if (!mounted) return;
      setState(() => _error = t.errorGeneric);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(t.authReauthTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.padding),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              children: [
                Text(
                  t.authReauthSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSizes.space),

                // Email (read-only)
                TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                    labelText: t.labelEmail,
                    prefixIcon: const Icon(AppIcons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  readOnly: true,
                ),
                const SizedBox(height: AppSizes.space),

                // Password
                AuthPasswordField(
                  controller: _password,
                  label: t.labelPassword,
                  obscure: _obscure,
                  onToggleObscure: () => setState(() => _obscure = !_obscure),
                  validator:
                      (v) =>
                          (v == null || v.isEmpty)
                              ? t.authErrorInvalidCredentials
                              : null,
                  onSubmitted: _submit,
                  isNew: false,
                ),

                if (_error != null) ...[
                  const SizedBox(height: AppSizes.spaceSM),
                  Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],

                const SizedBox(height: AppSizes.space),

                // Confirm
                AuthSubmitButton(
                  loading: _loading,
                  icon: AppIcons.check,
                  label: t.actionConfirm,
                  onPressed: _submit,
                ),

                const SizedBox(height: AppSizes.space),

                // Cancel → return false
                Center(
                  child: TextButton.icon(
                    onPressed: () => context.pop(false),
                    icon: const Icon(AppIcons.back),
                    label: Text(S.of(context).actionCancel),
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
