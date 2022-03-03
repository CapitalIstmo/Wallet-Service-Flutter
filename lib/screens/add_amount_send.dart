import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:wallet_services/const/endpoints.dart';
import 'package:wallet_services/models/response_generate_order.dart';
import 'package:wallet_services/models/response_make_transfer.dart';
import 'package:wallet_services/screens/home.dart';
import 'package:wallet_services/screens/my_qr.dart';

class AddAmountSend extends StatefulWidget {
  final String bussinesId;

  const AddAmountSend({Key? key, required this.bussinesId}) : super(key: key);

  @override
  _AddAmountSendState createState() => _AddAmountSendState();
}

class _AddAmountSendState extends State<AddAmountSend> {
  final TextEditingController _amount = TextEditingController();
  bool isLoading = false;
  bool? qwer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: const Color(0xffF3AB0D),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(50),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Text(
                    "Agrega el monto a enviar",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: TextField(
                            textInputAction: TextInputAction.done,
                            controller: _amount,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.monetization_on,
                                size: 20,
                              ),
                              hintText: '0',
                              contentPadding:
                                  EdgeInsets.only(bottom: 8.0, top: 8.0),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextButton(
                      child: Text(
                        "ENVIAR PUNTOS".toUpperCase(),
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.all(10),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xffF3AB0D),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        processTransfer(widget.bussinesId, _amount.text);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  processTransfer(id_bussiness, amount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map data = {
      'id_bussiness': id_bussiness,
      'id_payer': prefs.getString("id")!,
      'amount': amount
    };

    final response = await http.post(
      Uri.parse(Endpoints.make_transfer),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + prefs.getString("token")!,
      },
      body: data,
      encoding: Encoding.getByName("utf-8"),
    );

    if (response.statusCode == 200) {
      ResponseMakeTransfer correcto =
          ResponseMakeTransfer.fromJson(jsonDecode(response.body));

      qwer = correcto.success;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
      );

      CoolAlert.show(
        context: context,
        type: qwer! ? CoolAlertType.success : CoolAlertType.error,
        text: correcto.message,
        title: qwer! ? "Transferencia Exitosa" : "Transferencia Erronea",
      );
    } else {
      ResponseMakeTransfer incorrecto =
          ResponseMakeTransfer.fromJson(jsonDecode(response.body));
    }
  }
}
