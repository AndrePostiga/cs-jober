class PushNotificationService {
  static const _appId = "6e064919-a3ca-4f23-a88a-275b5594d4e8";

  String getAppId() {
    return _appId;
  }

  Future sendNotification(List<String> receptorsFirebaseUids, String msg,
      String? head, String? link, dynamic data) async {
    // constructing json based on https://documentation.onesignal.com/reference/create-notification
    Map<String, dynamic> json = {};
    json["app_id"] = _appId;
    json["include_external_user_ids"] = receptorsFirebaseUids;
    json["contents"] = {"en": msg};

    if (head != null) {
      json["headings"] = {"en": head};
    }

    if (link != null) {
      json["url"] = link;
    }

    if (data != null) {
      json["data"] = data;
    }

    // await OneSignal.shared.postNotificationWithJson(json);
  }
}
