import 'package:flutter/cupertino.dart';
import 'package:hyperloop/domain/entities/place.dart';

class PlaceModel extends Place {
  PlaceModel(
      {@required String name,
      @required String address,
      @required double lat,
      @required double lon})
      : super(name: name, address: address, lat: lat, lon: lon);

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
        name: json['name'],
        address: json['address'],
        lat: json['lat'],
        lon: json['lon']);
  }

  Map<String, dynamic> toJson() =>
      {'name': name, 'address': address, 'lat': lat.toString(), 'lon': lon.toString()};
}
