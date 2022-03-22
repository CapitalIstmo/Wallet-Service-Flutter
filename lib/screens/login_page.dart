import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:wallet_services/const/endpoints.dart';
import 'package:wallet_services/models/response_error_login.dart';
import 'package:wallet_services/models/response_login.dart';
import 'package:wallet_services/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:wallet_services/screens/register_page.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _pass = TextEditingController();
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Wallet Services",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Image.asset(
                    'assets/images/chequera.png',
                    width: 150.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: const Text(
                            "Insert your credential to continue",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _username,
                          textInputAction: TextInputAction.next,
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
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: TextField(
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
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: TextButton(
                      child: Text(
                        "INICIAR SESION".toUpperCase(),
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
                      onPressed: _login,
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Register()));
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        '¿No tienes cuenta? ¡Crea una aquí!',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (_username.text.isNotEmpty && _pass.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      processLogin(_username.text, _pass.text);
    } else {
      CoolAlert.show(
        context: context,
        type: CoolAlertType.warning,
        text: "Parece que has dejado campos vacios...",
        title: "Campos Vacios",
      );
    }
  }

  processLogin(email, password) async {
    Map data = {'email': email, 'password': password};

    print(data.toString());

    final response = await http.post(
      Uri.parse(Endpoints.login_endpoint),
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
      ResponseLogin correcto =
          ResponseLogin.fromJson(jsonDecode(response.body));

      prefs.setBool('user', true);
      prefs.setString('id', "${correcto.data!.id}");
      prefs.setString('username', correcto.data!.email!);
      prefs.setString('typeUser', correcto.data!.typeUser!);
      prefs.setString('token', correcto.token!);
      prefs.setString('fullname', correcto.data!.name!);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
      );
    } else {
      ResponseErrorLogin incorrecto =
          ResponseErrorLogin.fromJson(jsonDecode(response.body));

      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: incorrecto.message,
        title: "Inicio de Sesión Invalido",
      );
    }
  }
}
