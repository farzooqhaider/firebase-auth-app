import 'package:firebase_auth/firebase_auth.dart';

/// Wraps all Firebase Authentication calls in one place so the UI
/// screens stay clean and the logic is easy to test/reuse.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Currently signed-in user, or null if signed out.
  User? get currentUser => _auth.currentUser;

  /// Stream that fires whenever the auth state changes (login/logout).
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Creates a new account with email & password.
  /// Throws a [FirebaseAuthException] on failure (e.g. weak-password,
  /// email-already-in-use) which the UI layer catches and displays.
  Future<User?> signUp({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return credential.user;
  }

  /// Signs in an existing user with email & password.
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return credential.user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Converts Firebase's error codes into friendly messages.
  String mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'invalid-email':
        return 'That email address looks invalid.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      case 'user-not-found':
        return 'No account found for that email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return e.message ?? 'Something went wrong. Please try again.';
    }
  }
}
