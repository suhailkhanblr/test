import 'dart:convert';

List<UserDTO> userDTOFromJson(String str) =>
    List<UserDTO>.from(json.decode(str).map((x) => UserDTO.fromJson(x)));

String userDTOToJson(List<UserDTO> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserDTO {
  String username;
  String name;
  String email;
  String countryCode;
  String mobileNumber;
  String password;
  String fbLogin;

  UserDTO({
    required this.username,
    required this.name,
    required this.email,
    required this.countryCode,
    required this.mobileNumber,
    required this.password,
    required this.fbLogin,
  });

  factory UserDTO.fromJson(Map<String, dynamic> json) => UserDTO(
        username: json["username"],
        name: json["name"],
        email: json["email"],
        countryCode: json["country_code"],
        mobileNumber: json["mobile_number"],
        password: json["password"],
        fbLogin: json["fb_login"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "name": name,
        "email": email,
        "country_code": countryCode,
        "mobile_number": mobileNumber,
        "password": password,
        "fb_login": fbLogin,
      };
}
