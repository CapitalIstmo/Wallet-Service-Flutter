import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:wallet_services/const/endpoints.dart';
import 'package:wallet_services/models/response_generate_order.dart';
import 'package:wallet_services/screens/my_qr.dart';

class AddAmount extends StatefulWidget {
  const AddAmount({Key? key}) : super(key: key);

  @override
  _AddAmountState createState() => _AddAmountState();
}

class _AddAmountState extends State<AddAmount> {
  final TextEditingController _amount = TextEditingController();
  bool isLoading = false;

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
                    "Agrega el monto a Recibir",
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
                            textInputAction: TextInputAction.next,
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
                        "GENERAR".toUpperCase(),
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
                      onPressed: _generarDatosyEnviar,
                    ),
                  ),
                  const Text(
                    "ó",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextButton(
                      child: Text(
                        "GENERAR SIN MONTO".toUpperCase(),
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
                      onPressed: () async{

                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        Codec<String, String> stringToBase64 = utf8.fuse(base64);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyQr(
                              dataQr: stringToBase64.encode(prefs.getString("id")!),
                              typeQR: false,
                            ),
                          ),
                        );
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

  void _generarDatosyEnviar() async {
    if (_amount.text.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      Map data = {
        'amount': _amount.text,
        'id_bussiness': prefs.getString('id')!
      };

      print(data.toString());

      final response = await http.post(
        Uri.parse(Endpoints.generate_order_pay),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer " + prefs.getString("token")!,
        },
        body: data,
        encoding: Encoding.getByName("utf-8"),
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        ResponseGenerateOrder correcto =
            ResponseGenerateOrder.fromJson(jsonDecode(response.body));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyQr(
              dataQr: correcto.order,
              typeQR: true,
            ),
          ),
        );
      } else {
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: 'Error del Server',
          title: "Parece que ocurrio un error...",
        );
      }
    } else {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.warning,
        text: 'El monto no puede quedar en blanco.',
        title: "Monto Invalido.",
      );
    }
  }
}
