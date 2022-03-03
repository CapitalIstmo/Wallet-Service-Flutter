import 'package:flutter/material.dart';

// To parse this JSON data, do
//
//     final responseTransactions = responseTransactionsFromJson(jsonString);

import 'dart:convert';

class ResponseTransactions {
  List<Datum>?data;

  ResponseTransactions({
    this.data,
  });

  factory ResponseTransactions.fromJson(Map<String, dynamic> json) => ResponseTransactions(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );


  @override
  String toString() {
    return '{$data}';
  }
}

class Datum {
  Datum({
    required this.id,
    required this.amount,
    required this.type,
    required this.confirmed,
    required this.createdAt,
  });

  int id;
  String amount;
  String type;
  int confirmed;
  DateTime createdAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        amount: json["amount"],
        type: json["type"],
        confirmed: json["confirmed"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "type": type,
        "confirmed": confirmed,
        "created_at": createdAt.toIso8601String(),
      };
}
