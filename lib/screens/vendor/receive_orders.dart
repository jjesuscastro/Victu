import 'package:flutter/material.dart';
import 'package:victu/objects/meal.dart';
import 'package:victu/objects/users/vendor_data.dart';
import 'package:victu/utils/qr.dart';

class ReceiveOrders extends StatefulWidget {
  final VendorData vendorData;

  const ReceiveOrders({super.key, required this.vendorData});

  @override
  State<ReceiveOrders> createState() => _ReceiveOrdersState();
}

class _ReceiveOrdersState extends State<ReceiveOrders> {
  List<Meal> meals = [];
  bool mealsLoaded = false;

  String qrData = 'Test data';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffebebeb),
      appBar: AppBar(
        elevation: 4,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff2b9685),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: const Text(
          "Check Orders",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            fontSize: 18,
            color: Color(0xffffffff),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        child: generateQR(qrData),
      ),
    );
  }
}
