import 'package:cloud_firestore/cloud_firestore.dart';

class UserUnlikedUser {
  String userUnlikedUser;
  final String userId;

  UserUnlikedUser(this.userId, [this.userUnlikedUser]);

  Map<String, dynamic> toMap() {
    return {"userId": userId};
  }

  factory UserUnlikedUser.fromSnapshot(QueryDocumentSnapshot doc) {
    return UserUnlikedUser(doc["userId"], doc.id);
  }
}
