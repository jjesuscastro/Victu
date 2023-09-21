import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

RepaintBoundary generateQR(String qrData) {
  final qrKey = GlobalKey();

  return RepaintBoundary(
    key: qrKey,
    child: QrImageView(
      data: qrData, //This is the part we give data to our QR
      //  embeddedImage: , You can add your custom image to the center of your QR
      //  semanticsLabel:'', You can add some info to display when your QR scanned
      size: 250,
      backgroundColor: Colors.white,
      version: QrVersions.auto, //You can also give other versions
    ),
  );
}
