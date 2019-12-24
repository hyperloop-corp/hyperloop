import 'package:hyperloop/data/models/user_model.dart';
import 'package:hyperloop/domain/entities/phone_auth_state.dart';

abstract class AuthStore {
  Stream<UserModel> onAuthStateChanged();

  Future<UserModel> signInWithEmailAndPassword(String email, String password);

  Future<UserModel> registerWithEmailAndPassword(String email, String password);

  Stream<PhoneAuthState> verifyPhoneNumber(String phoneNumber);

  Future<UserModel> signInWithPhoneNumber(String smsCode);

  Future<UserModel> signInWithGoogle();

  Future<void> signOut();

  Future<void> forgotPassword(String email);

  Future<UserModel> get user;
}
