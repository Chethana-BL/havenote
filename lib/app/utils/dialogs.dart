import 'package:flutter/material.dart';
import 'package:havenote/l10n/app_localizations.dart';

Future<void> showAlert(
  BuildContext context, {
  required String title,
  required String message,
  String? okText,
}) {
  final t = S.of(context);

  return showDialog<void>(
    context: context,
    builder:
        (dCtx) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dCtx).pop(),
              child: Text(okText ?? t.actionOk),
            ),
          ],
        ),
  );
}

Future<bool?> showConfirm(
  BuildContext context, {
  required String title,
  required String message,
  String? cancelText,
  String? confirmText,
  IconData? confirmIcon,
  Color? confirmColor,
}) {
  final theme = Theme.of(context);
  final t = S.of(context);

  return showDialog<bool>(
    context: context,
    builder:
        (dCtx) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dCtx).pop(false),
              child: Text(cancelText ?? t.actionCancel),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.of(dCtx).pop(true),
              icon: Icon(confirmIcon ?? Icons.check),
              label: Text(confirmText ?? t.actionOk),
              style: FilledButton.styleFrom(
                backgroundColor: confirmColor ?? theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
              ),
            ),
          ],
        ),
  );
}
