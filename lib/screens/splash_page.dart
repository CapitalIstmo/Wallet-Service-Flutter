import 'package:flutter/material.dart';
import 'package:wallet_services/screens/login_page.dart';
import 'package:wallet_services/screens/home.dart';
import 'dart:async';

class SplashPage extends StatefulWidget {
  final bool user;
  const SplashPage(this.user, {Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    startSplashScreen();
  }

  startSplashScreen() {
    var duration = const Duration(seconds: 3);
    return Timer(duration, () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (c) => widget.user ? const Home() : const Login()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xffF3AB0D),
      body: Center(
        child: Text(
          "Wallet Services",
          style: TextStyle(
            fontSize: 40,
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
