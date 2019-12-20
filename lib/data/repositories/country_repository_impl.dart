import 'package:dartz/dartz.dart';
import 'package:hyperloop/core/errors/failure.dart';
import 'package:hyperloop/core/network/network_info.dart';
import 'package:hyperloop/data/store/country_store.dart';
import 'package:hyperloop/domain/entities/country.dart';
import 'package:hyperloop/domain/repositories/country_repository.dart';

class CountryRepositoryImpl implements CountryRepository {
  final CountryStore countryStore;
  final NetworkInfo networkInfo;

  CountryRepositoryImpl({this.countryStore, this.networkInfo});

  @override
  Future<Either<Failure, Stream<List<Country>>>> getCountries() async {
    try {
      return Right(countryStore.countries);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
