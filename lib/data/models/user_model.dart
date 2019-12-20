import 'package:flutter/foundation.dart';
import 'package:hyperloop/domain/entities/user.dart';

class UserModel extends User {
  UserModel({@required String uid}) : super(uid: uid);
}

class UserDataModel extends UserData {
  UserDataModel(
      {@required String uid,
      @required String firstName,
      @required String lastName,
      @required String email,
      @required String phone,
      @required String latitude,
      @required String longitude})
      : super(
            uid: uid,
            firstName: firstName,
            lastName: lastName,
            email: email,
            phone: phone,
            latitude: latitude,
            longitude: longitude);

  factory UserDataModel.fromUser(UserData userData) {
    return UserDataModel(
        uid: userData.uid,
        firstName: userData.firstName,
        lastName: userData.lastName,
        email: userData.email,
        phone: userData.phone,
        latitude: userData.latitude,
        longitude: userData.longitude);
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'latitude': latitude,
        'longitude': longitude
      };
}
