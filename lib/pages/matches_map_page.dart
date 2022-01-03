import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:grupolaranja20212/utils/app_navigator.dart';
import 'package:grupolaranja20212/view_models/matches_map_view_model.dart';

class MatchesMapPage extends StatefulWidget {
  const MatchesMapPage({Key? key}) : super(key: key);

  @override
  _MatchesMapPage createState() => _MatchesMapPage();
}

class _MatchesMapPage extends State<MatchesMapPage> {
  /*final MatchesMapViewModel _vM = MatchesMapViewModel();
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
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FlutterMap(
      options: MapOptions(
        center: latLng.LatLng(-22.9041, -43.1327),
        zoom: 13.0,
      ),
      layers: [
        TileLayerOptions(
          urlTemplate:
              "https://api.mapbox.com/styles/v1/gustavocm/ckxsf043a2or315pe4aq6x3qd/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZ3VzdGF2b2NtIiwiYSI6ImNreHNleDRiYTVhbm0yd3E5c3RtOXZobmgifQ.j6aqVZQh7XisoDs8yP6JLw",
          additionalOptions: {
            'accessToken':
                'pk.eyJ1IjoiZ3VzdGF2b2NtIiwiYSI6ImNreHNleDRiYTVhbm0yd3E5c3RtOXZobmgifQ.j6aqVZQh7XisoDs8yP6JLw',
            'id': 'mapbox.mapbox-streets-v8'
          },
          attributionBuilder: (_) {
            return Text("© OpenStreetMap contributors");
          },
        ),
        MarkerLayerOptions(
          markers: [
            Marker(
              width: 50.0,
              height: 50.0,
              point: latLng.LatLng(-22.9041, -43.1327),
              builder: (ctx) => Container(
                child: Image.asset(
                  "images/pin.png",
                ),
              ),
            )
          ],
        ),
      ],
    ));
  }
}
