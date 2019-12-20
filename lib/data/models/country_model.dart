import 'package:flutter/cupertino.dart';
import 'package:hyperloop/domain/entities/country.dart';

class CountryModel extends Country {
  CountryModel(
      {@required String name,
      @required String code,
      @required String dialCode,
      @required String flag})
      : super(name: name, code: code, dialCode: dialCode, flag: flag);

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
        name: json['name'],
        code: json['code'],
        dialCode: json['dial_code'],
        flag: json['flag']);
  }

  Map<String, dynamic> toJson() =>
      {'name': name, 'code': code, 'dial_code': dialCode, 'flag': flag};
}
