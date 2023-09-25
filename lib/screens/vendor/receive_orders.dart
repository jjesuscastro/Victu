import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:victu/objects/meal.dart';
import 'package:victu/objects/order.dart';
import 'package:victu/objects/users/vendor_data.dart';
import 'package:victu/utils/database.dart';

class ReceiveOrders extends StatefulWidget {
  VendorData vendorData;

  ReceiveOrders({super.key, required this.vendorData});

  @override
  State<ReceiveOrders> createState() => _ReceiveOrdersState();
}

class _ReceiveOrdersState extends State<ReceiveOrders> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  String studentName = "";
  List<Meal> mealsDB = [];
  Map<Meal, int> meals = {};
  bool mealsLoaded = false;

  @override
  void initState() {
    super.initState();
    updateVendorData();
    updateMeals();
  }

  void updateVendorData() {
    getVendor(widget.vendorData.getID())
        .then((value) => {widget.vendorData = value});
  }

  void updateMeals() {
    getAllMeals().then((meals) => {
          setState(() {
            mealsDB = meals;
            mealsLoaded = true;
          })
        });
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  void readQr() async {
    if (result != null) {
      controller!.pauseCamera();
      //logic after scanning qr
      //print(result!.code); result!.code is the scanned string
      checkOrder(result!.code!);
    }
  }

  void checkOrder(String uid) async {
    try {
      processOrder(await getOrder(result!.code!));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Order not found!"),
      ));
      controller!.resumeCamera();
    }
  }

  Future<Map<Meal, int>> getMeals(Order order) async {
    Map<Meal, int> meals = {};
    order.orders.forEach((key, value) async {
      Meal meal =
          mealsDB.firstWhere((element) => element.getID() == key.split(';')[1]);
      meals[meal] = value;
    });

    return meals;
  }

  void processOrder(Order order) async {
    getUser(order.studentID).then((value) {
      studentName = value.displayName;

      getMeals(order).then((value) {
        meals = value;
        showPopup(order);
      });
    });
  }

  void showPopup(Order order) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          width: 250,
          height: 250,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                const Text(
                  "Name: ",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                ),
                Text(studentName)
              ],
            ),
            Text(order.date),
            Text(
                "${order.time == "B" ? "Breakfast" : order.time == "L" ? "Lunch" : "Dinner"} - ${order.timeFrame}"),
            const Text(""),
            const Text(
              "Orders:",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                fontSize: 14,
                color: Color(0xff000000),
              ),
            ),
            ...meals.entries.map((e) {
              return Text("${e.key.title}: Qty.: ${e.value}");
            }).toList()
          ]),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                controller!.resumeCamera();
                deleteOrder(order.getID());
                updateVendorMenu(order.orders, order.date);
              },
              child: const Text("Order(s) Claimed")),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                controller!.resumeCamera();
              },
              child: const Text("Close")),
        ],
      ),
    );
  }

  void updateVendorMenu(Map<String, int> orders, String date) {
    //key: B/L/D;<ID>;Qty
    //int: is # of orders
    //Get weekday from date

    String weekday =
        DateFormat('EEEE').format(DateFormat("MMMM DD, yyyy").parse(date));
    print(weekday);

    orders.forEach((key, qty) {
      print("Updating $weekday with $key - $qty");

      print("Updating ${widget.vendorData.menus[weekday]![key]}");
      widget.vendorData.menus[weekday]!.update(key, (value) => value - qty);
      print("Updating ${widget.vendorData.menus[weekday]![key]}");
    });

    widget.vendorData.update();
  }

  @override
  Widget build(BuildContext context) {
    readQr();

    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff2b9685),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: const Text(
          "Receive an Order",
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
      body: mealsLoaded
          ? QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.orange,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 250,
              ),
            )
          : const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff2b9685))),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
