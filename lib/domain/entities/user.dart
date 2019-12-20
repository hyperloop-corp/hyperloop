import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class User extends Equatable {
  final String uid;

  User({@required this.uid});

  @override
  List<Object> get props => [uid];
}

class UserData extends Equatable {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String latitude;
  final String longitude;

  String get initials => '${firstName[0]}${lastName[0]}'.toUpperCase();

  String get fullName => '$firstName $lastName';

  UserData(
      {this.uid,
      this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.latitude,
      this.longitude});

  UserData.fromUser(UserData userData)
      : uid = userData.uid,
        firstName = userData.firstName,
        lastName = userData.lastName,
        email = userData.email,
        phone = userData.phone,
        latitude = userData.latitude,
        longitude = userData.longitude;

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'latitude': latitude,
        'longitude': longitude
      };

  @override
  String toString() {
    return "{'uid':$uid,'firstName':$firstName,'lastName':$lastName,'email':$email,'phone':$phone,'latitude':$latitude,'longitude':$longitude}";
  }

  @override
  List<Object> get props =>
      [firstName, lastName, uid, email, phone, latitude, longitude];
}
