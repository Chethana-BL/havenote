import 'dart:async';

import 'package:flutter/material.dart' hide LockState;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:havenote/core/logger.dart';
import 'package:havenote/features/lock/state/lock_state.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLockBiometricEnabled = 'lock_enabled';
const _kLockPinEnabled = 'lock_pin_enabled';

// TODO(security): Namespace PIN per user, e.g. 'lock_pin_value_<uid>' to support multi-account devices.
const _kLockPinValue = 'lock_pin_value';

/// Controls lock state; tries biometrics first (if enabled & available), else PIN.
// TODO(security): PIN is stored in SharedPreferences, use secure storage + hashing in production.
class LockController extends StateNotifier<LockState>
    with WidgetsBindingObserver {
  LockController()
    : super(
        const LockState(
          biometricEnabled: false,
          pinEnabled: false,
          locked: false,
        ),
      ) {
    _init();
    WidgetsBinding.instance.addObserver(this);
  }

  final _auth = LocalAuthentication();
  bool _inProgress = false;
  bool _paused = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!(this.state.biometricEnabled || this.state.pinEnabled)) return;

    if (state == AppLifecycleState.paused) {
      _paused = true;
      this.state = this.state.copyWith(locked: true);
      Log.d('Lock: app paused → locked');
      return;
    }

    if (state == AppLifecycleState.resumed && _paused) {
      _paused = false;
      if (!_inProgress) {
        authenticate(); // prefer biometrics if available, else PIN
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // ---- Public API for UI ----

  Future<void> setBiometricEnabled(bool value) async {
    Log.i('Lock: biometrics ${value ? 'enabled' : 'disabled'}');

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLockBiometricEnabled, value);

    // Default: lock if any lock is enabled
    var locked = value || state.pinEnabled;
    var showPin = state.showPin;

    if (value) {
      // Turning biometrics on → hide PIN overlay and try biometric
      showPin = false;
      state = state.copyWith(
        biometricEnabled: true,
        locked: locked,
        showPin: showPin,
      );
      await authenticate(); // will prompt biometrics
      return;
    } else {
      // Turning biometrics off
      if (state.pinEnabled) {
        // Keep locked and show PIN overlay
        showPin = true;
      } else {
        // No locks left → unlock
        locked = false;
        showPin = false;
      }
    }

    state = state.copyWith(
      biometricEnabled: false,
      locked: locked,
      showPin: showPin,
    );
  }

  Future<void> setPinEnabled(bool value) async {
    Log.i('Lock: pin ${value ? 'enabled' : 'disabled'}');

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLockPinEnabled, value);

    // Base lock state: locked if either lock is enabled
    var locked = value || state.biometricEnabled;
    var showPin = state.showPin;

    if (value) {
      // If enabling PIN and biometrics are off or unavailable → show PIN UI
      final available =
          state.biometricsAvailable || await _checkBiometricsAvailable();
      if (!state.biometricEnabled || !available) {
        showPin = true;
      }
    } else {
      // Disabling PIN: if biometrics also off → unlock and hide PIN UI
      if (!state.biometricEnabled) {
        locked = false;
        showPin = false;
      }
    }

    state = state.copyWith(pinEnabled: value, locked: locked, showPin: showPin);
  }

  Future<void> setPinValue(String pin) async {
    // TODO(security): Store only a salted hash in secure storage (flutter_secure_storage).
    //  - Generate random salt per user
    //  - Derive key via PBKDF2/Argon2
    //  - Save {salt, hash}; never the raw PIN
    //  - Wipe on sign-out and account deletion
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLockPinValue, pin); // DEMO ONLY
  }

  /// Show PIN overlay directly (used by "Use PIN" button).
  void showPinOverlay() {
    if (!state.pinEnabled) return;
    state = state.copyWith(showPin: true, locked: true);
  }

  /// Entry point for unlock: tries biometrics if enabled & available, else shows PIN if enabled.
  Future<void> authenticate({String? prompt}) async {
    final available = await _checkBiometricsAvailable();
    state = state.copyWith(biometricsAvailable: available);

    if (state.biometricEnabled && available) {
      await _authenticateBiometric(prompt: prompt);
      return;
    }
    if (state.pinEnabled) {
      state = state.copyWith(showPin: true, locked: true);
      return;
    }
    state = state.copyWith(locked: false, showPin: false);
  }

  /// Verifies the PIN and unlocks on success.
  Future<bool> verifyPin(String input) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kLockPinValue);
    final ok = (saved != null && saved == input);
    if (ok) {
      state = state.copyWith(locked: false, showPin: false);
    } else {
      Log.w('Lock: PIN incorrect');
    }
    return ok;
  }

  /// From PIN UI: try biometrics if available & enabled.
  Future<void> tryBiometricFromPin() async {
    final available = await _checkBiometricsAvailable();
    if (!available || !state.biometricEnabled) return;
    await _authenticateBiometric();
  }

  // ---- Private ----

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final bio = prefs.getBool(_kLockBiometricEnabled) ?? false;
    final pin = prefs.getBool(_kLockPinEnabled) ?? false;
    final available = await _checkBiometricsAvailable();

    // Start locked if any lock is enabled.
    state = state.copyWith(
      biometricEnabled: bio,
      pinEnabled: pin,
      biometricsAvailable: available,
      locked: bio || pin,
      // Show PIN overlay if PIN is enabled and either biometrics are not enabled or not available.
      showPin: pin && (!bio || !available),
    );

    // If biometric is enabled and available, prompt once on startup.
    if (bio && available) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(_authenticateBiometric());
      });
    }
  }

  Future<bool> _checkBiometricsAvailable() async {
    try {
      final supported = await _auth.isDeviceSupported();
      if (!supported) return false;
      final kinds = await _auth.getAvailableBiometrics();
      return kinds.isNotEmpty; // enrolled and usable
    } catch (e) {
      Log.w('Lock: biometrics availability check failed', e as Object?);
      return false;
    }
  }

  Future<void> _authenticateBiometric({String? prompt}) async {
    // TODO(ux): Consider to allow Android device credentials fallback when app PIN is disabled.
    // AuthenticationOptions(biometricOnly: false, useErrorDialogs: true, stickyAuth: true)

    if (!state.biometricEnabled || _inProgress) return;
    _inProgress = true;
    try {
      final reason = prompt ?? 'Unlock Havenote'; // fallback literal
      final ok = await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(biometricOnly: true),
      );
      if (ok) {
        state = state.copyWith(locked: false, showPin: false);
      } else if (state.pinEnabled) {
        state = state.copyWith(locked: true, showPin: true);
      } else {
        state = state.copyWith(locked: true, showPin: false);
      }
    } catch (e, st) {
      Log.w('Lock: biometric auth failed', e, st);
      state = state.copyWith(locked: true, showPin: state.pinEnabled);
    } finally {
      _inProgress = false;
    }
  }

  Future<void> clearPersistentLockData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kLockBiometricEnabled);
    await prefs.remove(_kLockPinEnabled);
    await prefs.remove(_kLockPinValue); // replace with secure storage key later

    state = const LockState(
      biometricEnabled: false,
      pinEnabled: false,
      locked: false,
      biometricsAvailable: false,
      showPin: false,
    );
  }
}

final lockControllerProvider = StateNotifierProvider<LockController, LockState>(
  (ref) => LockController(),
);
