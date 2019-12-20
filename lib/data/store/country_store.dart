import 'package:hyperloop/data/models/country_model.dart';

abstract class CountryStore {
  Stream<List<CountryModel>> get countries;
}
