// To parse this JSON data, do
//
//     final responseBalance = responseBalanceFromJson(jsonString);

import 'dart:convert';

ResponseBalance responseBalanceFromJson(String str) => ResponseBalance.fromJson(json.decode(str));

String responseBalanceToJson(ResponseBalance data) => json.encode(data.toJson());

class ResponseBalance {
    ResponseBalance({
        required this.success,
        required this.message,
        required this.balance,
    });

    bool success;
    String message;
    String balance;

    factory ResponseBalance.fromJson(Map<String, dynamic> json) => ResponseBalance(
        success: json["success"],
        message: json["message"],
        balance: json["balance"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "balance": balance,
    };
}
