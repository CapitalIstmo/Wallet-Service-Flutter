import 'package:cool_alert/cool_alert.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:wallet_services/const/endpoints.dart';
import 'package:wallet_services/models/response_transfer_by_phone.dart';
import 'dart:convert';

import 'package:wallet_services/screens/home.dart';

class SelectDestinyPage extends StatefulWidget {
  const SelectDestinyPage({Key? key}) : super(key: key);

  @override
  State<SelectDestinyPage> createState() => _SelectDestinyPageState();
}

class _SelectDestinyPageState extends State<SelectDestinyPage> {
  List<Contact>? _contacts;
  Contact? _contact;

  final TextEditingController _amount = TextEditingController();
  final TextEditingController _phone = TextEditingController();

  CountryCode? myPhoneCodeSelected;

  bool isLoading = false;
  bool? qwer;

  @override
  void initState() {
    super.initState();
    //refreshContacts();
  }

  Future<void> refreshContacts() async {
    var contactos = (await ContactsService.getContacts(withThumbnails: false));
    setState(() {
      _contacts = contactos;
    });
  }

  Future<void> _pickContact() async {
    try {
      final Contact? contact = await ContactsService.openDeviceContactPicker();
      setState(() {
        _contact = contact;
      });
    } catch (e) {
      print(e.toString());
    }
  }

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
                    "Enviar puntos usando el No. Tel",
                    style: TextStyle(
                      fontSize: 20,
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
                              hintText: 'Monto - Ejemplo: 100',
                              contentPadding:
                                  EdgeInsets.only(bottom: 8.0, top: 8.0),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 2),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade500),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: CountryCodePicker(
                              onChanged: (_) {
                                setState(() {
                                  myPhoneCodeSelected = _;
                                });
                              },
                              //initialSelection: 'MX',
                              favorite: const ['+52', 'MX'],
                              showCountryOnly: false,
                              padding: EdgeInsets.all(0),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.phone,
                            obscureText: false,
                            controller: _phone,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                            ],
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.phone,
                                size: 20,
                              ),
                              hintText: 'Phone',
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
                        if (_phone.text.isNotEmpty && _amount.text.isNotEmpty) {
                          String? code = myPhoneCodeSelected?.dialCode;

                          processTransfer(
                              "${code}${_phone.text}", _amount.text);
                        } else {
                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.warning,
                            text: 'Faltan campos por llenar.',
                            title: 'No procede',
                          );
                        }
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

  processTransfer(phone, amount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map data = {
      'phone': phone,
      'id_payer': prefs.getString("id")!,
      'amount': amount
    };

    final response = await http.post(
      Uri.parse(Endpoints.make_transfer_by_phone),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + prefs.getString("token")!,
      },
      body: data,
      encoding: Encoding.getByName("utf-8"),
    );

    if (response.statusCode == 200) {
      ResponseTransferByPhone correcto =
          ResponseTransferByPhone.fromJson(jsonDecode(response.body));

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
      ResponseTransferByPhone incorrecto =
          ResponseTransferByPhone.fromJson(jsonDecode(response.body));
    }
  }
}
