import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:havenote/app/constants/app_icons.dart';
import 'package:havenote/app/constants/app_sizes.dart';
import 'package:havenote/app/router/routes.dart';
import 'package:havenote/app/utils/dialogs.dart';
import 'package:havenote/core/logger.dart';
import 'package:havenote/features/auth/state/auth_providers.dart';
import 'package:havenote/features/auth/utils/auth_error_mapper.dart';
import 'package:havenote/features/settings/presentation/widgets/theme_mode_tile.dart';
import 'package:havenote/l10n/app_localizations.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  Future<void> _confirmSignOut() async {
    final t = S.of(context);

    final ok = await showConfirm(
      context,
      title: t.actionLogout,
      message: t.settingsSignOutConfirmBody,
      confirmText: t.actionLogout,
      confirmIcon: AppIcons.logout,
    );
    if (ok != true) return;

    Log.i('Settings: sign-out confirmed');
    await ref.read(authRepositoryProvider).signOut();
  }

  Future<void> _onDeleteAccountPressed() async {
    final ctx = context;
    final t = S.of(ctx);

    // Confirm delete
    final confirmed = await showConfirm(
      ctx,
      title: t.settingsDeleteConfirmTitle,
      message: t.settingsDeleteConfirmBody,
      confirmText: t.actionDelete,
      confirmIcon: AppIcons.deleteFilled,
    );
    if (confirmed != true) return;

    if (!ctx.mounted) return;

    // Always reauth first
    final ok = await ctx.push<bool>(AppRoute.reauth()) ?? false;
    if (!ok) return;

    // Then delete
    try {
      await ref.read(authRepositoryProvider).deleteAccount();
      Log.i('Settings: account deleted');
      if (!ctx.mounted) return;
      await showAlert(
        ctx,
        title: t.settingsDeleteAccount,
        message: t.settingsDeleteSuccess,
      );
      // Router guards will route to /auth after sign-out state
    } on FirebaseAuthException catch (e) {
      if (!ctx.mounted) return;
      Log.w('Settings: delete failed', e);
      await showAlert(ctx, title: t.errorGeneric, message: mapAuthError(e, t));
    } catch (e, st) {
      if (!ctx.mounted) return;
      Log.w('Settings: unexpected delete error', e, st);
      await showAlert(ctx, title: t.errorGeneric, message: t.errorGeneric);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(t.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.padding),
        children: [
          // Theme Mode
          const ThemeModeTile(),
          const Divider(),
          // Sign out (with confirmation)
          ListTile(
            leading: const Icon(AppIcons.logout),
            title: Text(t.actionLogout),
            onTap: _confirmSignOut,
          ),
          const Divider(),

          // Delete account (with confirmation)
          ListTile(
            leading: Icon(AppIcons.delete, color: cs.error),
            title: Text(t.settingsDeleteAccount),
            subtitle: Text(t.settingsDeleteAccountSubtitle),
            onTap: _onDeleteAccountPressed,
          ),
          const Divider(),
        ],
      ),
    );
  }
}
