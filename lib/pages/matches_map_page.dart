import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grupolaranja20212/utils/app_navigator.dart';
import 'package:grupolaranja20212/view_models/matches_map_view_model.dart';

class MatchesMapPage extends StatefulWidget {
  const MatchesMapPage({Key? key}) : super(key: key);

  @override
  _MatchesMapPage createState() => _MatchesMapPage();
}

class _MatchesMapPage extends State<MatchesMapPage> {
  final MatchesMapViewModel _vM = MatchesMapViewModel();
  List<Marker> allMarkers = [];

  late GoogleMapController _controller;

  Future _initVars() async {
    var user = await _vM
        .getUserByFirebaseAuthUid(FirebaseAuth.instance.currentUser!.uid);

    setState(() {
      _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(user!.lat, user.long), zoom: 12.0),
      ));

      allMarkers.add(Marker(
          markerId: MarkerId(user.firebaseAuthUid),
          draggable: false,
          onTap: () {
            AppNavigator.navigateToProfilePage(context);
          },
          position: LatLng(user.lat, user.long)));
    });
  }

  void mapCreated(controller) async {
    setState(() {
      _controller = controller;
    });

    await _initVars();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
            initialCameraPosition:
                const CameraPosition(target: LatLng(0, 0), zoom: 12.0),
            markers: Set.from(allMarkers),
            onMapCreated: mapCreated,
          ),
        ),
      ),
    );
  }
}
