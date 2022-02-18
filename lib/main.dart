import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'stops.dart' as stops;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices = await stops.getGoogleOffices();
    // print(json.decode(googleOffices));

    setState(() {
      _markers.clear();
      final marker = Marker(
          markerId: MarkerId(googleOffices.name!),
          position: LatLng(googleOffices.lat!, googleOffices.lon!),
          infoWindow: InfoWindow(title: googleOffices.name!));
      _markers[googleOffices.name!] = marker;
    });

    // for (final office in googleOffices) {
    //   final marker = Marker(
    //     markerId: MarkerId(office.name!),
    //     position: LatLng(office.lat!, office.lon!),
    //     infoWindow: InfoWindow(
    //       title: office.name,
    //     ),
    //   );
    //   _markers[office.name!] = marker;
    // }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Stops'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(
            target: LatLng(0, 0),
            zoom: 2,
          ),
          markers: _markers.values.toSet(),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// import 'dart:convert';
// import 'dart:core';
// import 'package:http/http.dart' as http;

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return DataFromAPI();
//   }
// }

// class DataFromAPI extends StatefulWidget {
//   @override
//   _DataFromAPIState createState() => _DataFromAPIState();
// }

// class _DataFromAPIState extends State<DataFromAPI> {
//   getUserData() async {
//     var response = await http.get(Uri.parse(
//         'https://api.syncromatics.com/portal/stops?api-key=3c918bb53be24530243a3b1ef06b9f94c4067d7ad8edcc98e9257bf26cf8d3ea'));
//     var jsonData = jsonDecode(response.body);
//     List<Stop> stops = [];

//     for (var i in jsonData) {
//       Stop stop = Stop(i['name'] ?? "");
//       stops.add(stop);
//     }
//     return stops;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: FutureBuilder(
//         future: getUserData(),
//         builder: (context, AsyncSnapshot snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(
//               child: Text('Loading'),
//             );
//           } else {
//             return ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: snapshot.data.length,
//                 itemBuilder: (context, i) {
//                   return Card(
//                       child: ListTile(
//                     title: Text(snapshot.data[i].name),
//                   ));
//                 });
//           }
//         },
//       ),
//     );
//   }
// }

// class Stop {
//   String name;

//   Stop(this.name);
// }
