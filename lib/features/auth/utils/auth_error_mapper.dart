import 'package:firebase_auth/firebase_auth.dart';
import 'package:havenote/core/logger.dart';
import 'package:havenote/l10n/app_localizations.dart';

String mapAuthError(Object error, S t) {
  if (error is! FirebaseAuthException) {
    Log.d('Auth error (non-Firebase): $error (${error.runtimeType})');
    return t.errorGeneric;
  }

  final code = error.code.toLowerCase();
  Log.w('FirebaseAuth error: code=$code');

  switch (code) {
    // Sign-in / Reauth common
    case 'invalid-credential':
    case 'invalid-login-credentials':
    case 'wrong-password':
    case 'user-not-found':
    case 'missing-password':
      return t.authErrorInvalidCredentials;

    // Email format / missing
    case 'invalid-email':
    case 'missing-email':
      return t.authErrorInvalidEmail;

    // Sign-up
    case 'email-already-in-use':
      return t.authErrorEmailInUse;
    case 'weak-password':
      return t.authErrorWeakPassword;
    case 'operation-not-allowed':
      return t.authErrorOperationNotAllowed;

    // Rate limiting / connectivity
    case 'too-many-requests':
    case 'quota-exceeded':
      return t.authErrorTooManyRequests;
    case 'network-request-failed':
      return t.authErrorNetworkRequestFailed;

    // Account state
    case 'user-disabled':
      return t.authErrorUserDisabled;

    // fallback / unknown
    case 'internal-error':
      return t.errorGeneric;

    default:
      return t.errorGeneric;
  }
}
