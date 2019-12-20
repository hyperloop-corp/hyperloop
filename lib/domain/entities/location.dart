import 'package:hyperloop/domain/entities/coordinates.dart';
import 'package:hyperloop/domain/utils/utils.dart';

class Location extends Coordinates {
  final String timestamp;
  final double speed;

  double get speedInMiles => speed * 2.237;

  @override
  Location(String lat, String lon, this.timestamp, this.speed)
      : super(lat: lat, lon: lon);

  Location.withoutTime(String lat, String lon, this.speed)
      : timestamp = Utils.newTimestamp,
        super(lat: lat, lon: lon);

  @override
  Location.fromLocation(Location location)
      : timestamp = location.timestamp,
        speed = location.speed,
        super(lat: location.lat, lon: location.lon);

  @override
  Location.fromJson(Map<String, dynamic> map)
      : timestamp = map['timestamp'],
        speed = map['speed'],
        super.fromJson({'lat': map['lat'], 'lon': map['lon']});

  @override
  Map<String, dynamic> toJson() =>
      {'lat': lat, 'lon': lon, 'timestamp': timestamp, 'speed': speed};

  Coordinates toCoordinates() => Coordinates(lat: lat, lon: lon);

  @override
  String toString() {
    return '{ lat: $lat, lon: $lon, timestamp: $timestamp, speed: $speed }';
  }
}
