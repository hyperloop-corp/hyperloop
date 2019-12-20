import 'package:dartz/dartz.dart';
import 'package:hyperloop/core/errors/failure.dart';
import 'package:hyperloop/core/network/network_info.dart';
import 'package:hyperloop/data/store/user_store.dart';
import 'package:hyperloop/domain/entities/user.dart';
import 'package:hyperloop/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserStore userStore;
  final NetworkInfo networkInfo;

  UserRepositoryImpl({this.userStore, this.networkInfo});

  @override
  Future<Either<Failure, Stream<UserData>>> get userData async {
    try {
      return Right(userStore.userData);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateUserData(
      String firstName,
      String lastName,
      String email,
      String phone,
      String latitude,
      String longitude) async {
    try {
      return Right(await userStore.updateUserData(
          firstName, lastName, email, phone, latitude, longitude));
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
