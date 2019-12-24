import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:hyperloop/app/bloc/location_bloc/bloc.dart';
import 'package:hyperloop/core/errors/failure.dart';
import 'package:hyperloop/core/usecases/usecase.dart';
import 'package:hyperloop/domain/entities/location.dart';
import 'package:hyperloop/domain/usecases/location/enable_location_services.dart';
import 'package:hyperloop/domain/usecases/location/get_live_location.dart';
import 'package:hyperloop/domain/usecases/location/get_location.dart';

const String DEVICE_FAILURE_MESSAGE = 'Device Failure';
const String UNEXPECTED_ERROR_MESSAGE = 'Unexpected error';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final EnableLocationServices enableLocationServices;
  final GetLocation getLocation;
  final GetLiveLocation getLiveLocation;

  StreamSubscription _locationSubscription;

  LocationBloc(
      {@required this.enableLocationServices,
      @required this.getLocation,
      @required this.getLiveLocation});

  @override
  LocationState get initialState => Uninitialized();

  @override
  Stream<LocationState> mapEventToState(LocationEvent event) async* {
    print('LocationEvent: ' + event.toString());

    if (event is InvokeLocationServices) {
      yield* _mapLocationServicesToState();
    } else if (event is InvokeGetLocation) {
      yield* _mapLocationToState();
    } else if (event is InvokeGetLiveLocation) {
      yield* _mapLiveLocationToState();
    } else if (event is UpdateLocation) {
      yield* _mapUpdateLocationToState(event);
    }
  }

  Stream<LocationState> _mapLocationServicesToState() async* {
    try {
      final failureOrLocationServices =
          await enableLocationServices(NoParams());
      yield failureOrLocationServices.fold(
          (failure) => LocationError(message: _mapFailureToMessage(failure)),
          (location) => null);
    } catch (e) {
      yield LocationError(message: UNEXPECTED_ERROR_MESSAGE);
    }
  }

  Stream<LocationState> _mapLocationToState() async* {
    try {
      final failureOrLocation = await getLocation(NoParams());
      yield failureOrLocation.fold(
          (failure) => LocationError(message: _mapFailureToMessage(failure)),
          (location) => LocationUpdated(location: location));
    } catch (e) {
      yield LocationError(message: UNEXPECTED_ERROR_MESSAGE);
    }
  }

  Stream<LocationState> _mapLiveLocationToState() async* {
    try {
      final failureOrLocation = await getLiveLocation(NoParams());
      yield* failureOrLocation.fold(
          (failure) => Stream.value(
              LocationError(message: _mapFailureToMessage(failure))),
          (locationStream) => _mapLocationStreamToState(locationStream));
    } catch (e) {
      yield LocationError(message: UNEXPECTED_ERROR_MESSAGE);
    }
  }

  Stream<LocationState> _mapUpdateLocationToState(UpdateLocation event) async* {
    yield LocationUpdated(location: event.location);
  }

  Stream<LocationState> _mapLocationStreamToState(
      Stream<Location> locationStream) async* {
    _locationSubscription?.cancel();
    _locationSubscription = locationStream.listen((location) {
      add(UpdateLocation(location: location));
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case DeviceFailure:
        return DEVICE_FAILURE_MESSAGE;
      default:
        return UNEXPECTED_ERROR_MESSAGE;
    }
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}
