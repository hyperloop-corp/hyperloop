import 'package:dartz/dartz.dart';
import 'package:hyperloop/core/errors/failure.dart';
import 'package:hyperloop/core/usecases/usecase.dart';
import 'package:hyperloop/domain/repositories/authentication_repository.dart';

class Logout extends UseCase<void, NoParams> {
  final AuthenticationRepository repository;

  Logout(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.signOut();
  }
}
