import 'package:dartz/dartz.dart';
import 'package:hyperloop/core/errors/failure.dart';
import 'package:hyperloop/core/usecases/usecase.dart';
import 'package:hyperloop/domain/entities/country.dart';
import 'package:hyperloop/domain/repositories/country_repository.dart';

class GetCountries extends UseCase<Stream<List<Country>>, NoParams> {
  final CountryRepository repository;

  GetCountries(this.repository);

  @override
  Future<Either<Failure, Stream<List<Country>>>> call(NoParams params) async {
    return await repository.getCountries();
  }
}
