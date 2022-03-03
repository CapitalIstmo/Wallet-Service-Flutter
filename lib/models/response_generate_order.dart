import 'package:flutter/material.dart';

// To parse this JSON data, do
//
//     final responseGenerateOrder = responseGenerateOrderFromJson(jsonString);

import 'dart:convert';

ResponseGenerateOrder responseGenerateOrderFromJson(String str) =>
    ResponseGenerateOrder.fromJson(json.decode(str));

String responseGenerateOrderToJson(ResponseGenerateOrder data) =>
    json.encode(data.toJson());

class ResponseGenerateOrder {
  ResponseGenerateOrder({
    required this.success,
    required this.order,
  });

  bool success;
  String order;

  factory ResponseGenerateOrder.fromJson(Map<String, dynamic> json) =>
      ResponseGenerateOrder(
        success: json["success"],
        order: json["order"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "order": order,
      };
}
