// To parse this JSON data, do
//
//     final responseTransferByPhone = responseTransferByPhoneFromJson(jsonString);

import 'dart:convert';

ResponseTransferByPhone responseTransferByPhoneFromJson(String str) => ResponseTransferByPhone.fromJson(json.decode(str));

String responseTransferByPhoneToJson(ResponseTransferByPhone data) => json.encode(data.toJson());

class ResponseTransferByPhone {
    ResponseTransferByPhone({
        required this.success,
        required this.message,
    });

    bool success;
    String message;

    factory ResponseTransferByPhone.fromJson(Map<String, dynamic> json) => ResponseTransferByPhone(
        success: json["success"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
    };
}
