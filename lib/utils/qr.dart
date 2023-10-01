import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:victu/objects/order.dart';

RepaintBoundary generateQR(var qrKey, String qrData, String time, Order order) {
  String timeText = time == "B"
      ? "Breakfast"
      : time == "L"
          ? "Lunch"
          : "Dinner";
  return RepaintBoundary(
    key: qrKey,
    child: Stack(alignment: AlignmentDirectional.topCenter, children: [
      Container(
        width: 250,
        height: 265,
        color: const Color(0xffe1eddf),
      ),
      Positioned(
        top: 8,
        child: QrImageView(
          data: qrData, //This is the part we give data to our QR
          embeddedImage: Image.asset('assets/images/victu_logo.png').image,
          //  semanticsLabel:'', You can add some info to display when your QR scanned
          size: 250,
          backgroundColor: const Color(0xffe1eddf),
          version: QrVersions.auto, //You can also give other versions
        ),
      ),
      Text("${order.date} - $timeText"),
      Positioned(bottom: 0, child: Text("Order #: ${order.orderNumber}"))
    ]),
  );
}
