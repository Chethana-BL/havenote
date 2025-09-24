import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:havenote/app/constants/app_icons.dart';
import 'package:havenote/app/router/routes.dart';
import 'package:havenote/app/utils/dialogs.dart';
import 'package:havenote/core/logger.dart';
import 'package:havenote/features/auth/state/auth_providers.dart';
import 'package:havenote/features/auth/utils/auth_error_mapper.dart';
import 'package:havenote/features/lock/state/lock_controller.dart';
import 'package:havenote/l10n/app_localizations.dart';

class AccountActions extends ConsumerWidget {
  const AccountActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = S.of(context);
    final cs = Theme.of(context).colorScheme;

    Future<void> confirmSignOut() async {
      final ok = await showConfirm(
        context,
        title: t.actionLogout,
        message: t.settingsSignOutConfirmBody,
        confirmText: t.actionLogout,
        confirmIcon: AppIcons.logout,
      );
      if (ok == true) {
        Log.i('Settings: sign-out confirmed');
        await ref.read(authRepositoryProvider).signOut();
        await ref
            .read(lockControllerProvider.notifier)
            .clearPersistentLockData();
      }
    }

    Future<void> deleteAccount() async {
      // Confirm delete
      final confirmed = await showConfirm(
        context,
        title: t.settingsDeleteConfirmTitle,
        message: t.settingsDeleteConfirmBody,
        confirmText: t.actionDelete,
        confirmIcon: AppIcons.deleteFilled,
      );
      if (confirmed != true || !context.mounted) return;

      final ok = await context.push<bool>(AppRoute.reauth()) ?? false;
      if (!ok) return;

      // Then delete
      try {
        await ref.read(authRepositoryProvider).deleteAccount();
        Log.i('Settings: account deleted');
        if (!context.mounted) return;
        await showAlert(
          context,
          title: t.settingsDeleteAccount,
          message: t.settingsDeleteSuccess,
        );
        // Router guards will route to /auth after sign-out state
      } on FirebaseAuthException catch (e) {
        if (!context.mounted) return;
        Log.w('Settings: delete failed', e);
        await showAlert(
          context,
          title: t.errorGeneric,
          message: mapAuthError(e, t),
        );
      } catch (e, st) {
        if (!context.mounted) return;
        Log.w('Settings: unexpected delete error', e, st);
        await showAlert(
          context,
          title: t.errorGeneric,
          message: t.errorGeneric,
        );
      }
    }

    return Column(
      children: [
        // Sign out (with confirmation)
        ListTile(
          leading: const Icon(AppIcons.logout),
          title: Text(t.actionLogout),
          onTap: confirmSignOut,
        ),
        const Divider(),
        // Delete account (with confirmation)
        ListTile(
          leading: Icon(AppIcons.delete, color: cs.error),
          title: Text(t.settingsDeleteAccount),
          subtitle: Text(t.settingsDeleteAccountSubtitle),
          onTap: deleteAccount,
        ),
      ],
    );
  }
}
