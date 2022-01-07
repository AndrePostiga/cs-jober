import 'package:grupolaranja20212/services/user_service.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class PushNotificationService {
  static const _appId = "6e064919-a3ca-4f23-a88a-275b5594d4e8";

  String getAppId() {
    return _appId;
  }

  Future logout(String firebaseAuthUserUid) async {
    await OneSignal.shared.removeExternalUserId();
    await UserService().updateUserOneSignalId(firebaseAuthUserUid, "");
  }

  Future loginUser(String firebaseAuthUserUid) async {
    await OneSignal.shared.setExternalUserId(firebaseAuthUserUid);
    var state = await OneSignal.shared.getDeviceState();

    if (state != null) {
      await UserService()
          .updateUserOneSignalId(firebaseAuthUserUid, state.userId ?? "");
    }
  }

  Future sendNotification(List<String> receptorsOneSignalids, String msg,
      String? head, String? link, Map<String, dynamic>? data) async {
    var notification = OSCreateNotification(
        content: msg,
        playerIds: receptorsOneSignalids,
        heading: head,
        url: link,
        additionalData: data);

    await OneSignal.shared.postNotification(notification);
  }
}
