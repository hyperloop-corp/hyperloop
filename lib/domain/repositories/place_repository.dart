import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:hyperloop/core/errors/failure.dart';
import 'package:hyperloop/domain/entities/place.dart';

abstract class PlaceRepository {
  Future<Either<Failure, Stream<List<Place>>>> getPlaces();
}
