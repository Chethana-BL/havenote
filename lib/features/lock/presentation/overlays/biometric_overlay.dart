import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:havenote/app/constants/app_icons.dart';
import 'package:havenote/app/constants/app_sizes.dart';
import 'package:havenote/features/lock/state/lock_controller.dart';
import 'package:havenote/l10n/app_localizations.dart';

class BiometricOverlay extends ConsumerWidget {
  const BiometricOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO(ux): Provide a "Sign out" button when only biometrics are enabled to avoid user lockout loops.
    final t = S.of(context);
    final ctl = ref.read(lockControllerProvider.notifier);
    final lock = ref.watch(lockControllerProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(AppIcons.lock, size: AppSizes.iconXL),
        const SizedBox(height: AppSizes.space),
        Text(t.lockTitle, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSizes.spaceSM),
        Text(t.lockSubtitleBiometric),
        const SizedBox(height: AppSizes.space),
        FilledButton.icon(
          onPressed:
              () => ctl.authenticate(prompt: S.of(context).lockBiometricPrompt),
          icon: const Icon(AppIcons.fingerprint),
          label: Text(t.lockButtonUnlock),
        ),

        if (lock.pinEnabled) ...[
          /// Display the Pin Entry option if Pin Unlock is available
          const SizedBox(height: AppSizes.spaceSM),
          TextButton.icon(
            onPressed: () => ctl.showPinOverlay(),
            icon: const Icon(AppIcons.pin),
            label: Text(t.lockButtonUsePin),
          ),
        ],
      ],
    );
  }
}
