import 'package:flutter/material.dart';
import 'package:havenote/app/constants/app_sizes.dart';
import 'package:havenote/features/settings/presentation/widgets/account_actions.dart';
import 'package:havenote/features/settings/presentation/widgets/profile_name_tile.dart';
import 'package:havenote/features/settings/presentation/widgets/theme_mode_tile.dart';
import 'package:havenote/l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(t.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.padding),
        children: const [
          ProfileNameTile(),
          SizedBox(height: AppSizes.spaceLG),
          Divider(),
          ThemeModeTile(),
          Divider(),
          AccountActions(),
          Divider(),
        ],
      ),
    );
  }
}
