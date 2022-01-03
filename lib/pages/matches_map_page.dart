import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as lat_lng;

class MatchesMapPage extends StatefulWidget {
  const MatchesMapPage({Key? key}) : super(key: key);

  @override
  _MatchesMapPage createState() => _MatchesMapPage();
}

class _MatchesMapPage extends State<MatchesMapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FlutterMap(
      options: MapOptions(
        center: lat_lng.LatLng(-22.9041, -43.1327),
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
          markers: [
            Marker(
              width: 50.0,
              height: 50.0,
              point: lat_lng.LatLng(-22.9041, -43.1327),
              builder: (ctx) => Image.asset(
                "images/pin.png",
              ),
            )
          ],
        ),
      ],
    ));
  }
}
