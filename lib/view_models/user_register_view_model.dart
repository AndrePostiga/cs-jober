import 'dart:io';
import 'package:flutter/material.dart';
import 'package:grupolaranja20212/services/push_notification_service.dart';
import 'package:grupolaranja20212/utils/constants.dart';
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
    String downloadURL = Constants.userDefaultPhoto;

    // usando uuid pra gerar identificador unico pra img
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
      List<String> skills,
      String birthDate) async {
    var user = await UserService().createOrUpdateUserByFirebaseAuthUid(
        firebaseAuthUid,
        name,
        linkedinUrl,
        photoUrl,
        typeId,
        description,
        maxSearchDistance,
        skills,
        birthDate);

    await UserService().updateUserLatLong(firebaseAuthUid);

    PushNotificationService().loginUser(firebaseAuthUid);

    return user;
  }
}
