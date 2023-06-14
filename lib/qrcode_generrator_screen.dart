// ignore_for_file: prefer_const_constructors, duplicate_ignore, prefer_const_literals_to_create_immutables, unused_field, unused_element, avoid_unnecessary_containers, no_leading_underscores_for_local_identifiers, unused_local_variable, deprecated_member_use, use_build_context_synchronously

import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class QrCodeGeneratorScreen extends StatefulWidget {
  const QrCodeGeneratorScreen({super.key});

  @override
  State<QrCodeGeneratorScreen> createState() => _QrCodeGeneratorScreenState();
}

class _QrCodeGeneratorScreenState extends State<QrCodeGeneratorScreen> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // ignore: prefer_const_constructors
        backgroundColor: Color(0xffF7524F),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/qrcode.png",
              width: 20.0,
              height: 20.0,
            ),
            // ignore: prefer_const_constructors
            Text(
              "QRCode Generator",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: QrImageView(
                  data: _controller.text,
                  size: min(MediaQuery.of(context).size.width / 1.3,
                      MediaQuery.of(context).size.height / 1.8),
                  backgroundColor: Colors.white,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              _buildTextFeild(context),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        _qrDownload(_controller.text);
                      },
                      minWidth: 150.0,
                      height: 45,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      color: Color(0xffF7524F),
                      child: Text(
                        "Download",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        _share(_controller.text);
                      },
                      minWidth: 150.0,
                      height: 45,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      color: Color(0xffF7524F),
                      child: Text(
                        "Share",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildTextFeild(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: TextField(
          controller: _controller,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          decoration: InputDecoration(
              hintText: "Enter Data",
              hintStyle: TextStyle(color: Colors.black54),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Color(0xffF7524F))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Color(0xffF7524F))),
              suffixIcon: IconButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                },
                color: Color(0xffF7524F),
                icon: Icon(
                  Icons.done,
                  size: 30,
                ),
              )),
        ),
      ),
    );
  }

  _qrCode(String _txt) async {
    // ignore: non_constant_identifier_names
    final qrValidationResult = QrValidator.validate(
        data: _txt,
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.L);

    qrValidationResult.status = QrValidationStatus.valid;
    final qrCode = qrValidationResult.qrCode;

    final painter = QrPainter.withQr(
        qr: qrCode!,
        color: const Color(0xffffffff),
        embeddedImageStyle: null,
        emptyColor: Colors.black,
        gapless: true);

    Directory _temDir = await getTemporaryDirectory();

    String _tempPath = _temDir.path;

    final _time = DateTime.now().microsecondsSinceEpoch.toString();
    String _finalPth = '$_tempPath/$_time.png';
    final picData =
        await painter.toImageData(2048, format: ImageByteFormat.png);
    await writeToFile(picData!, _finalPth);
    return _finalPth;
  }

  // ignore: body_might_complete_normally_nullable
  Future<String?> writeToFile(ByteData data, String path) async {
    final buffer = data.buffer;
    await File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  _share(String _path) async {
    String _filePath = await _qrCode(_path);
    await Share.shareFiles([_filePath],
        mimeTypes: ["image/png"],
        subject: 'My Qr Code',
        text: "Please Scan me");
  }

  _qrDownload(String _path) async {
    String _filePath = await _qrCode(_path);
    final _success = await GallerySaver.saveImage(_filePath);
    if (_success != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Download Successful!")));
    }
  }
}
