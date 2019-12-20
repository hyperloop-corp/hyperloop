import 'package:dartz/dartz.dart';
import 'package:hyperloop/core/errors/failure.dart';
import 'package:hyperloop/domain/entities/location.dart';
import 'package:hyperloop/domain/repositories/location_repository.dart';
import 'package:location/location.dart' as LocationLib;

class LocationRepositoryImpl implements LocationRepository {
  final LocationLib.Location locationDevice;

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
      return Left(DeviceFailure());
    }
  }

  @override
  Future<Either<Failure, Location>> getLocation() async {
    try {
      LocationLib.LocationData location = await locationDevice.getLocation();
      return Right(Location.withoutTime(location.latitude.toString(),
          location.longitude.toString(), location.speed));
    } catch (e) {
      return Left(DeviceFailure());
    }
  }

  @override
  Stream<Location> onLocationChanged() {
    return locationDevice.onLocationChanged().map((location) {
      return Location.withoutTime(location.latitude.toString(),
          location.longitude.toString(), location.speed);
    });
  }
}
