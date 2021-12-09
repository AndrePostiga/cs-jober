import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:grupolaranja20212/models/user.dart';
import 'package:grupolaranja20212/models/user_type.dart';
import 'package:grupolaranja20212/services/user_service.dart';

class UserRegisterViewModel extends ChangeNotifier {
  Future<List<UserType>> getUserTypes() async {
    return await UserService().getUserTypes();
  }

  Future<User?> getUserByFirebaseAuthUid(String firebaseAuthUid) async {
    return await UserService().getUserByFirebaseAuthUid(firebaseAuthUid);
  }

  Future<String> uploadPhoto(File file) async {
    String downloadURL =
        "https://firebasestorage.googleapis.com/v0/b/jober-7722a.appspot.com/o/images%2Favatar.png?alt=media&token=0b1f609f-071d-47f1-a4c3-881971b54d67";

    const uuid = Uuid();
    final filePath = "/images/${uuid.v4()}.jpg";
    final storage = FirebaseStorage.instance.ref(filePath);
    final uploadTask = await storage.putFile(file);

    if (uploadTask.state == TaskState.success) {
      downloadURL =
          await FirebaseStorage.instance.ref(filePath).getDownloadURL();
    }

    return downloadURL;
  }

  Future<User> createOrUpdateUserByFirebaseAuthUid(
      String firebaseAuthUid,
      String name,
      String linkedinUrl,
      String photoUrl,
      int typeId,
      String description,
      int maxSearchDistance,
      List<String> skills) async {
    return await UserService().createOrUpdateUserByFirebaseAuthUid(
        firebaseAuthUid,
        name,
        linkedinUrl,
        photoUrl,
        typeId,
        description,
        maxSearchDistance,
        skills);
  }
}
