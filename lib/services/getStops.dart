import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hyperloop/data_models/stop.dart';

Future<List<Stop>> getStops() async {
  List<Stop> res = [];
  QuerySnapshot stopsSnapshot =
      await Firestore.instance.collection('stops').getDocuments();
  stopsSnapshot.documents.forEach((DocumentSnapshot document) {
    res.add(Stop(
      geoPoint: document['LatLong'],
      stopCode: document['stop_code'],
      stopName: document['stop_name'],
    ));
  });

  return res;
}
