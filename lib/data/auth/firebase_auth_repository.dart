import 'package:firebase_auth/firebase_auth.dart';
import 'package:havenote/domain/auth/i_auth_repository.dart';

class FirebaseAuthRepository implements IAuthRepository {
  FirebaseAuthRepository(this._auth);
  final FirebaseAuth _auth;

  @override
  Stream<User?> idTokenChanges() => _auth.idTokenChanges();

  @override
  Stream<User?> userChanges() => _auth.userChanges();

  @override
  Future<void> signInWithEmail(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> registerWithEmail(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> sendEmailVerification({ActionCodeSettings? settings}) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await user.sendEmailVerification(settings);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> reloadCurrentUser() async {
    await _auth.currentUser?.reload();
  }

  @override
  Future<bool> refreshEmailVerification() async {
    await _auth.currentUser?.reload();
    final verified = _auth.currentUser?.emailVerified ?? false;

    // Force token refresh so routers listening to idTokenChanges get updated.
    if (verified) {
      await _auth.currentUser?.getIdToken(true);
    }

    return verified;
  }

  @override
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) return;
    await user.delete();
  }

  @override
  Future<void> reauthenticateWithEmail(String email, String password) async {
    final user = _auth.currentUser;
    if (user == null) return;
    final cred = EmailAuthProvider.credential(email: email, password: password);
    await user.reauthenticateWithCredential(cred);
  }

  @override
  Future<void> signOut() => _auth.signOut();
}
