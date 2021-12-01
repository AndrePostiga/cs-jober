import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

class AppLocation {

  static Future<LocationData?> GetUserActualLocation() async {
    Location location = Location();

    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    PermissionStatus _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    return await location.getLocation();
  }

  static Future UpdateUserLatLong(String? FirebaseAuthUid) async {
    if (FirebaseAuthUid == null){
      return;
    }

    var location = await AppLocation.GetUserActualLocation();
    final snapshot = await FirebaseFirestore.instance
        .collection("stores")
        .where("firebaseAuthUid", isEqualTo: FirebaseAuthUid)
        .limit(1)
        .get()
        .then((userSnapshot) =>
        userSnapshot.docs[0].reference.update({
          "lat": location?.latitude,
          "long": location?.longitude
        })
    );
  }
}