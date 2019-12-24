import 'package:dartz/dartz.dart';
import 'package:hyperloop/core/errors/failure.dart';
import 'package:hyperloop/core/network/network_info.dart';
import 'package:hyperloop/data/store/auth_store.dart';
import 'package:hyperloop/domain/entities/phone_auth_state.dart';
import 'package:hyperloop/domain/entities/user.dart';
import 'package:hyperloop/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthStore authStore;
  final NetworkInfo networkInfo;

  AuthenticationRepositoryImpl({this.authStore, this.networkInfo});

  @override
  Future<Either<Failure, Stream<User>>> onAuthStateChanged() async {
    try {
      return Right(authStore.onAuthStateChanged());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      return Right(
          await authStore.registerWithEmailAndPassword(email, password));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      return Right(await authStore.signInWithEmailAndPassword(email, password));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      return Right(await authStore.signOut());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    try {
      return Right(await authStore.forgotPassword(email));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> get user async {
    try {
      return Right(await authStore.user);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Stream<PhoneAuthState>>> verifyPhoneNumber(
      String phoneNumber) async {
    try {
      return Right(authStore.verifyPhoneNumber(phoneNumber));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> signInWithPhoneNumber(String smsCode) async {
    try {
      return Right(await authStore.signInWithPhoneNumber(smsCode));
    } catch (e) {
      print(e.toString());
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    try {
      return Right(await authStore.signInWithGoogle());
    } catch (e) {
      print(e.toString());
      return Left(ServerFailure());
    }
  }
}
