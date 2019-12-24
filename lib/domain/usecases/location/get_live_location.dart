import 'package:dartz/dartz.dart';
import 'package:hyperloop/core/errors/failure.dart';
import 'package:hyperloop/core/usecases/usecase.dart';
import 'package:hyperloop/domain/entities/location.dart';
import 'package:hyperloop/domain/repositories/location_repository.dart';

class GetLiveLocation extends UseCase<Stream<Location>, NoParams> {
  final LocationRepository repository;

  GetLiveLocation(this.repository);

  @override
  Future<Either<Failure, Stream<Location>>> call(NoParams params) async {
    return await repository.onLocationChanged();
  }
}
