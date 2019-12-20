import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Coordinates extends Equatable {
  final String lat;
  final String lon;

  Coordinates({@required this.lat, @required this.lon});

  double get latitude => double.parse(lat);

  double get longitude => double.parse(lon);

  Coordinates.from(Coordinates location)
      : lat = location.lat,
        lon = location.lon;

  Coordinates.fromJson(Map<String, dynamic> map)
      : lat = map['lat'],
        lon = map['lon'];

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lon': lon,
      };

  @override
  String toString() {
    return "{'lat':'$lat,'lon':$lon}";
  }

  @override
  List<Object> get props => [lat, lon];
}
