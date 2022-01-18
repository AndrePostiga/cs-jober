import 'package:grupolaranja20212/models/user.dart';
import 'package:grupolaranja20212/services/user_service.dart';

class ProfileViewModel {
  Future<User?> getUserByFirebaseAuthUid(String firebaseAuthUid) async {
    return await UserService().getUserByFirebaseAuthUid(firebaseAuthUid);
  }
}
