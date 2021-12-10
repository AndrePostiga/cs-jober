import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String firebaseAuthUid;
  final String oneSignalId;
  late String name;
  late String linkedinUrl;
  late String photoUrl;
  late String description;
  late int typeId;
  late double lat;
  late double long;
  late int maxSearchDistance;
  late List<String> skills;
  final List<String> likes;
  final List<String> unlikes;
  late String birthDate;

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
      this.birthDate,
      [this.reference]);

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
      "unlikes": unlikes,
      "birthDate": birthDate
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
        doc["skills"].cast<String>(),
        doc["likes"].cast<String>(),
        doc["unlikes"].cast<String>(),
        doc["birthDate"],
        doc.reference);
  }
}
