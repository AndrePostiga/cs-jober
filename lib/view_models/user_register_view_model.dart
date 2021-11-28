import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grupolaranja20212/models/user_type.dart';

class UserRegisterViewModel extends ChangeNotifier {
  Future<List<UserType>> getUserTypes() async {
    var querySnapShot =
        await FirebaseFirestore.instance.collection("user_types").get();

    return querySnapShot.docs.map((e) => UserType.fromSnapshot(e)).toList();
  }
}
