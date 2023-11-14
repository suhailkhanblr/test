import 'dart:convert';

List<LanguagePackModel> languagePackModelFromJson(String str) =>
    List<LanguagePackModel>.from(
        json.decode(str).map((x) => LanguagePackModel.fromJson(x)));

String languagePackModelToJson(List<LanguagePackModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LanguagePackModel {
  String language;
  String countryCode;
  String languageCode;
  String direction;
  Map<String, String> text;
  Map<String, String> hashTags;

  LanguagePackModel({
    required this.language,
    required this.countryCode,
    required this.languageCode,
    required this.direction,
    required this.text,
    required this.hashTags,
  });

  factory LanguagePackModel.fromJson(Map<String, dynamic> json) =>
      LanguagePackModel(
        language: json["language"],
        countryCode: json["country_code"],
        languageCode: json["language_code"],
        direction: json["direction"],
        hashTags: Map.from(json["hashTags"])
            .map((k, v) => MapEntry<String, String>(k, v)),
        text: Map.from(json["text"])
            .map((k, v) => MapEntry<String, String>(k, v)),
      );

  Map<String, dynamic> toJson() => {
        "language": language,
        "country_code": countryCode,
        "language_code": languageCode,
        "direction": direction,
        "text": Map.from(text).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "hashTags":
            Map.from(text).map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}
