// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? number;
  String? email;
  String? lastName;
  String? id;
  String? firstName;

  UserModel({
    this.number,
    this.email,
    this.lastName,
    this.id,
    this.firstName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        number: json["number"],
        email: json["email "],
        lastName: json["last_name"],
        id: json["id"],
        firstName: json["first_name"],
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "email ": email,
        "last_name": lastName,
        "id": id,
        "first_name": firstName,
      };
}
