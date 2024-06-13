// To parse this JSON data, do
//     final user = userFromJson(jsonString);

import 'dart:convert';

List<UserModel> userFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userToJson(List<UserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
  String? name;
  final String email;
  final String password;

  UserModel({
    this.name,
    required this.email,
    required this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json["name"],
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "password": password,
      };

  @override
  String toString() {
    return 'User(name: $name, email: $email, password: $password)';
  }
}
