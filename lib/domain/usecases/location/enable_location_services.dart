import 'package:dartz/dartz.dart';
import 'package:hyperloop/core/errors/failure.dart';
import 'package:hyperloop/core/usecases/usecase.dart';
import 'package:hyperloop/domain/repositories/location_repository.dart';

class EnableLocationServices extends UseCase<void, NoParams> {
  final LocationRepository repository;

  EnableLocationServices(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.enableLocationServices();
  }
}
