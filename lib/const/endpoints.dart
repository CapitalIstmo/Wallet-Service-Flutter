import 'package:flutter/material.dart';

class Endpoints {
  static String baseUrl = "https://wallet-services.herokuapp.com/";

  static String versionApi = "v1/";

  static String secondUrl = "/api";

  static String login_endpoint = baseUrl + "api/login";

  static String register_endpoint = baseUrl + "api/register";

  static String my_balance_endpoint = baseUrl + "api/v1/users/myBalance";

  static String get_my_transactions =
      baseUrl + "api/v1/users/viewMyTransactions";

  static String make_transfer = baseUrl + "api/v1/transactions/makeTransfer";

  static String generate_order_pay =
      baseUrl + "api/v1/transactions/makeOrderPay";

  static String make_transfer_by_phone =
      baseUrl + "api/v1/transactions/makeTransferByPhone";

  static String get_info_user = baseUrl + "api/v1/users/getUser";

  static String editarPerfil = baseUrl + "api/v1/users/editarPerfil";
}
