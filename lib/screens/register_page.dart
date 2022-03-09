import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallet_services/const/endpoints.dart';
import 'package:wallet_services/models/response_error_login.dart';
import 'package:wallet_services/models/response_error_register.dart';
import 'package:wallet_services/models/response_login.dart';
import 'package:wallet_services/models/response_register.dart';
import 'package:wallet_services/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _pass2 = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  bool isLoading = false;

  List<DropdownMenuItem<String>> get misTypeDocs {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(child: Text("TIPO DE DOCUMENTO"), value: ""),
      const DropdownMenuItem(child: Text("CEDULA"), value: "CEDULA"),
      const DropdownMenuItem(child: Text("PASAPORTE"), value: "PASAPORTE"),
    ];
    return menuItems;
  }

  String myValueSelected = "";

  CountryCode? myPhoneCodeSelected;

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
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Register New User",
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
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: const Text(
                            "Rellena los datos solicitados.",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: TextField(
                            textInputAction: TextInputAction.next,
                            obscureText: false,
                            controller: _name,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.person_outline,
                                size: 20,
                              ),
                              hintText: 'Name',
                              contentPadding:
                                  EdgeInsets.only(bottom: 8.0, top: 8.0),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade500),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                width: 100,
                                margin: const EdgeInsets.only(right: 10),
                                child: CountryCodePicker(
                                  onChanged: (_) {
                                    setState(() {
                                      myPhoneCodeSelected = _;
                                    });
                                  },
                                  //initialSelection: 'MX',
                                  favorite: const ['+52', 'MX'],
                                  showCountryOnly: false,
                                  alignLeft: false,
                                  padding: const EdgeInsets.all(1.0),
                                ),
                              ),
                              SizedBox(
                                width: 201,
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
                                      Icons.person_outline,
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
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: TextField(
                            textInputAction: TextInputAction.next,
                            controller: _username,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.email,
                                  size: 20,
                                ),
                                hintText: 'Email',
                                contentPadding:
                                    EdgeInsets.only(bottom: 8.0, top: 8.0),
                                border: OutlineInputBorder()),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: DropdownButtonFormField(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                size: 20,
                              ),
                              hintText: 'Type Document',
                              contentPadding:
                                  EdgeInsets.only(bottom: 8.0, top: 8.0),
                              border: OutlineInputBorder(),
                            ),
                            disabledHint: const Text("Can't select"),
                            onChanged: (_) {
                              setState(() {
                                myValueSelected = _.toString();
                              });
                            },
                            value: myValueSelected,
                            items: misTypeDocs,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: TextField(
                            textInputAction: TextInputAction.next,
                            obscureText: true,
                            controller: _pass,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                size: 20,
                              ),
                              hintText: 'Password',
                              contentPadding:
                                  EdgeInsets.only(bottom: 8.0, top: 8.0),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: TextField(
                            textInputAction: TextInputAction.done,
                            obscureText: true,
                            controller: _pass2,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                size: 20,
                              ),
                              hintText: 'Repeat Password',
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
                        "REGISTRARME".toUpperCase(),
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.all(10)),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xffF3AB0D)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      onPressed: _register,
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

  Future<void> _register() async {
    if (_username.text.isNotEmpty &&
        _pass.text.isNotEmpty &&
        _name.text.isNotEmpty) {
      if (_pass.text == _pass2.text) {
        setState(() {
          isLoading = true;
        });

        String? code = myPhoneCodeSelected?.dialCode;

        processRegister(_username.text, _pass.text, _name.text,
            "${code}${_phone.text}", myValueSelected);
      } else {
        CoolAlert.show(
          context: context,
          type: CoolAlertType.warning,
          text: "Parece que las contraseñas no coinciden...",
          title: "Campos Vacios",
        );
        setState(() {
          isLoading = false;
        });
      }
    } else {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.warning,
        text: "Parece que has dejado campos vacios...",
        title: "Campos Vacios",
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  processRegister(email, password, name, phone, type_doc) async {
    Map data = {
      'email': email,
      'password': password,
      'name': name,
      'phone': phone,
      'type_doc': type_doc,
      'type_user': 'U'
    };

    print(data.toString());

    final response = await http.post(
      Uri.parse(Endpoints.register_endpoint),
      headers: {
        "Accept": "application/json",
      },
      body: data,
      encoding: Encoding.getByName("utf-8"),
    );

    setState(() {
      isLoading = false;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (response.statusCode == 200) {
      ResponseRegister correcto =
          ResponseRegister.fromJson(jsonDecode(response.body));

      prefs.setBool('user', true);
      prefs.setString('id', "${correcto.data!.id}");
      prefs.setString('username', correcto.data!.email!);
      prefs.setString('typeUser', 'U');
      prefs.setString('token', correcto.token!);
      prefs.setString('fullname', correcto.data!.name!);

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Home()),
          (Route<dynamic> route) => false);
    } else {
      ResponseErrorRegister incorrecto =
          ResponseErrorRegister.fromJson(jsonDecode(response.body));

      String errores = "";

      for (var error in incorrecto.error) {
        errores += "$error \n";
      }

      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: errores,
        title: "Registro Incorrecto",
      );
    }
  }
}
