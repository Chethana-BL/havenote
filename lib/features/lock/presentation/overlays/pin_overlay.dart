import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:havenote/app/constants/app_icons.dart';
import 'package:havenote/app/constants/app_sizes.dart';
import 'package:havenote/features/lock/presentation/overlays/pin_pad.dart';
import 'package:havenote/features/lock/state/lock_controller.dart';
import 'package:havenote/l10n/app_localizations.dart';

/// Overlay widget for entering and verifying a PIN code.
class PinOverlay extends ConsumerStatefulWidget {
  const PinOverlay({super.key});
  @override
  ConsumerState<PinOverlay> createState() => _PinOverlayState();
}

class _PinOverlayState extends ConsumerState<PinOverlay> {
  final _buf = StringBuffer();
  String? _error;

  Future<void> _tapDigit(String d) async {
    if (_buf.length >= 6) return;
    setState(() {
      _error = null;
      _buf.write(d);
    });
    await HapticFeedback.selectionClick();
  }

  Future<void> _backspace() async {
    if (_buf.isEmpty) return;
    setState(() {
      _error = null;
      final s = _buf.toString();
      _buf
        ..clear()
        ..write(s.substring(0, s.length - 1));
    });
    await HapticFeedback.selectionClick();
  }

  Future<void> _submit() async {
    final t = S.of(context);
    if (_buf.length < 4) {
      setState(() => _error = t.pinErrorMinDigits);
      return;
    }
    final ok = await ref
        .read(lockControllerProvider.notifier)
        .verifyPin(_buf.toString());
    if (!ok) {
      setState(() {
        _error = t.pinErrorIncorrect;
        _buf.clear();
      });
      await HapticFeedback.vibrate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    final lock = ref.watch(lockControllerProvider);

    final dots = List.generate(6, (i) {
      final filled = i < _buf.length;
      return Container(
        width: 10,
        height: 10,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              filled ? Theme.of(context).colorScheme.primary : Colors.black26,
        ),
      );
    });

    final canUseBiometric = lock.biometricEnabled && lock.biometricsAvailable;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(AppIcons.lock, size: AppSizes.iconXL),
        const SizedBox(height: AppSizes.space),
        Text(t.pinTitle, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSizes.spaceSM),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: dots),
        if (_error != null) ...[
          const SizedBox(height: AppSizes.spaceSM),
          Text(
            _error!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
        const SizedBox(height: AppSizes.space),
        PinPad(onDigit: _tapDigit, onBackspace: _backspace, onSubmit: _submit),
        const SizedBox(height: AppSizes.spaceSM),
        if (canUseBiometric)
          TextButton.icon(
            onPressed:
                () => ref.read(lockControllerProvider.notifier).authenticate(),
            icon: const Icon(AppIcons.fingerprint),
            label: Text(t.lockButtonUseBiometrics),
          ),
      ],
    );
  }
}
