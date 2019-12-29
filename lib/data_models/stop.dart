import 'package:cloud_firestore/cloud_firestore.dart';

class Stop {
  GeoPoint geoPoint;
  String stopCode;
  String stopName;

  Stop({this.geoPoint, this.stopCode, this.stopName});
}
