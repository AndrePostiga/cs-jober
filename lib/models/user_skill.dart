import 'package:cloud_firestore/cloud_firestore.dart';

class UserSkill {
  String userSkillId;
  final String skill;

  UserSkill(this.skill, [this.userSkillId]);

  Map<String, dynamic> toMap() {
    return {"skill": skill};
  }

  factory UserSkill.fromSnapshot(QueryDocumentSnapshot doc) {
    return UserSkill(doc["skill"], doc.id);
  }
}
