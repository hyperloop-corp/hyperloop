import 'package:dartz/dartz.dart';
import 'package:hyperloop/core/errors/failure.dart';
import 'package:hyperloop/core/usecases/usecase.dart';
import 'package:hyperloop/domain/entities/user.dart';
import 'package:hyperloop/domain/repositories/authentication_repository.dart';

class GetAuthStatus extends UseCase<Stream<User>, NoParams> {
  final AuthenticationRepository repository;

  GetAuthStatus(this.repository);

  @override
  Future<Either<Failure, Stream<User>>> call(NoParams params) async {
    return await repository.onAuthStateChanged();
  }
}
