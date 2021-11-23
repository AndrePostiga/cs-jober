import 'package:cloud_firestore/cloud_firestore.dart';

class UserLikedUser {
  String userLikedUserId;
  final String userId;

  UserLikedUser(this.userId, [this.userLikedUserId]);

  Map<String, dynamic> toMap() {
    return {"userId": userId};
  }

  factory UserLikedUser.fromSnapshot(QueryDocumentSnapshot doc) {
    return UserLikedUser(doc["userId"], doc.id);
  }
}
