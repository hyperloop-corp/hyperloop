import 'package:flutter/cupertino.dart';
import 'package:hyperloop/domain/entities/location.dart';

class LocationModel extends Location {
  LocationModel(
      {@required String lat,
      @required String lon,
      @required String timestamp,
      @required double speed})
      : super(lat, lon, timestamp, speed);

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
        lat: json['lat'],
        lon: json['lon'],
        timestamp: json['timestamp'],
        speed: (json['speed'] as num).toDouble());
  }

  Map<String, dynamic> toJson() =>
      {'lat': lat, 'lon': lon, 'timestamp': timestamp, 'speed': speed};
}
