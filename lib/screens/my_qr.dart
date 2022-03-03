import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyQr extends StatefulWidget {
  final String dataQr;
  final bool typeQR;

  const MyQr({Key? key, required this.dataQr, required this.typeQR}) : super(key: key);

  @override
  State<MyQr> createState() => _MyQrState();
}

class _MyQrState extends State<MyQr> {
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
                children: [
                  const Text(
                    "¡Todo listo!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  QrImage(
                    data: widget.dataQr,
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                  Text(
                    widget.typeQR ? "Ahora recibir dinero es más facil." : "Ahora puedes recibir dinero de cualquier persona.",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w100,
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
}
