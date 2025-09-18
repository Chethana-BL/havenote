import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:havenote/app/theme/theme_mode_provider.dart';
import 'package:havenote/core/logger.dart';
import 'package:havenote/l10n/app_localizations.dart';

class ThemeModeTile extends ConsumerWidget {
  const ThemeModeTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = S.of(context);
    final themeMode = ref.watch(themeModeProvider);
    final themeCtl = ref.read(themeModeProvider.notifier);

    final subtitle = switch (themeMode) {
      ThemeMode.light => t.settingsThemeLight,
      ThemeMode.dark => t.settingsThemeDark,
      _ => t.settingsThemeSystem,
    };

    final segmented = SegmentedButton<ThemeMode>(
      segments: [
        ButtonSegment(
          value: ThemeMode.system,
          label: Text(t.settingsThemeSystem),
        ),
        ButtonSegment(
          value: ThemeMode.light,
          label: Text(t.settingsThemeLight),
        ),
        ButtonSegment(value: ThemeMode.dark, label: Text(t.settingsThemeDark)),
      ],
      selected: {themeMode},
      onSelectionChanged: (set) {
        Log.i('Settings: theme mode changed to $set');
        themeCtl.setMode(set.first);
      },
    );

    return ListTile(
      title: Text('${t.settingsTheme}: $subtitle'),
      subtitle: segmented,
    );
  }
}
