import 'package:hyperloop/data/models/user_model.dart';

abstract class UserStore {
  Future<void> updateUserData(String firstName, String lastName, String email,
      String phone, String latitude, String longitude);

  Stream<UserDataModel> get userData;
}
