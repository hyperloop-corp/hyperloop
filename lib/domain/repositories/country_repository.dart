import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:hyperloop/core/errors/failure.dart';
import 'package:hyperloop/domain/entities/country.dart';

abstract class CountryRepository {
  Future<Either<Failure, Stream<List<Country>>>> getCountries();
}
