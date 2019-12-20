import 'package:equatable/equatable.dart';

class Country extends Equatable {
  final String name;
  final String code;
  final String dialCode;
  final String flag;

  Country({this.name, this.code, this.dialCode, this.flag});

  factory Country.fromJson(Map<String, dynamic> json) => Country(
      name: json["name"],
      code: json["code"],
      dialCode: json["dial_code"],
      flag: json["flag"]);

  Map<String, dynamic> toJson() =>
      {'name': name, 'code': code, 'dial_code': dialCode, 'flag': flag};

  @override
  String toString() {
    return "{'name':$name,'code':$code,'dialCode':$dialCode,'flag':$flag}";
  }

  @override
  List<Object> get props => [name, code, dialCode, flag];
}
