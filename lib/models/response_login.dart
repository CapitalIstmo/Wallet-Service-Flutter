// To parse this JSON data, do
//
//     final responseLogin = responseLoginFromJson(jsonString);

import 'dart:convert';

ResponseLogin responseLoginFromJson(String str) => ResponseLogin.fromJson(json.decode(str));

String responseLoginToJson(ResponseLogin data) => json.encode(data.toJson());

class ResponseLogin {
    ResponseLogin({
        this.success,
        this.token,
        this.message,
        this.data,
    });

    bool? success;
    String? token;
    String? message;
    Data? data;

    factory ResponseLogin.fromJson(Map<String, dynamic> json) => ResponseLogin(
        success: json["success"],
        token: json["token"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "token": token,
        "message": message,
        "data": data!.toJson(),
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
        this.password,
        this.rememberToken,
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
    String? password;
    String? rememberToken;
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
        password: json["password"],
        rememberToken: json["remember_token"],
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
        "password": password,
        "remember_token": rememberToken,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
    };
}
