class CountryState {
  String id;
  String code;
  String name;

  CountryState({
    required this.id,
    required this.code,
    required this.name,
  });

  factory CountryState.fromJson(Map<String, dynamic> json) {
    return CountryState(
      id: json['id'],
      code: json['code'],
      name: json['name'],
    );
  }
}
