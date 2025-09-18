import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:havenote/app/constants/app_icons.dart';
import 'package:havenote/app/constants/app_sizes.dart';

class AuthEmailField extends StatelessWidget {
  const AuthEmailField({
    super.key,
    required this.controller,
    required this.label,
    required this.validator,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final String? Function(String?) validator;
  final VoidCallback? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(AppIcons.email),
      ),
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email],
      validator: validator,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => onSubmitted?.call(),
    );
  }
}

class AuthPasswordField extends StatelessWidget {
  const AuthPasswordField({
    super.key,
    required this.controller,
    required this.label,
    required this.obscure,
    required this.onToggleObscure,
    this.validator,
    this.onSubmitted,
    this.isNew = false,
  });

  final TextEditingController controller;
  final String label;
  final bool obscure;
  final VoidCallback onToggleObscure;
  final String? Function(String?)? validator;
  final VoidCallback? onSubmitted;
  final bool isNew; // true for sign-up

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(AppIcons.lock),
        suffixIcon: IconButton(
          tooltip: obscure ? t.actionShow : t.actionHide,
          onPressed: onToggleObscure,
          icon: Icon(obscure ? AppIcons.visibility : AppIcons.visibilityOff),
        ),
      ),
      enableSuggestions: false,
      autocorrect: false,
      autofillHints:
          isNew
              ? const [AutofillHints.newPassword]
              : const [AutofillHints.password],
      validator: validator,
      onFieldSubmitted: (_) => onSubmitted?.call(),
    );
  }
}

class AuthSubmitButton extends StatelessWidget {
  const AuthSubmitButton({
    super.key,
    required this.loading,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final bool loading;
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: loading ? null : onPressed,
        icon:
            loading
                ? const SizedBox(
                  width: AppSizes.iconSM,
                  height: AppSizes.iconSM,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                : Icon(icon),
        label: Text(label),
      ),
    );
  }
}
