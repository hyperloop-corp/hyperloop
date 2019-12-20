import 'package:dartz/dartz.dart';
import 'package:hyperloop/core/errors/failure.dart';
import 'package:hyperloop/domain/entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, void>> updateUserData(
      String firstName,
      String lastName,
      String email,
      String phone,
      String latitude,
      String longitude);

  Future<Either<Failure, Stream<UserData>>> get userData;
}
