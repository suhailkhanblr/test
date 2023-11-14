import 'dart:convert';

List<Country> countryFromJson(String str) =>
    List<Country>.from(json.decode(str).map((x) => Country.fromJson(x)));

class Country {
  String id;
  String code;
  String lowerCaseCode;
  String name;
  String language;

  Country({
    required this.id,
    required this.code,
    required this.lowerCaseCode,
    required this.name,
    required this.language,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      code: json['code'],
      lowerCaseCode: json['lowercase_code'],
      name: json['name'],
      language: json['lang'],
    );
  }
}
