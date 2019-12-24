import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hyperloop/domain/entities/location.dart';

abstract class LocationState extends Equatable {}

class Uninitialized extends LocationState {
  @override
  List<Object> get props => [];
}

class LocationUpdated extends LocationState {
  final Location location;

  LocationUpdated({@required this.location});

  @override
  List<Object> get props => [location];
}

class LocationError extends LocationState {
  final String message;

  LocationError({@required this.message});

  @override
  List<Object> get props => [message];
}
