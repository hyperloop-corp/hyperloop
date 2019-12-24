import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:hyperloop/core/errors/failure.dart';
import 'package:hyperloop/domain/entities/location.dart';

abstract class LocationRepository {
  Future<Either<Failure, Location>> getLocation();

  Future<Either<Failure, Stream<Location>>> onLocationChanged();

  Future<Either<Failure, void>> enableLocationServices();
}
