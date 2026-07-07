import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

/// Wraps all Cloud Firestore reads/writes for user profile data.
///
/// Data shape in Firestore:
///   collection: "users"
///     document id: <uid>
///       { name: "...", email: "...", createdAt: "..." }
class FirestoreService {
  final CollectionReference<Map<String, dynamic>> _usersRef =
      FirebaseFirestore.instance.collection('users');

  /// Saves (or overwrites) the given user's profile document.
  Future<void> saveUserData(UserModel user) async {
    await _usersRef.doc(user.uid).set(user.toMap());
  }

  /// Fetches a single user's profile document once.
  Future<UserModel?> getUserData(String uid) async {
    final doc = await _usersRef.doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    return UserModel.fromMap(uid, doc.data()!);
  }

  /// Live stream of a user's profile document — use this if you want
  /// the UI to update instantly when the Firestore data changes.
  Stream<UserModel?> streamUserData(String uid) {
    return _usersRef.doc(uid).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return UserModel.fromMap(uid, doc.data()!);
    });
  }
}
