import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:grupolaranja20212/view_models/matches_map_view_model.dart';
import 'package:latlong2/latlong.dart' as lat_lng;

class MatchesMapPage extends StatefulWidget {
  const MatchesMapPage({Key? key}) : super(key: key);

  @override
  _MatchesMapPage createState() => _MatchesMapPage();
}

class _MatchesMapPage extends State<MatchesMapPage> {
  late final MatchesMapViewModel _vm = MatchesMapViewModel();
  late List<Marker> _markers = <Marker>[];
  late Widget _pageContent;
  late lat_lng.LatLng _centerOfMap = lat_lng.LatLng(-22.9041, -43.1327);

  Future _initVars() async {
    var users =
        await _vm.getMatchesUsers(FirebaseAuth.instance.currentUser!.uid);

    var newMarkers = <Marker>[];

    for (var user in users) {
      newMarkers.add(Marker(
        width: 50.0,
        height: 50.0,
        point: lat_lng.LatLng(user.lat, user.long),
        builder: (ctx) => Image.network(user.photoUrl),
      ));
    }

    var user = await _vm
        .getUserByFirebaseAuthUid(FirebaseAuth.instance.currentUser!.uid);

    var newCenter = lat_lng.LatLng(user!.lat, user.long);

    setState(() {
      _centerOfMap = newCenter;
      _markers = newMarkers;
      _pageContent = _makeMap();
    });
  }

  @override
  void initState() {
    _pageContent = _waitPage();
    super.initState();
    _initVars();
  }

  Widget _waitPage() {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: const Text(
        "Aguarde... Carregando...",
        style: TextStyle(fontSize: 50),
      ),
    );
  }

  Widget _makeMap() {
    return FlutterMap(
      options: MapOptions(
        center: _centerOfMap,
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
            return const Text("© OpenStreetMap contributors");
          },
        ),
        MarkerLayerOptions(
          markers: _markers,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _pageContent;
  }
}
