// To parse this JSON data, do
//
//     final responseErrorRegister = responseErrorRegisterFromJson(jsonString);

import 'dart:convert';

ResponseErrorRegister responseErrorRegisterFromJson(String str) => ResponseErrorRegister.fromJson(json.decode(str));

String responseErrorRegisterToJson(ResponseErrorRegister data) => json.encode(data.toJson());

class ResponseErrorRegister {
    ResponseErrorRegister({
        required this.success,
        required this.error,
    });

    bool success;
    List<String> error;

    factory ResponseErrorRegister.fromJson(Map<String, dynamic> json) => ResponseErrorRegister(
        success: json["success"],
        error: List<String>.from(json["error"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "error": List<dynamic>.from(error.map((x) => x)),
    };
}
