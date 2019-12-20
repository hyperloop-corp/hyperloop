import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hyperloop/data/models/user_model.dart';
import 'package:hyperloop/data/store/firebase/firebase_store.dart';
import 'package:hyperloop/data/store/user_store.dart';

class FirebaseUserStore extends FirebaseStore implements UserStore {
  final UserModel user;
  final Firestore store;

  FirebaseUserStore({this.user, this.store});

  @override
  Stream<UserDataModel> get userData {
    final CollectionReference userCollection =
        Firestore.instance.collection('users');
    return userCollection
        .document(user.uid)
        .snapshots()
        .map(_userDataFromSnapshot);
  }

  Future<void> updateUserData(String firstName, String lastName, String email,
      String phone, String latitude, String longitude) async {
    final CollectionReference userCollection =
        Firestore.instance.collection('users');
    return await userCollection.document(user.uid).setData({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'latitude': latitude,
      'longitude': longitude
    });
  }

  UserDataModel _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserDataModel(
      uid: snapshot.documentID,
      firstName: snapshot.data['firstName'],
      lastName: snapshot.data['lastName'],
      email: snapshot.data['email'],
      phone: snapshot.data['phone'],
      latitude: snapshot.data['latitude'],
      longitude: snapshot.data['longitude'],
    );
  }
}
