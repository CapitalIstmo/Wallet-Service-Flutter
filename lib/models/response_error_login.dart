// To parse this JSON data, do
//
//     final responseErrorLogin = responseErrorLoginFromJson(jsonString);

import 'dart:convert';

ResponseErrorLogin responseErrorLoginFromJson(String str) => ResponseErrorLogin.fromJson(json.decode(str));

String responseErrorLoginToJson(ResponseErrorLogin data) => json.encode(data.toJson());

class ResponseErrorLogin {
    ResponseErrorLogin({
        required this.success,
        required this.message,
    });

    bool success;
    String message;

    factory ResponseErrorLogin.fromJson(Map<String, dynamic> json) => ResponseErrorLogin(
        success: json["success"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
    };
}
