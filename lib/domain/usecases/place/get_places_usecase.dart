import 'package:dartz/dartz.dart';
import 'package:hyperloop/core/errors/failure.dart';
import 'package:hyperloop/core/usecases/usecase.dart';
import 'package:hyperloop/domain/entities/place.dart';
import 'package:hyperloop/domain/repositories/place_repository.dart';

class GetPlaces extends UseCase<Stream<List<Place>>, NoParams> {
  final PlaceRepository repository;

  GetPlaces(this.repository);

  @override
  Future<Either<Failure, Stream<List<Place>>>> call(NoParams params) async {
    return await repository.getPlaces();
  }
}
