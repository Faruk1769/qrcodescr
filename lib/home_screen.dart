// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:qrcode1/qrcode_generrator_screen.dart';
import 'package:qrcode1/qrcode_scanner_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffF7524F),
        title: Center(child: Text("QR Code Scanner & Generator")),
        leading: Image.asset(
          "assets/images/qrcode.png",
          width: 40.0,
          height: 40.0,
        ),
      ),
      body: Container(
        color: Color(0xffEEEEEE),
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            SizedBox(
              width: 200,
              height: 40,
              child: ElevatedButton(
                child: Text("Scan QR Code"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=> QrCodeScannerScreen())
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffF7524F),
                  textStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  shadowColor: Color(0xffF7524F),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 200,
              height: 40,
              child: ElevatedButton(
                child: Text("Generate QR Code"),
                onPressed: () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=> QrCodeGeneratorScreen())
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffF7524F),
                  textStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  shadowColor: Color(0xffF7524F),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
