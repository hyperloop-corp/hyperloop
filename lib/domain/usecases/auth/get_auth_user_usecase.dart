import 'package:dartz/dartz.dart';
import 'package:hyperloop/core/errors/failure.dart';
import 'package:hyperloop/core/usecases/usecase.dart';
import 'package:hyperloop/domain/entities/user.dart';
import 'package:hyperloop/domain/repositories/authentication_repository.dart';

class GetAuthUser extends UseCase<User, NoParams> {
  final AuthenticationRepository repository;

  GetAuthUser(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await repository.user;
  }
}
