import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:hyperloop/app/bloc/country_bloc/country_event.dart';
import 'package:hyperloop/app/bloc/country_bloc/country_state.dart';
import 'package:hyperloop/core/errors/failure.dart';
import 'package:hyperloop/core/usecases/usecase.dart';
import 'package:hyperloop/domain/entities/country.dart';
import 'package:hyperloop/domain/usecases/country/get_countries_usercase.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String UNEXPECTED_ERROR_MESSAGE = 'Unexpected error';

class CountryBloc extends Bloc<CountryEvent, CountryState> {
  final GetCountries getCountries;

  StreamSubscription _countriesSubscription;

  CountryBloc({this.getCountries});

  @override
  CountryState get initialState => Uninitialized();

  @override
  Stream<CountryState> mapEventToState(CountryEvent event) async* {
    print('CountryEvent: ' + event.toString());
    if (event is LoadCountries) {
      yield* _mapLoadCountriesToState();
    } else if (event is CountriesUpdated) {
      yield* _mapCountriesUpdateToState(event);
    }
  }

  Stream<CountryState> _mapLoadCountriesToState() async* {
    try {
      final failureOrCountries = await getCountries(NoParams());
      yield* failureOrCountries.fold(
          (failure) =>
              Stream.value(CountryError(message: _mapFailureToMessage(failure))),
          (countriesStream) => _mapCountryToState(countriesStream));
    } catch (e) {
      yield CountryError(message: UNEXPECTED_ERROR_MESSAGE);
    }
  }

  Stream<CountryState> _mapCountryToState(
      Stream<List<Country>> countriesStream) async* {
    _countriesSubscription?.cancel();
    _countriesSubscription = countriesStream.listen((countries) {
      add(CountriesUpdated(countries: countries));
    });
  }

  Stream<CountryState> _mapCountriesUpdateToState(
      CountriesUpdated event) async* {
    yield CountriesLoaded(countries: event.countries);
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      default:
        return UNEXPECTED_ERROR_MESSAGE;
    }
  }

  @override
  Future<void> close() {
    _countriesSubscription?.cancel();
    return super.close();
  }
}
