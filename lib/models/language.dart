class Language {
  String id;
  String code;
  String direction;
  String name;
  String fileName;
  bool isActive;
  bool isDefault;

  Language({
    required this.id,
    required this.code,
    required this.direction,
    required this.name,
    required this.fileName,
    required this.isActive,
    required this.isDefault,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: json['id'],
      code: json['code'],
      direction: json['direction'],
      name: json['name'],
      fileName: json['file_name'],
      isActive: json['active'] == '1' ? true : false,
      isDefault: json['default'] == '1' ? true : false,
    );
  }
}
