import 'package:equatable/equatable.dart';

class Place extends Equatable {
  final String name;
  final String address;
  final double lat;
  final double lon;

  Place({this.name, this.address, this.lat, this.lon});

  factory Place.fromJson(Map<String, dynamic> json) => Place(
      name: json["name"],
      address: json["address"],
      lat: json["lat"],
      lon: json["lon"]);

  Map<String, dynamic> toJson() => {
        'name': name,
        'address': address,
        'lat': lat.toString(),
        'lon': lon.toString()
      };

  @override
  String toString() {
    return "{'name':$name,'address':$address,'lat':$lat,'lon':$lon}";
  }

  @override
  List<Object> get props => [name, address, lat, lon];
}
