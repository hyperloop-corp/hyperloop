import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hyperloop/data/models/country_model.dart';
import 'package:hyperloop/data/store/country_store.dart';
import 'package:hyperloop/data/store/firebase/firebase_store.dart';

class FirebaseCountryStore extends FirebaseStore implements CountryStore {
  final Firestore store;

  FirebaseCountryStore({this.store});

  @override
  Stream<List<CountryModel>> get countries {
    final CollectionReference countryCollection =
        Firestore.instance.collection('country_phone_codes');

    return countryCollection.snapshots().map((snapshot) {
      return snapshot.documents.map(_countryFromSnapshot).toList();
    });
  }

  CountryModel _countryFromSnapshot(DocumentSnapshot snapshot) {
    return CountryModel(
        name: snapshot.data['name'],
        code: snapshot.data['code'],
        dialCode: snapshot.data['dial_code'],
        flag: snapshot.data['flag']);
  }
}
