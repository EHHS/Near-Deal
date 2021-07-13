import 'package:flutter/foundation.dart';

class Shop with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final String image_url;
  final String created_by;
  final String geohash;
  final String lat;
  final String lon;
  Shop(
      {@required this.id,
      @required this.name,
      @required this.description,
      @required this.image_url,
      @required this.created_by,
      @required this.geohash,
      @required this.lat,
      @required this.lon,
});

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        created_by: json["created_by"],
        geohash: json["geohash"],
        image_url: json["image_url"],
        lat: json["lat"],
        lon: json["lon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "created_by": created_by,
        "geohash": geohash,
        "image_url": image_url,
        "lat": lat,
        "lon": lon,
      };
}
