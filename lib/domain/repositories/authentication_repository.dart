import 'package:dartz/dartz.dart';
import 'package:hyperloop/core/errors/failure.dart';
import 'package:hyperloop/domain/entities/phone_auth_state.dart';
import 'package:hyperloop/domain/entities/user.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, User>> signInWithEmailAndPassword(
      String email, String password);

  Future<Either<Failure, User>> registerWithEmailAndPassword(
      String email, String password);

  Future<Either<Failure, Stream<PhoneAuthState>>> verifyPhoneNumber(
      String phoneNumber);

  Future<Either<Failure, User>> signInWithPhoneNumber(String smsCode);

  Future<Either<Failure, User>> signInWithGoogle();

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, Stream<User>>> onAuthStateChanged();

  Future<Either<Failure, void>> forgotPassword(String email);

  Future<Either<Failure, User>> get user;
}
