import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:wallet_services/const/endpoints.dart';
import 'package:wallet_services/models/response_balance.dart';
import 'package:wallet_services/models/response_make_transfer.dart';
import 'package:wallet_services/models/response_transactions.dart';
import 'package:wallet_services/screens/add_amount.dart';
import 'package:wallet_services/screens/add_amount_send.dart';
import 'package:wallet_services/screens/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:wallet_services/screens/profile_page.dart';
import 'package:wallet_services/screens/select_destiny_page.dart';
import 'package:wallet_services/widgets/fab/action_button.dart';
import 'package:wallet_services/widgets/fab/expandable_fab.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? username;
  String? fullname;
  bool? qwer;

  String myBalance = "0.0";
  List<Datum>? _listDatum;

  void fetchBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await http.post(
      Uri.parse(Endpoints.my_balance_endpoint),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + prefs.getString("token")!,
      },
      body: {"id": prefs.getString("id")!},
      encoding: Encoding.getByName("utf-8"),
    );

    if (response.statusCode == 200) {
      ResponseBalance correcto =
          ResponseBalance.fromJson(jsonDecode(response.body));

      setState(() {
        myBalance = correcto.balance;
      });
    } else {
      ResponseBalance incorrecto =
          ResponseBalance.fromJson(jsonDecode(response.body));
      setState(() {
        myBalance = incorrecto.balance;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getAccountList();
    name();
    fetchBalance();
  }

  Future<ResponseTransactions> getAccountList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ResponseTransactions? _accountListModel;

    final response = await http.post(
      Uri.parse(Endpoints.get_my_transactions),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + prefs.getString("token")!,
      },
      body: {"id": prefs.getString("id")!},
      encoding: Encoding.getByName("utf-8"),
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);

      _accountListModel = ResponseTransactions.fromJson(res);

      var data = res["data"] as List;

      setState(() {
        _listDatum = data.map<Datum>((json) => Datum.fromJson(json)).toList();
      });
    } else {
      //show toast here
    }
    return _accountListModel!;
  }

  void name() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      fullname = prefs.getString('fullname');
      print("Token: " + prefs.getString("token")!);
      print("ID USER: " + prefs.getString("id")!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('¡Hola, $fullname!'),
        backgroundColor: const Color(0xffF3AB0D),
        actions: <Widget>[
          //IconButton(icon: const Icon(Icons.logout), onPressed: _logOut),
          IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                );
              })
        ],
      ),
      body: Center(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Column(
                  children: <Widget>[
                    const Text(
                      "Your Balance",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      myBalance + "pts.",
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 120),
              child: Center(
                child: _listDatum == null
                    ? null
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: _listDatum!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(_listDatum![index].type +
                                " | " +
                                _listDatum![index].amount),
                            subtitle: Text("${_listDatum![index].createdAt}"),
                            leading: _listDatum![index].type == "deposit"
                                ? const Icon(Icons.download)
                                : const Icon(Icons.upload),
                          );
                        },
                      ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: ExpandableFab(
        distance: 100.0,
        children: [
          ActionButton(
            tooltipp: 'PAGAR',
            onPressed: () async {
              String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                  '#ff6666', 'Cancel', true, ScanMode.BARCODE);

              print(barcodeScanRes);

              Codec<String, String> stringToBase64 = utf8.fuse(base64);

              var parts = barcodeScanRes.split('|');

              print("TOTAL: ${parts.length}");

              if (parts.length > 1) {
                String amount = parts[0];
                String bussines = parts[1];

                print("AMOUNT: " + stringToBase64.decode(amount));
                print("BUSSINESS: " + stringToBase64.decode(bussines));

                SharedPreferences prefs = await SharedPreferences.getInstance();

                processTransfer(stringToBase64.decode(bussines),
                    prefs.getString("id")!, stringToBase64.decode(amount));
              } else {
                String bussines = parts[0];
                print("BUSSINESS: " + stringToBase64.decode(bussines));

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddAmountSend(
                      bussinesId: stringToBase64.decode(bussines),
                    ),
                  ),
                );
              }
            },
            icon: const Icon(Icons.arrow_upward),
          ),
          ActionButton(
            tooltipp: 'RECIBIR',
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddAmount(),
                ),
              )
            },
            icon: const Icon(Icons.arrow_downward),
          ),
          ActionButton(
            tooltipp: 'ENVIAR POR TELEFONO',
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SelectDestinyPage(),
                ),
              )
            },
            icon: const Icon(Icons.phone),
          ),
        ],
      ),
    );
  }

  processTransfer(id_bussiness, id_payer, amount) async {
    Map data = {
      'id_bussiness': id_bussiness,
      'id_payer': id_payer,
      'amount': amount
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();

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
