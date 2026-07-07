/// Simple model representing the user data we store in Firestore.
class UserModel {
  final String uid;
  final String name;
  final String email;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
  });

  /// Convert to a map for writing to Firestore.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  /// Build a UserModel from a Firestore document snapshot's data.
  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    return UserModel(
      uid: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
    );
  }
}
