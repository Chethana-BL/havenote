import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kPrefThemeMode = 'theme_mode';

/// Holds and persists the app's ThemeMode using SharedPreferences.
/// Initializes to system, then updates when stored value loads.
class ThemeModeController extends StateNotifier<ThemeMode> {
  ThemeModeController({SharedPreferences? prefs})
    : _prefs = prefs,
      super(ThemeMode.system) {
    _load();
  }

  SharedPreferences? _prefs;

  Future<void> _ensurePrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> _load() async {
    await _ensurePrefs();
    final value = _prefs!.getString(_kPrefThemeMode);
    switch (value) {
      case 'light':
        state = ThemeMode.light;
        break;
      case 'dark':
        state = ThemeMode.dark;
        break;
      case 'system':
      default:
        state = ThemeMode.system;
    }
  }

  /// Sets and persists the selected theme mode.
  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    await _ensurePrefs();
    final str = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      _ => 'system',
    };
    await _prefs!.setString(_kPrefThemeMode, str);
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeController, ThemeMode>(
  (ref) => ThemeModeController(),
);
