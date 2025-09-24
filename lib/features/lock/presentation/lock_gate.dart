import 'package:flutter/material.dart' hide LockState;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:havenote/app/constants/app_sizes.dart';
import 'package:havenote/features/lock/presentation/overlays/biometric_overlay.dart';
import 'package:havenote/features/lock/presentation/overlays/pin_overlay.dart';
import 'package:havenote/features/lock/state/lock_controller.dart';

/// Full-screen overlay that blocks interaction when locked.
/// Decides whether to show biometric or PIN UI based on [LockState].
class LockGate extends ConsumerWidget {
  const LockGate({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lock = ref.watch(lockControllerProvider);

    return Stack(
      children: [
        child,
        if (lock.locked) ...[
          const ModalBarrier(dismissible: false, color: Colors.black54),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                margin: const EdgeInsets.all(AppSizes.padding),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusLG),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.paddingLG),
                  child:
                      // Show PIN overlay if requested, otherwise show biometric overlay
                      lock.showPin
                          ? const PinOverlay()
                          : const BiometricOverlay(),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
