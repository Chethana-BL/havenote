import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:havenote/app/constants/app_icons.dart';
import 'package:havenote/app/constants/app_sizes.dart';
import 'package:havenote/features/lock/state/lock_controller.dart';
import 'package:havenote/l10n/app_localizations.dart';

// Settings tile: PIN lock on/off + set/change PIN dialog.
class PinLockTile extends ConsumerWidget {
  const PinLockTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lock = ref.watch(lockControllerProvider);
    final ctl = ref.read(lockControllerProvider.notifier);
    final t = S.of(context);

    return ListTile(
      leading: const Icon(AppIcons.lock),
      title: Text(t.settingsPinLock),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(lock.pinEnabled ? t.settingsEnabled : t.settingsDisabled),
          const SizedBox(height: AppSizes.spaceSM),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 360;
              final row = <Widget>[
                OutlinedButton.icon(
                  icon: const Icon(AppIcons.edit),
                  label: Text(t.pinDialogTitle),
                  onPressed: () => _showSetPinDialog(context, ref),
                ),
                const SizedBox(width: AppSizes.spaceSM),
                Text(
                  t.settingsPinHelper,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ];
              return isNarrow
                  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      row[0],
                      const SizedBox(height: AppSizes.spaceSM),
                      Row(children: row.sublist(1)),
                    ],
                  )
                  : Row(children: row);
            },
          ),
        ],
      ),
      trailing: Switch(value: lock.pinEnabled, onChanged: ctl.setPinEnabled),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.padding,
        vertical: AppSizes.spaceSM,
      ),
    );
  }

  Future<void> _showSetPinDialog(BuildContext context, WidgetRef ref) async {
    final ctl = ref.read(lockControllerProvider.notifier);
    final pin1 = TextEditingController();
    final pin2 = TextEditingController();
    final t = S.of(context);
    String? error;

    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            String? validate() {
              final a = pin1.text.trim();
              final b = pin2.text.trim();
              if (a.isEmpty || b.isEmpty) return t.pinErrorEnterConfirm;
              if (a.length < 4 || a.length > 6) return t.pinErrorLength;
              if (!RegExp(r'^\d+$').hasMatch(a)) return t.pinErrorDigitsOnly;
              if (a != b) return t.pinErrorMismatch;
              return null;
            }

            return AlertDialog(
              title: Text(t.pinDialogTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: pin1,
                    decoration: InputDecoration(labelText: t.pinFieldNew),
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                  ),
                  const SizedBox(height: AppSizes.spaceSM),
                  TextField(
                    controller: pin2,
                    decoration: InputDecoration(labelText: t.pinFieldConfirm),
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                  ),
                  if (error != null) ...[
                    const SizedBox(height: AppSizes.spaceSM),
                    Text(
                      error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(t.actionCancel),
                ),
                FilledButton.icon(
                  icon: const Icon(AppIcons.check),
                  label: Text(t.actionSave),
                  onPressed: () async {
                    final err = validate();
                    if (err != null) {
                      setState(() => error = err);
                      return;
                    }
                    await ctl.setPinValue(pin1.text.trim());
                    if (!ctx.mounted) return;
                    Navigator.of(ctx).pop();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(t.pinSaved)));
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
