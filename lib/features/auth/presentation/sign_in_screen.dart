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

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});
  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;
  bool _obscure = true;
  String? _formError;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  String? _validateEmail(String? v, S t) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return t.authErrorInvalidEmail;
    final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(s);
    if (!ok) return t.authErrorInvalidEmail;
    return null;
  }

  String? _validatePassword(String? v, S t) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return t.authErrorInvalidPassword;
    return null;
  }

  Future<void> _submit() async {
    final t = S.of(context);
    final repo = ref.read(authRepositoryProvider);

    if (!(_formKey.currentState?.validate() ?? false)) return;

    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    setState(() {
      _loading = true;
      _formError = null;
    });

    final email = _email.text.trim();
    final pwd = _password.text.trim();

    try {
      await repo.signInWithEmail(email, pwd);
    } catch (e, st) {
      Log.w('SignIn failed', e, st);
      if (!mounted) return;
      setState(() => _formError = mapAuthError(e, t));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.paddingLG),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    // Logo/title
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        t.appTitle.characters.first,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.space),
                    Center(
                      child: Text(
                        t.appTitle,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceLG),

                    // Email
                    AuthEmailField(
                      controller: _email,
                      label: t.labelEmail,
                      validator: (v) => _validateEmail(v, t),
                      onSubmitted: () => FocusScope.of(context).nextFocus(),
                    ),
                    const SizedBox(height: AppSizes.space),

                    // Password + show/hide toggle
                    AuthPasswordField(
                      controller: _password,
                      label: t.labelPassword,
                      obscure: _obscure,
                      onToggleObscure:
                          () => setState(() => _obscure = !_obscure),
                      validator: (v) => _validatePassword(v, t),
                      onSubmitted: _submit,
                    ),

                    // Top-level error (from submit)
                    if (_formError != null) ...[
                      const SizedBox(height: AppSizes.spaceSM),
                      Text(
                        _formError!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],

                    const SizedBox(height: AppSizes.space),

                    // Sign in button with spinner
                    AuthSubmitButton(
                      loading: _loading,
                      icon: AppIcons.login,
                      label: t.actionSignIn,
                      onPressed: _submit,
                    ),

                    const SizedBox(height: AppSizes.spaceSM),

                    // Forgot + Sign up links
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed:
                              () => context.push(AppRoute.forgotPassword()),
                          child: Text(t.labelForgotPassword),
                        ),
                        TextButton(
                          onPressed: () => context.push(AppRoute.signUp()),
                          child: Text(t.actionSignUp),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
