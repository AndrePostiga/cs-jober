import 'package:cloud_firestore/cloud_firestore.dart';

class UserLikedUser {
  String userLikedUser;
  final String userId;

  UserLikedUser(this.userId, [this.userLikedUser]);

  Map<String, dynamic> toMap() {
    return {"userId": userId};
  }

  factory UserLikedUser.fromSnapshot(QueryDocumentSnapshot doc) {
    return UserLikedUser(doc["userId"], doc.id);
  }
}
