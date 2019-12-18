class Place {
  String name;
  String address;
  double lat;
  double lng;
  Place(this.name, this.address, this.lat, this.lng);

  static List<Place> fromJson(Map<String, dynamic> json) {
    print("parsing data");
    List<Place> rs = List();

    var results = json['results'] as List;
    for (var item in results) {
      var p = Place(item['name'], item['formatted_address'], item['geometry']['location']['lat'], item['geometry']['location']['lng']);

      rs.add(p);

    }
    return rs;
  }
}