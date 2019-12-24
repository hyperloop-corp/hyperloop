import 'package:dartz/dartz.dart';
import 'package:hyperloop/core/errors/failure.dart';
import 'package:hyperloop/domain/entities/location.dart';
import 'package:hyperloop/domain/repositories/location_repository.dart';
import 'package:location/location.dart' as LocationService;

class LocationRepositoryImpl implements LocationRepository {
  final LocationService.Location locationDevice;

  LocationRepositoryImpl(this.locationDevice);

  @override
  Future<Either<Failure, void>> enableLocationServices() async {
    bool enabled = await locationDevice.serviceEnabled();
    bool hasPermission = await locationDevice.hasPermission();

    try {
      if (!enabled) {
        return Right(await locationDevice.requestService());
      }
      if (!hasPermission) {
        return Right(await locationDevice.requestPermission());
      }
      return Right(null);
    } catch (e) {
      print(e.toString());
      return Left(DeviceFailure());
    }
  }

  @override
  Future<Either<Failure, Location>> getLocation() async {
    try {
      LocationService.LocationData location = await locationDevice.getLocation();
      return Right(Location.withoutTime(location.latitude.toString(),
          location.longitude.toString(), location.speed));
    } catch (e) {
      print(e.toString());
      return Left(DeviceFailure());
    }
  }

  @override
  Future<Either<Failure, Stream<Location>>> onLocationChanged() async {
    try {
      return Right(locationDevice.onLocationChanged().map((location) {
        return Location.withoutTime(location.latitude.toString(),
            location.longitude.toString(), location.speed);
      }));
    } catch (e) {
      print(e.toString());
      return Left(DeviceFailure());
    }
  }
}
