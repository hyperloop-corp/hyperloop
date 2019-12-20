class RouteInfo {
  String name;
  int distance;
  String from;
  String to;
  int fare;
  int ETA;

  RouteInfo({this.name, this.distance, this.from, this.to, this.fare, this.ETA});

  String get getName{
    return name;
  }
}
