// To parse this JSON data, do
//
//     final responseEditProfileError = responseEditProfileErrorFromJson(jsonString);

import 'dart:convert';

ResponseEditProfileError responseEditProfileErrorFromJson(String str) => ResponseEditProfileError.fromJson(json.decode(str));

String responseEditProfileErrorToJson(ResponseEditProfileError data) => json.encode(data.toJson());

class ResponseEditProfileError {
    ResponseEditProfileError({
        this.success,
        required this.error,
    });

    bool? success;
    List<String> error;

    factory ResponseEditProfileError.fromJson(Map<String, dynamic> json) => ResponseEditProfileError(
        success: json["success"],
        error: List<String>.from(json["error"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "error": List<dynamic>.from(error.map((x) => x)),
    };
}
