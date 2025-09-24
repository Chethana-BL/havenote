import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:havenote/app/constants/app_icons.dart';
import 'package:havenote/app/constants/app_sizes.dart';
import 'package:havenote/features/lock/state/lock_controller.dart';
import 'package:havenote/l10n/app_localizations.dart';

/// Settings tile: Biometric lock on/off.
class BiometricLockTile extends ConsumerWidget {
  const BiometricLockTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lock = ref.watch(lockControllerProvider);
    final ctl = ref.read(lockControllerProvider.notifier);
    final t = S.of(context);

    return ListTile(
      leading: const Icon(AppIcons.fingerprint),
      title: Text(t.settingsBiometricLock),
      subtitle: Text(
        lock.biometricEnabled ? t.settingsEnabled : t.settingsDisabled,
      ),
      trailing: Switch(
        value: lock.biometricEnabled,
        onChanged: ctl.setBiometricEnabled,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.padding,
        vertical: AppSizes.spaceSM,
      ),
    );
  }
}
