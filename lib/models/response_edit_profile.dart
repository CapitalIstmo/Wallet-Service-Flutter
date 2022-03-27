// To parse this JSON data, do
//
//     final responseEditProfile = responseEditProfileFromJson(jsonString);

import 'dart:convert';

ResponseEditProfile responseEditProfileFromJson(String str) =>
    ResponseEditProfile.fromJson(json.decode(str));

String responseEditProfileToJson(ResponseEditProfile data) =>
    json.encode(data.toJson());

class ResponseEditProfile {
  ResponseEditProfile({
    this.success,
    this.message,
    required this.data,
  });

  bool? success;
  String? message;
  Data data;

  factory ResponseEditProfile.fromJson(Map<String, dynamic> json) =>
      ResponseEditProfile(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };

}

class Data {
  Data({
    this.id,
    this.name,
    this.email,
    this.typeUser,
    this.phone,
    this.typeDoc,
    this.numeral,
    this.phoneCode,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  String? email;
  String? typeUser;
  String? phone;
  String? typeDoc;
  String? numeral;
  String? phoneCode;
  DateTime? emailVerifiedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        typeUser: json["type_user"],
        phone: json["phone"],
        typeDoc: json["type_doc"],
        numeral: json["numeral"],
        phoneCode: json["phoneCode"],
        emailVerifiedAt: DateTime.parse(json["email_verified_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "type_user": typeUser,
        "phone": phone,
        "type_doc": typeDoc,
        "numeral": numeral,
        "phoneCode": phoneCode,
        "email_verified_at": emailVerifiedAt!.toIso8601String(),
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
