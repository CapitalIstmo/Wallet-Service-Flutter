import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_services/screens/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? username;
  String? fullname;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name();
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

  void _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
    prefs.setString('username', username!);
    prefs.setString('fullname', fullname!);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (c) => const Login()));
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
                    fullname!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  username!,
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit),
        backgroundColor: Colors.orange.shade600,
        onPressed: () => {},
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Image.asset(
              'assets/images/sc.jpg',
              width: 600,
              height: 240,
              fit: BoxFit.contain,
            ),
          ),
          titleSection,
        ],
      ),
    );
  }
}
