import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final String linkedinUrl;
  final String photoUrl;
  final String description;
  final int typeId;
  final double lat;
  final double long;
  final int maxSearchDistance;

  DocumentReference? reference;

  User(this.name, this.linkedinUrl, this.photoUrl, this.typeId,
      this.description, this.lat, this.long, this.maxSearchDistance,
      [this.reference]);

  String? get userId {
    return reference?.id;
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "linkedinUrl": linkedinUrl,
      "photoUrl": photoUrl,
      "description": description,
      "lat": lat,
      "long": long,
      "typeId": typeId,
      "maxSearchDistance": maxSearchDistance
    };
  }

  factory User.fromSnapshot(QueryDocumentSnapshot doc) {
    return User(
        doc["name"],
        doc["linkedinUrl"],
        doc["photoUrl"],
        doc["typeId"],
        doc["description"],
        doc["lat"],
        doc["long"],
        doc["maxSearchDistance"],
        doc.reference);
  }
}
