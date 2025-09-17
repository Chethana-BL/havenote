import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:havenote/data/auth/firebase_auth_repository.dart';
import 'package:havenote/domain/auth/i_auth_repository.dart';

// Provider for the authentication repository.
final authRepositoryProvider = Provider<IAuthRepository>(
  (ref) => FirebaseAuthRepository(FirebaseAuth.instance),
);

// Stream provider for the current authentication state (user or null).
final authStateProvider = StreamProvider<User?>(
  (ref) => ref.watch(authRepositoryProvider).idTokenChanges(),
);

// Stream provider for user changes (sign-in/out, profile updates, etc.).
final userChangesProvider = StreamProvider<User?>(
  (ref) => ref.watch(authRepositoryProvider).userChanges(),
);

// Convenience provider to get the current user (or null).
final currentUserProvider = Provider<User?>((ref) {
  final async = ref.watch(userChangesProvider);
  return async.asData?.value;
});
