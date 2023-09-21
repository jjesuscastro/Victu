import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:victu/objects/order.dart';

RepaintBoundary generateQR(var qrKey, String qrData, Order order) {
  return RepaintBoundary(
    key: qrKey,
    child: Stack(alignment: AlignmentDirectional.topCenter, children: [
      Container(
        width: 250,
        height: 265,
        color: const Color(0xffe1eddf),
      ),
      Positioned(
        top: 15,
        child: QrImageView(
          data: qrData, //This is the part we give data to our QR
          embeddedImage: Image.asset('assets/images/victu_logo.png').image,
          //  semanticsLabel:'', You can add some info to display when your QR scanned
          size: 250,
          backgroundColor: const Color(0xffe1eddf),
          version: QrVersions.auto, //You can also give other versions
        ),
      ),
      Text(order.date),
    ]),
  );
}
