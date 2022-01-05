import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grupolaranja20212/models/user.dart';
import 'package:grupolaranja20212/models/user_type.dart';
import 'package:grupolaranja20212/utils/app_location.dart';

class UserService {
  Future<User?> getUserByFirebaseAuthUid(String firebaseAuthUid) async {
    var querySnapShot = await FirebaseFirestore.instance
        .collection("users")
        .where('firebaseAuthUid', isEqualTo: firebaseAuthUid)
        .get();

    var foundedUsers =
        querySnapShot.docs.map((e) => User.fromSnapshot(e)).toList();

    if (foundedUsers.isEmpty) {
      return null;
    }

    if (foundedUsers.length > 1) {
      throw Exception(
          "Foi encontrado mais de um usuário para o firebaseAuthUid informado: " +
              firebaseAuthUid);
    }

    return foundedUsers[0];
  }

  Future<User> updateUserLikesOrDislikes(
      String firebaseAuthUid,
      String? newLikedFirebaseAuthUid,
      String? newUnlikedFirebaseAuthUid) async {
    var oldUser = await getUserByFirebaseAuthUid(firebaseAuthUid);

    var needUpdate = false;

    if (!oldUser!.likes.contains(newLikedFirebaseAuthUid) &&
        !oldUser.unlikes.contains(newLikedFirebaseAuthUid) &&
        !oldUser.likes.contains(newUnlikedFirebaseAuthUid) &&
        !oldUser.unlikes.contains(newUnlikedFirebaseAuthUid)) {
      if (newLikedFirebaseAuthUid != null) {
        oldUser.likes.add(newLikedFirebaseAuthUid);
        needUpdate = true;
      }

      if (newUnlikedFirebaseAuthUid != null) {
        oldUser.unlikes.add(newUnlikedFirebaseAuthUid);
        needUpdate = true;
      }
    }

    if (needUpdate) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(oldUser.reference!.id)
          .update(oldUser.toMap());
    }

    return oldUser;
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
    var oldUser = await getUserByFirebaseAuthUid(firebaseAuthUid);

    if (oldUser == null) {
      var newUser = User(
          firebaseAuthUid,
          "",
          name,
          linkedinUrl,
          photoUrl,
          typeId,
          description,
          0,
          0,
          maxSearchDistance,
          skills,
          <String>[],
          <String>[],
          birthDate);

      await FirebaseFirestore.instance.collection("users").add(newUser.toMap());
    } else {
      oldUser.name = name;
      oldUser.linkedinUrl = linkedinUrl;
      oldUser.photoUrl = photoUrl;
      oldUser.typeId = typeId;
      oldUser.description = description;
      oldUser.maxSearchDistance = maxSearchDistance;
      oldUser.skills = skills;
      oldUser.birthDate = birthDate;

      await FirebaseFirestore.instance
          .collection("users")
          .doc(oldUser.reference!.id)
          .update(oldUser.toMap());
    }

    var storedUser = await getUserByFirebaseAuthUid(firebaseAuthUid);

    if (storedUser != null) {
      return storedUser;
    }

    throw Exception("Não foi possível gravar o usuário");
  }

  Future<List<UserType>> getUserTypes() async {
    var querySnapShot =
        await FirebaseFirestore.instance.collection("user_types").get();

    return querySnapShot.docs.map((e) => UserType.fromSnapshot(e)).toList();
  }

  Future<User?> updateUserLatLong(firebaseAuthUid) async {
    var location = await AppLocation.getUserActualLocation();

    var storedUser = await getUserByFirebaseAuthUid(firebaseAuthUid);

    if (storedUser != null) {
      storedUser.lat = location?.latitude ?? 0;
      storedUser.long = location?.longitude ?? 0;

      await FirebaseFirestore.instance
          .collection("users")
          .doc(storedUser.reference!.id)
          .update(storedUser.toMap());

      return await getUserByFirebaseAuthUid(firebaseAuthUid);
    }

    throw Exception("Usuário não encontrado");
  }
}
