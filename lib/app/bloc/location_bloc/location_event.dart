import 'package:equatable/equatable.dart';
import 'package:hyperloop/domain/entities/location.dart';

abstract class LocationEvent extends Equatable {}

class InvokeLocationServices extends LocationEvent {
  @override
  List<Object> get props => [];
}

class InvokeGetLocation extends LocationEvent {
  @override
  List<Object> get props => [];
}

class InvokeGetLiveLocation extends LocationEvent {
  @override
  List<Object> get props => [];
}

class UpdateLocation extends LocationEvent {
  final Location location;

  UpdateLocation({this.location});

  @override
  List<Object> get props => [location];
}
