import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:havenote/app/constants/app_icons.dart';
import 'package:havenote/app/constants/app_sizes.dart';
import 'package:havenote/app/utils/dialogs.dart';
import 'package:havenote/core/logger.dart';
import 'package:havenote/features/auth/state/auth_providers.dart';
import 'package:havenote/features/auth/utils/auth_error_mapper.dart';
import 'package:havenote/l10n/app_localizations.dart';

class ProfileNameTile extends ConsumerStatefulWidget {
  const ProfileNameTile({super.key});

  @override
  ConsumerState<ProfileNameTile> createState() => _ProfileNameTileState();
}

class _ProfileNameTileState extends ConsumerState<ProfileNameTile> {
  final _displayNameCtrl = TextEditingController();
  bool _isSavingName = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    _displayNameCtrl.text = user?.displayName ?? '';
  }

  @override
  void dispose() {
    _displayNameCtrl.dispose();
    super.dispose();
  }

  String _initialFrom(User? u) {
    final dn = (u?.displayName ?? '').trim();
    if (dn.isNotEmpty) return dn.characters.first.toUpperCase();
    final em = (u?.email ?? '').trim();
    if (em.isNotEmpty) return em.characters.first.toUpperCase();
    return 'H';
  }

  Future<void> _save(User? user) async {
    final t = S.of(context);
    final newName = _displayNameCtrl.text.trim();
    final current = (user?.displayName ?? '').trim();

    if (newName == current) {
      Log.i('Settings: displayName unchanged');
      return;
    }

    setState(() => _isSavingName = true);
    try {
      await ref.read(authRepositoryProvider).updateDisplayName(newName);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.actionSaved)));
    } on FirebaseAuthException catch (e, st) {
      Log.w('Settings: displayName save failed', e, st);
      if (!mounted) return;
      await showAlert(
        context,
        title: t.errorGeneric,
        message: mapAuthError(e, t),
      );
    } catch (e, st) {
      Log.w('Settings: unexpected displayName save error', e, st);
      if (!mounted) return;
      await showAlert(context, title: t.errorGeneric, message: t.errorGeneric);
    } finally {
      if (mounted) setState(() => _isSavingName = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    final user = ref.watch(currentUserProvider);

    return Row(
      children: [
        CircleAvatar(
          radius: AppSizes.iconXL,
          child: Text(
            _initialFrom(user),
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.white),
          ),
        ),
        const SizedBox(width: AppSizes.space),
        Expanded(
          child: TextField(
            controller: _displayNameCtrl,
            decoration: InputDecoration(labelText: t.settingsDisplayName),
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.words,
            autofillHints: const [AutofillHints.name],
            onSubmitted: (_) => _save(user),
          ),
        ),
        const SizedBox(width: AppSizes.spaceSM),
        IconButton(
          tooltip: t.actionSave,
          onPressed: _isSavingName ? null : () => _save(user),
          icon:
              _isSavingName
                  ? const SizedBox(
                    width: AppSizes.iconSM,
                    height: AppSizes.iconSM,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : const Icon(AppIcons.check),
        ),
      ],
    );
  }
}
