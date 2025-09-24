import 'package:flutter/material.dart';
import 'package:havenote/app/constants/app_icons.dart';
import 'package:havenote/app/constants/app_sizes.dart';

/// A widget that displays a PIN pad overlay for user input.
///
/// This widget is typically used in authentication or lock screens,
/// allowing users to enter a numeric PIN code.
class PinPad extends StatelessWidget {
  const PinPad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
    required this.onSubmit,
  });
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final VoidCallback onSubmit;

  Widget _key(
    BuildContext context,
    String label, {
    VoidCallback? onTap,
    IconData? icon,
  }) {
    return SizedBox(
      width: 72,
      height: 56,
      child: OutlinedButton(
        onPressed: onTap ?? () => onDigit(label),
        child:
            icon != null
                ? Icon(icon)
                : Text(label, style: const TextStyle(fontSize: 18)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const g = SizedBox(width: AppSizes.spaceSM);
    const r = SizedBox(height: AppSizes.spaceSM);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _key(context, '1'),
            g,
            _key(context, '2'),
            g,
            _key(context, '3'),
          ],
        ),
        r,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _key(context, '4'),
            g,
            _key(context, '5'),
            g,
            _key(context, '6'),
          ],
        ),
        r,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _key(context, '7'),
            g,
            _key(context, '8'),
            g,
            _key(context, '9'),
          ],
        ),
        r,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _key(context, '⌫', onTap: onBackspace),
            g,
            _key(context, '0'),
            g,
            _key(context, '✓', onTap: onSubmit, icon: AppIcons.check),
          ],
        ),
      ],
    );
  }
}
