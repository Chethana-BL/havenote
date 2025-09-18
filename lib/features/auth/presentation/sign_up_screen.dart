import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:havenote/app/constants/app_icons.dart';
import 'package:havenote/app/constants/app_sizes.dart';
import 'package:havenote/app/router/routes.dart';
import 'package:havenote/core/logger.dart';
import 'package:havenote/features/auth/presentation/widgets/auth_widgets.dart';
import 'package:havenote/features/auth/state/auth_providers.dart';
import 'package:havenote/features/auth/utils/auth_error_mapper.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});
  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;
  bool _obscure1 = true;
  bool _obscure2 = true;
  String? _submitError;

  // live state for rules
  bool _hasMin = false,
      _hasUpper = false,
      _hasLower = false,
      _hasDigit = false,
      _hasSpecial = false,
      _match = false;

  @override
  void initState() {
    super.initState();
    _passwordCtrl.addListener(_recalculateRules);
    _confirmCtrl.addListener(_recalculateRules);
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  // Recalculate password rules state.
  void _recalculateRules() {
    final p = _passwordCtrl.text;
    final c = _confirmCtrl.text;
    setState(() {
      _hasMin = p.length >= 8;
      _hasUpper = RegExp(r'[A-Z]').hasMatch(p);
      _hasLower = RegExp(r'[a-z]').hasMatch(p);
      _hasDigit = RegExp(r'\d').hasMatch(p);
      _hasSpecial = RegExp(
        r'[!@#\$%^&*(),.?":{}|<>_\-\\/\[\]=+~`]',
      ).hasMatch(p);
      _match = p.isNotEmpty && p == c;
    });
  }

  // Returns 0..5 password strength score.
  int _score() {
    var s = 0;
    if (_hasMin) s++;
    if (_hasUpper) s++;
    if (_hasLower) s++;
    if (_hasDigit) s++;
    if (_hasSpecial) s++;
    return s; // 0..5
  }

  // Basic email validation
  String? _validateEmail(String? v, S t) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return t.authErrorInvalidEmail;
    final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(s);
    return ok ? null : t.authErrorInvalidEmail;
  }

  // Basic password validation (length only, rules shown separately)
  String? _validatePassword(String? v, S t) {
    final s = (v ?? '');
    if (s.length < 8) return t.authPasswordRuleMinLength;
    return null;
  }

  // Confirm password matches?
  String? _validateConfirm(String? v, S t) {
    return (v ?? '') == _passwordCtrl.text ? null : t.authPasswordRuleMatch;
  }

  // All rules satisfied?
  bool get _allOk => _score() >= 3 && _match; // at least medium and match

  // Form submission
  Future<void> _submit() async {
    final t = S.of(context);
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_allOk) {
      setState(() => _submitError = t.authErrorWeakPassword);
      return;
    }

    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    setState(() {
      _loading = true;
      _submitError = null;
    });

    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;
    final repo = ref.read(authRepositoryProvider);

    try {
      await repo.registerWithEmail(email, password);
      await repo.sendEmailVerification();
    } on FirebaseAuthException catch (e, st) {
      Log.w('SignUp failed', e, st);
      if (!mounted) return;
      setState(() => _submitError = mapAuthError(e, S.of(context)));
    } catch (e, st) {
      Log.w('SignUp error (non-Firebase)', e, st);
      if (!mounted) return;
      setState(() => _submitError = S.of(context).errorGeneric);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    final score = _score();
    final strengthLabel = switch (score) {
      <= 2 => t.authPasswordWeak,
      3 || 4 => t.authPasswordMedium,
      _ => t.authPasswordStrong,
    };

    return Scaffold(
      appBar: AppBar(title: Text(t.authSignUpTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.padding),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              children: [
                Text(
                  t.authSignUpSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSizes.space),

                // Email field
                AuthEmailField(
                  controller: _emailCtrl,
                  label: t.labelEmail,
                  validator: (v) => _validateEmail(v, t),
                  onSubmitted: () {}, // focus to password
                ),
                const SizedBox(height: AppSizes.space),

                // Password field
                AuthPasswordField(
                  controller: _passwordCtrl,
                  label: t.labelPassword,
                  obscure: _obscure1,
                  onToggleObscure: () => setState(() => _obscure1 = !_obscure1),
                  validator: (v) => _validatePassword(v, t),
                  onSubmitted: () => FocusScope.of(context).nextFocus(),
                ),
                const SizedBox(height: AppSizes.spaceSM),

                // Strength indicator
                Row(
                  children: [
                    Text('${t.authPasswordStrength} $strengthLabel'),
                    const SizedBox(width: AppSizes.spaceSM),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppSizes.radius),
                        child: LinearProgressIndicator(
                          value: (score / 5.0).clamp(0, 1),
                          minHeight: 6,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.space),

                // Confirm password field
                AuthPasswordField(
                  controller: _confirmCtrl,
                  label: t.authSignUpConfirmPasswordLabel,
                  obscure: _obscure2,
                  onToggleObscure: () => setState(() => _obscure2 = !_obscure2),
                  validator: (v) => _validateConfirm(v, t),
                  onSubmitted: _submit,
                ),
                const SizedBox(height: AppSizes.space),

                // Password Rules checklist
                _PasswordRulesChecklist(
                  hasMin: _hasMin,
                  hasUpper: _hasUpper,
                  hasLower: _hasLower,
                  hasDigit: _hasDigit,
                  hasSpecial: _hasSpecial,
                  match: _match,
                ),

                // Top-level error (from submit)
                if (_submitError != null) ...[
                  const SizedBox(height: AppSizes.spaceSM),
                  Text(
                    _submitError!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: AppSizes.space),

                // Sign up button with spinner
                AuthSubmitButton(
                  loading: _loading,
                  icon: AppIcons.check,
                  label: t.actionSignUp,
                  onPressed: _submit,
                ),
                const SizedBox(height: AppSizes.space),
                Center(
                  child: TextButton(
                    onPressed: () => context.go(AppRoute.auth()),
                    child: Text(t.authSignUpToSignIn),
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

class _PasswordRulesChecklist extends StatelessWidget {
  const _PasswordRulesChecklist({
    required this.hasMin,
    required this.hasUpper,
    required this.hasLower,
    required this.hasDigit,
    required this.hasSpecial,
    required this.match,
  });

  final bool hasMin;
  final bool hasUpper;
  final bool hasLower;
  final bool hasDigit;
  final bool hasSpecial;
  final bool match;

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    return Column(
      children: [
        Text(
          t.authPasswordRulesTitle,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        _RuleRow(ok: hasMin, text: t.authPasswordRuleMinLength),
        _RuleRow(ok: hasUpper, text: t.authPasswordRuleUpper),
        _RuleRow(ok: hasLower, text: t.authPasswordRuleLower),
        _RuleRow(ok: hasDigit, text: t.authPasswordRuleDigit),
        _RuleRow(ok: hasSpecial, text: t.authPasswordRuleSpecial),
        _RuleRow(ok: match, text: t.authPasswordRuleMatch),
      ],
    );
  }
}

class _RuleRow extends StatelessWidget {
  const _RuleRow({required this.ok, required this.text});
  final bool ok;
  final String text;

  @override
  Widget build(BuildContext context) {
    final color =
        ok
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).disabledColor;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceXS),
      child: Row(
        children: [
          Icon(
            ok ? AppIcons.check : AppIcons.circle,
            size: AppSizes.iconSM,
            color: color,
          ),
          const SizedBox(width: AppSizes.spaceSM),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
