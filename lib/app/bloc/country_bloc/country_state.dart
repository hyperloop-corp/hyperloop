import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hyperloop/domain/entities/country.dart';

abstract class CountryState extends Equatable {}

class Uninitialized extends CountryState {
  @override
  List<Object> get props => [];
}

class CountriesLoading extends CountryState {
  @override
  List<Object> get props => [];
}

class CountriesLoaded extends CountryState {
  final List<Country> countries;

  CountriesLoaded({@required this.countries});

  @override
  List<Object> get props => [countries];
}

class CountryError extends CountryState {
  final String message;

  CountryError({@required this.message});

  @override
  List<Object> get props => [message];
}
