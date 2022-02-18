import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'stops.dart' as stops;
import 'package:location/location.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Location _location = Location();
  //holding markers
  final Map<String, Marker> _markers = {};


  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices = await stops.getGoogleOffices();
    // print(json.decode(googleOffices));

    setState(() {
      _markers.clear();

      for (final office in googleOffices) {
        final marker = Marker(
          markerId: MarkerId(office.name!),
          position: LatLng(office.lat!, office.lon!),
          infoWindow: InfoWindow(
            title: office.name,
          ),
        );
        _markers[office.name!] = marker;
      }
    });
    
  }
  
void _currentLocation() async {
   final GoogleMapController controller = await _controller.future;
   LocationData currentLocation;
   var location = new Location();
   try {
     currentLocation = await location.getLocation();
     } on Exception {
       currentLocation = null;
       }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Stops'),
          backgroundColor: const Color(0xff07205d),
        ),
        body: GoogleMap(
          myLocationEnabled: true,
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(
            target: LatLng(34.04182511218627, -118.70944815041058),
            zoom: 14,
          ),
          markers: _markers.values.toSet(),
        ),
      ),
    );
  }
}
