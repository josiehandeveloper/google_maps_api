import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

List<Stop> modelUserFromJson(String str) =>
    List<Stop>.from(json.decode(str).map((x) => Stop.fromJson(x)));
String modelUserToJson(List<Stop> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Stop {
  int? id;
  double? lat;
  double? lon;
  String? name;

  Stop({
    this.id,
    this.name,
    this.lat,
    this.lon,
  });
  factory Stop.fromJson(Map<String, dynamic> json) => Stop(
        id: json["id"],
        name: json["name"],
        lat: json["lat"],
        lon: json["lon"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lat": lat,
        "lon": lon,
      };
}

Future<Stop> getGoogleOffices() async {
  const googleLocationsURL =
      'https://api.syncromatics.com/portal/stops?api-key=3c918bb53be24530243a3b1ef06b9f94c4067d7ad8edcc98e9257bf26cf8d3ea';

  // Retrieve the locations of Google offices
  try {
    final response = await http.get(Uri.parse(googleLocationsURL));
    if (response.statusCode == 200) {
      return Stop.fromJson(json.decode(response.body)[0]);
    }
  } catch (e) {
    print(e);
  }

  // Fallback for when the above HTTP request fails.
  return Stop.fromJson(
    json.decode(
      await rootBundle.loadString('assets/locations.json'),
    ),
  );
}
