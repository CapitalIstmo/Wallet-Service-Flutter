import 'package:flutter/material.dart';

// To parse this JSON data, do
//
//     final responseRegister = responseRegisterFromJson(jsonString);

import 'dart:convert';

ResponseRegister responseRegisterFromJson(String str) =>
    ResponseRegister.fromJson(json.decode(str));

String responseRegisterToJson(ResponseRegister data) =>
    json.encode(data.toJson());

class ResponseRegister {
  ResponseRegister({
    this.success,
    this.token,
    this.message,
    this.data,
  });

  bool? success;
  String? token;
  String? message;
  Data? data;

  factory ResponseRegister.fromJson(Map<String, dynamic> json) =>
      ResponseRegister(
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
    this.name,
    this.email,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.wallet,
  });

  String? name;
  String? email;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;
  Wallet? wallet;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        name: json["name"],
        email: json["email"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
        wallet: Wallet.fromJson(json["wallet"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "updated_at": updatedAt!.toIso8601String(),
        "created_at": createdAt!.toIso8601String(),
        "id": id,
        "wallet": wallet!.toJson(),
      };
}

class Wallet {
  Wallet({
    this.balance,
    this.decimalPlaces,
    this.holderId,
    this.holderType,
    this.name,
    this.slug,
    this.meta,
    this.uuid,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  String? balance;
  int? decimalPlaces;
  int? holderId;
  String? holderType;
  String? name;
  String? slug;
  List<dynamic>? meta;
  String? uuid;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        balance: json["balance"],
        decimalPlaces: json["decimal_places"],
        holderId: json["holder_id"],
        holderType: json["holder_type"],
        name: json["name"],
        slug: json["slug"],
        meta: List<dynamic>.from(json["meta"].map((x) => x)),
        uuid: json["uuid"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "balance": balance,
        "decimal_places": decimalPlaces,
        "holder_id": holderId,
        "holder_type": holderType,
        "name": name,
        "slug": slug,
        "meta": List<dynamic>.from(meta!.map((x) => x)),
        "uuid": uuid,
        "updated_at": updatedAt!.toIso8601String(),
        "created_at": createdAt!.toIso8601String(),
        "id": id,
      };
}