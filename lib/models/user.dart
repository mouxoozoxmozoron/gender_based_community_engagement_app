// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  Data data;
  String token;

  User({
    required this.data,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        data: Data.fromJson(json["user"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "user": data.toJson(),
        "token": token,
      };
}

class Data {
  int id;
  String first_name;
  String last_name;
  String gender;
  String phone;
  String email;
  String? photo;
  dynamic usertype;
  dynamic emailVerifiedAt;
  DateTime createdAt;
  DateTime updatedAt;

  Data({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.gender,
    required this.phone,
    required this.email,
    this.photo,
    required this.usertype,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        first_name: json["first_name"],
        last_name: json["first_name"],
        gender: json["gender"],
        phone: json["phone"],
        email: json["email"],
        photo: json["Photo"],
        usertype: json["usertype"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": first_name,
        "last_name": last_name,
        "gender": gender,
        "phone": phone,
        "email": email,
        "Photo": photo,
        "usertype": usertype,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
