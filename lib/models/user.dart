import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String firebaseAuthUid;
  final String oneSignalId;
  final String name;
  final String linkedinUrl;
  final String photoUrl;
  final String description;
  final int typeId;
  final double lat;
  final double long;
  final int maxSearchDistance;
  final List<String> skills;
  final List<String> likes;
  final List<String> unlikes;

  DocumentReference? reference;

  User(
      this.firebaseAuthUid,
      this.oneSignalId,
      this.name,
      this.linkedinUrl,
      this.photoUrl,
      this.typeId,
      this.description,
      this.lat,
      this.long,
      this.maxSearchDistance,
      this.skills,
      this.likes,
      this.unlikes,
      [this.reference]);

  String? get userId {
    return reference?.id;
  }

  Map<String, dynamic> toMap() {
    return {
      "firebaseAuthUid": firebaseAuthUid,
      "oneSignalId": oneSignalId,
      "name": name,
      "linkedinUrl": linkedinUrl,
      "photoUrl": photoUrl,
      "description": description,
      "lat": lat,
      "long": long,
      "typeId": typeId,
      "maxSearchDistance": maxSearchDistance,
      "skills": skills,
      "likes": likes,
      "unlikes": unlikes
    };
  }

  factory User.fromSnapshot(QueryDocumentSnapshot doc) {
    return User(
        doc["firebaseAuthUid"],
        doc["oneSignalId"],
        doc["name"],
        doc["linkedinUrl"],
        doc["photoUrl"],
        doc["typeId"],
        doc["description"],
        doc["lat"],
        doc["long"],
        doc["maxSearchDistance"],
        doc["skills"],
        doc["likes"],
        doc["unlikes"],
        doc.reference);
  }
}
