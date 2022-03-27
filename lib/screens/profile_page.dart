import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:country_code_picker/country_code.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_services/const/endpoints.dart';
import 'package:wallet_services/models/response_edit_profile.dart';
import 'package:wallet_services/models/response_edit_profile_error.dart';
import 'package:wallet_services/screens/login_page.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String id = "";
  String fullname = ""; //NAME
  String username = ""; //EMAIL
  String typeUser = "";
  String phone = "";
  String typeDoc = "";
  String numeral = "";
  String phoneCode = "";
  bool isLoading = false;

  final TextEditingController _username = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _pass2 = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _numberCedula = TextEditingController();

  List<DropdownMenuItem<String>> get misTypeDocs {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(child: Text("TIPO DE DOCUMENTO"), value: ""),
      const DropdownMenuItem(child: Text("CEDULA"), value: "CEDULA"),
      const DropdownMenuItem(child: Text("PASAPORTE"), value: "PASAPORTE"),
      const DropdownMenuItem(child: Text("NIF"), value: "NIF"),
    ];
    return menuItems;
  }

  String myValueSelected = "";

  CountryCode? myPhoneCodeSelected;

  bool visibleNomDoc = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      asignarCampos();
    });

    sincronizarDatosLocales();
  }

  void asignarCampos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      id = prefs.getString('id')!;
      fullname = prefs.getString('fullname')!;
      username = prefs.getString('username')!;
      typeUser = prefs.getString('typeUser')!;
      phone = prefs.getString('phone')!;
      typeDoc = prefs.getString('typeDoc')!;
      numeral = prefs.getString('numeral')!;
      phoneCode = prefs.getString('phoneCode')!;

      _name.text = fullname;
      _username.text = username;
      _phone.text = phone;
      _numberCedula.text = numeral;
      myValueSelected = typeDoc;
    });
  }

  void sincronizarDatosLocales() async {
    setState(() {
      //print("Token: " + prefs.getString("token")!);
      //print("ID USER: " + prefs.getString("id")!);
    });
  }

  void _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
    prefs.setString('username', username);
    prefs.setString('fullname', fullname);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Login()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /*2*/
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    fullname,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  username,
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: const Color(0xffF3AB0D),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.logout), onPressed: _logOut),
          //IconButton(icon: const Icon(Icons.person), onPressed: () {})
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  child: const Text(
                    "Edita los campos que desees.",
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
                      contentPadding: EdgeInsets.only(bottom: 8.0, top: 8.0),
                      border: OutlineInputBorder(),
                    ),
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
                            border: Border.all(
                                color: Color.fromARGB(255, 110, 108, 108)),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: CountryCodePicker(
                            initialSelection: '+52',
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
                        contentPadding: EdgeInsets.only(bottom: 8.0, top: 8.0),
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
                      contentPadding: EdgeInsets.only(bottom: 8.0, top: 8.0),
                      border: OutlineInputBorder(),
                    ),
                    disabledHint: const Text("Can't select"),
                    onChanged: (_) {
                      setState(() {
                        myValueSelected = _.toString();

                        if (myValueSelected != "") {
                          visibleNomDoc = true;
                        } else {
                          visibleNomDoc = false;
                        }
                      });
                    },
                    value: myValueSelected,
                    items: misTypeDocs,
                  ),
                ),
                Visibility(
                  visible: visibleNomDoc,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: TextField(
                      textInputAction: TextInputAction.next,
                      controller: _numberCedula,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.numbers,
                          size: 20,
                        ),
                        hintText: myValueSelected == "CEDULA"
                            ? 'Ingrese el No.'
                            : 'Ingrese el No.',
                        contentPadding:
                            const EdgeInsets.only(bottom: 8.0, top: 8.0),
                        border: const OutlineInputBorder(),
                      ),
                    ),
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
                      contentPadding: EdgeInsets.only(bottom: 8.0, top: 8.0),
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
                      contentPadding: EdgeInsets.only(bottom: 8.0, top: 8.0),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextButton(
                    child: Text(
                      "EDITAR PERFIL".toUpperCase(),
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
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    onPressed: editProfile,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> editProfile() async {
    if (_username.text.isNotEmpty &&
        _name.text.isNotEmpty &&
        _phone.text.isNotEmpty &&
        myValueSelected.isNotEmpty &&
        _numberCedula.text.isNotEmpty) {
      if (_pass.text != "" || _pass2.text != "") {
        if (_pass.text == _pass2.text) {
          setState(() {
            isLoading = true;
          });

          String? code = myPhoneCodeSelected?.dialCode;

          processRegister(
              _username.text,
              _pass.text,
              _name.text,
              "${_phone.text}",
              myValueSelected,
              _numberCedula.text,
              'SI',
              phoneCode);
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
        setState(() {
          isLoading = true;
        });

        String? code = myPhoneCodeSelected?.dialCode;

        processRegister(
            _username.text,
            _pass.text,
            _name.text,
            "${_phone.text}",
            myValueSelected,
            _numberCedula.text,
            'NO',
            phoneCode);
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

  processRegister(email, password, name, phone, type_doc, numeral, traePassword,
      codePhone) async {
    Map data;
    if (traePassword == "SI") {
      data = {
        'email': email,
        'password': password,
        'name': name,
        'phone': phone,
        'type_doc': type_doc,
        'numeral': numeral,
        'id': id,
        'phoneCode': codePhone
      };
    } else {
      data = {
        'email': email,
        'name': name,
        'phone': phone,
        'type_doc': type_doc,
        'numeral': numeral,
        'id': id,
        'phoneCode': codePhone
      };
    }

    print(data.toString());

    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await http.post(
      Uri.parse(Endpoints.editarPerfil),
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
      ResponseEditProfile correcto =
          ResponseEditProfile.fromJson(jsonDecode(response.body));

      prefs.setString('id', "${correcto.data.id}");
      prefs.setString('fullname', correcto.data.name!);
      prefs.setString('username', correcto.data.email!);
      prefs.setString('typeUser', correcto.data.typeUser!);
      prefs.setString('phone', correcto.data.phone!);
      prefs.setString('typeDoc', correcto.data.typeDoc!);
      prefs.setString('numeral', correcto.data.numeral!);
      prefs.setString('phoneCode', correcto.data.phoneCode!);

      CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        text: 'Perfil Editado',
        title: "Perfil Editado Correctamente",
      );

      print(correcto.data.toJson());
    } else {
      ResponseEditProfileError incorrecto =
          ResponseEditProfileError.fromJson(jsonDecode(response.body));

      String errores = "";

      for (var error in incorrecto.error) {
        errores += "$error \n";
      }

      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: errores,
        title: "Editado Incorrecto",
      );
    }
  }
}
