import 'package:flutter/foundation.dart';
import 'package:hyperloop/domain/entities/coordinates.dart';

class CoordinatesModel extends Coordinates {
  CoordinatesModel({@required String lat, @required String lon})
      : super(lat: lat, lon: lon);

  factory CoordinatesModel.fromJson(Map<String, dynamic> json) {
    return CoordinatesModel(lat: json['lat'], lon: json['lon']);
  }

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lon': lon,
      };
}
