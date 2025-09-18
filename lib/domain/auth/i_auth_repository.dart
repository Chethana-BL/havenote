import 'package:firebase_auth/firebase_auth.dart';

abstract class IAuthRepository {
  /// Emits the current [User] (or null) on sign-in/out and token refresh.
  Stream<User?> idTokenChanges();

  /// Emits the current [User] (or null) on sign-in/out and user profile changes
  /// (e.g., after [reload], display name updates, emailVerified flips).
  Stream<User?> userChanges();

  /// Email/password sign-in.
  Future<void> signInWithEmail(String email, String password);

  /// Email/password registration.
  Future<void> registerWithEmail(String email, String password);

  /// Sends a verification email to the current user.
  Future<void> sendEmailVerification({ActionCodeSettings? settings});

  /// Sends a password reset email.
  Future<void> sendPasswordResetEmail(String email);

  /// Reloads the current user (useful after verification).
  Future<void> reloadCurrentUser();

  /// Reloads and returns whether the current user's email is verified.
  /// Optionally triggers a token refresh for routers listening to idTokenChanges.
  Future<bool> refreshEmailVerification();

  /// Deletes the current user. Caller must ensure recent login (reauthenticate).
  Future<void> deleteAccount();

  /// Reauthenticates the current user (required before sensitive actions like delete).
  Future<void> reauthenticateWithEmail(String email, String password);

  /// Signs out the current user.
  Future<void> signOut();
}
