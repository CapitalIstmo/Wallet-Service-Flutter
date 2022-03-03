import 'package:flutter/material.dart';

// To parse this JSON data, do
//
//     final responseMakeTransfer = responseMakeTransferFromJson(jsonString);

import 'dart:convert';

ResponseMakeTransfer responseMakeTransferFromJson(String str) =>
    ResponseMakeTransfer.fromJson(json.decode(str));

String responseMakeTransferToJson(ResponseMakeTransfer data) =>
    json.encode(data.toJson());

class ResponseMakeTransfer {
  ResponseMakeTransfer({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  factory ResponseMakeTransfer.fromJson(Map<String, dynamic> json) =>
      ResponseMakeTransfer(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
