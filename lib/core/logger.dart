import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';

/// Simple logging utility.
/// - Debug builds: logs d/i/w/e to `dart:developer`.
/// - Release builds: suppressed by default, allow `e()` and `w()` by flipping the toggles below.
class Log {
  /// Allow `e()` to log in release builds too. Flip this in `main()`
  static bool logErrorsInRelease = false;

  /// Allow `w()` to log in release builds too. Flip this in `main()`
  static bool logWarningsInRelease = false;

  static void d(String message) {
    if (kDebugMode) dev.log(message, level: 500, name: 'DEBUG');
  }

  static void i(String message) {
    if (kDebugMode) dev.log(message, level: 800, name: 'INFO');
  }

  static void w(String message, [Object? error, StackTrace? st]) {
    if (kDebugMode || logWarningsInRelease) {
      dev.log(message, level: 900, name: 'WARN', error: error, stackTrace: st);
    }
  }

  static void e(String message, [Object? error, StackTrace? st]) {
    if (kDebugMode || logErrorsInRelease) {
      dev.log(
        message,
        level: 1000,
        name: 'ERROR',
        error: error,
        stackTrace: st,
      );
    }
  }
}
