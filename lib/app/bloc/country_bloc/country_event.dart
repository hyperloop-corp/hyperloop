import 'package:equatable/equatable.dart';
import 'package:hyperloop/domain/entities/country.dart';

abstract class CountryEvent extends Equatable {}

class LoadCountries extends CountryEvent {
  @override
  List<Object> get props => [];
}

class CountriesUpdated extends CountryEvent {
  final List<Country> countries;

  CountriesUpdated({this.countries});

  @override
  List<Object> get props => [countries];
}
