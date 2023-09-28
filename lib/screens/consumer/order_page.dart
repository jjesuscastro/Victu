import 'dart:io';
import 'dart:ui' as ui;

import 'package:expandable/expandable.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:victu/objects/meal.dart';
import 'package:victu/objects/order.dart';
import 'package:victu/objects/users/user_data.dart';
import 'package:victu/screens/about_meal.dart';
import 'package:victu/utils/database.dart';
import 'package:victu/utils/localDatabase.dart';
import 'package:victu/utils/qr.dart';
import 'package:victu/utils/time_frames.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key, required this.userData});

  final UserData userData;

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  Map<String, int> allOrders = {};
  bool mealsLoaded = false;
  bool vendorLoaded = false;
  List<String> timeFrames = List<String>.filled(3, "");

  @override
  void initState() {
    super.initState();

    LocalDB.updateConsumer(widget.userData.getID()).then((value) => {
          LocalDB.updateVendor(value.vendorID).then((value) => {
                setState(() {
                  vendorLoaded = true;
                })
              })
        });

    LocalDB.updateMeals().then((value) => {
          setState(() {
            mealsLoaded = true;
          })
        });
  }

  void changeTimeFrame(String time, String timeFrame) {
    switch (time) {
      case "B":
        timeFrames[0] = timeFrame;
        break;
      case "L":
        timeFrames[1] = timeFrame;
        break;
      case "D":
        timeFrames[2] = timeFrame;
        break;
    }
  }

  void placeOrder() async {
    await LocalDB.updateVendor(LocalDB.consumerData.vendorID);
    updateVendorMenu();
    createOrder("B");
  }

  void updateVendorMenu() {
    String day = getTomorrow().keys.elementAt(0);
    int currentOrders = 0;
    allOrders.forEach((key, value) {
      currentOrders = LocalDB.vendorData.menus[day]![key]!;
      currentOrders += value;
      LocalDB.vendorData.menus[day]![key] = currentOrders;
    });

    LocalDB.vendorData.update();
  }

  void createOrder(String time) {
    var qrKey = GlobalKey();
    Map<String, int> orders = Map.fromEntries(
      allOrders.entries.where((entry) => entry.key.split(';')[0] == time),
    );

    if (orders.isNotEmpty) {
      Order order = Order(
          LocalDB.vendorData.getID(),
          widget.userData.getID(),
          DateFormat.yMMMMd().format(getTomorrow().values.elementAt(0)),
          time,
          time == "B"
              ? timeFrames[0]
              : time == "L"
                  ? timeFrames[1]
                  : timeFrames[2],
          true,
          orders);

      order.setId(saveOrder(order));

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          content: SizedBox(
            width: 250,
            height: 325,
            child: Column(children: [
              const Text(
                "Take a screenshot before closing",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 15,
                  color: Color(0xff000000),
                ),
              ),
              const Text(""),
              generateQR(qrKey, order.getID(), time, order)
            ]),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  // Navigator.pop(context);
                  takeScreenShot(qrKey);
                },
                child: const Text("Save Screenshot")),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);

                  if (time == "B") {
                    createOrder("L");
                  } else if (time == "L") {
                    createOrder("D");
                  }
                },
                child: const Text("Close")),
          ],
        ),
      );
    } else {
      if (time == "B") {
        createOrder("L");
      } else if (time == "L") {
        createOrder("D");
      }
    }
  }

  void takeScreenShot(var qrKey) async {
    PermissionStatus res;
    res = await Permission.storage.request();
    if (res.isGranted) {
      final boundary =
          qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      // We can increse the size of QR using pixel ratio
      final image = await boundary.toImage(pixelRatio: 5.0);
      final byteData = await (image.toByteData(format: ui.ImageByteFormat.png));
      if (byteData != null) {
        final pngBytes = byteData.buffer.asUint8List();
        // getting directory of our phone
        final directory = (await getApplicationDocumentsDirectory()).path;
        final imgFile = File(
          '$directory/${DateTime.now()}Victu_Order.png',
        );
        imgFile.writeAsBytes(pngBytes);
        GallerySaver.saveImage(imgFile.path).then((success) async {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Screenshot saved"),
          ));
        });
      }
    }
  }

  Map<String, DateTime> getTomorrow() {
    Map<String, DateTime> tomorrow = {};
    DateTime now = DateTime.now();

    DateTime tmrw = now.add(const Duration(days: 1));
    if (tmrw.weekday == 7) tmrw = now.add(const Duration(days: 1));

    String weekday = getWeekdayString(tmrw.weekday);

    tomorrow[weekday] = tmrw;
    return tomorrow;
  }

  String getWeekdayString(int weekday) {
    switch (weekday) {
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";
      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      case 7:
        return "Sunday";
      default:
        return "";
    }
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
          "Reserve an Order",
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              if (mealsLoaded && vendorLoaded)
                ListView(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 50),
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Here's the menu for tomorrow",
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                    dayCard(
                        context,
                        getTomorrow().keys.elementAt(0),
                        DateFormat.yMMMMd()
                            .format(getTomorrow().values.elementAt(0)),
                        allOrders,
                        changeTimeFrame),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                      child: MaterialButton(
                        onPressed: () => placeOrder(),
                        color: const Color(0xff2d9871),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.all(16),
                        textColor: const Color(0xffffffff),
                        height: 45,
                        minWidth: MediaQuery.of(context).size.width,
                        child: const Text(
                          "Place Order",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget dayCard(BuildContext context, String day, String date,
    Map<String, int> orders, Function(String, String) changeTimeFrame) {
  return ExpandableNotifier(
    initialExpanded: true,
    child: Card(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
      color: const Color(0xffffffff),
      shadowColor: const Color(0x4d939393),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
        side: const BorderSide(color: Color(0x4d9e9e9e), width: 1),
      ),
      child: ScrollOnExpand(
        child: ExpandablePanel(
          header: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Container(
                  width: 80,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(16),
                  child: Image(
                      image: AssetImage(
                          "assets/icons/${day.characters.take(3).toLowerCase()}.png")),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        date,
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          fontSize: 16,
                          color: Color(0xff000000),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          collapsed: Container(),
          expanded: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MealTime(
                    time: "B",
                    day: day,
                    timeRanges: TimeFrames.breakfastTimes,
                    orders: orders,
                    changeTimeFrame: changeTimeFrame),
                MealTime(
                    time: "L",
                    day: day,
                    timeRanges: TimeFrames.lunchTimes,
                    orders: orders,
                    changeTimeFrame: changeTimeFrame),
                MealTime(
                    time: "D",
                    day: day,
                    timeRanges: TimeFrames.dinnerTimes,
                    orders: orders,
                    changeTimeFrame: changeTimeFrame),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class MealTime extends StatefulWidget {
  MealTime(
      {super.key,
      required this.time,
      required this.day,
      required this.timeRanges,
      required this.orders,
      required this.changeTimeFrame});
  final String time;
  final String day;
  final List<String> timeRanges;
  final Map<String, int> orders;
  Function(String, String) changeTimeFrame;
  @override
  State<MealTime> createState() => _MealTimeState();
}

class _MealTimeState extends State<MealTime> {
  var selectedTime;

  @override
  void initState() {
    selectedTime = widget.timeRanges[0];
    widget.changeTimeFrame(widget.time, selectedTime);
    super.initState();
  }

  Meal findMeal(List<String> mealValues) {
    Meal meal =
        LocalDB.meals.firstWhere((element) => element.id.key == mealValues[1]);

    return meal;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  widget.time == "B"
                      ? "Breakfast"
                      : widget.time == "L"
                          ? "Lunch"
                          : "Dinner",
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 20)),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                  width: 190,
                  height: 40,
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 13),
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    border:
                        Border.all(color: const Color(0xff2d9871), width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      hint: const Text("Time"),
                      value: selectedTime,
                      items: widget.timeRanges
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      style: const TextStyle(
                        color: Color(0xff000000),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                      onChanged: (newValue) {
                        setState(
                          () {
                            selectedTime = newValue;
                            widget.changeTimeFrame(widget.time, selectedTime);
                          },
                        );
                      },
                      icon: const Icon(Icons.timer),
                      iconSize: 24,
                      iconEnabledColor: const Color(0xff212435),
                      elevation: 8,
                      isExpanded: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: LocalDB.vendorData.menus[widget.day]!.length,
              itemBuilder: (BuildContext context, int index) {
                //mealValues is a List of String
                //0 = B/L/D time of day the meal is prepared
                //1 = ID of the meal in meals db
                //2 = Quantity of meals prepared
                String mealID =
                    LocalDB.vendorData.menus[widget.day]!.keys.elementAt(index);

                List<String> mealValues = mealID.split(';');

                if (mealValues[0] == widget.time) {
                  Meal? meal;
                  meal = findMeal(mealValues);

                  return MenuEntry(mealID, meal, widget.orders);
                }

                return const SizedBox(); //If meal isn't correct time or doesnt exist
              }),
        ],
      ),
    );
  }
}

class MenuEntry extends StatefulWidget {
  const MenuEntry(this.mealID, this.meal, this.orders, {super.key});

  final String mealID;
  final Meal meal;
  final Map<String, int> orders;

  @override
  State<MenuEntry> createState() => _MenuEntryState();
}

class _MenuEntryState extends State<MenuEntry> {
  bool value = false;
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: Row(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth:
                  150.0, //160 if About is disable, 105 if About is enabled
              maxWidth: 170.0,
            ),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: widget.meal.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AboutMeal(meal: widget.meal)),
                          ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            iconSize: 35,
            icon: const Icon(Icons.arrow_left),
            tooltip: 'Decrease order quantity',
            color: const Color(0xff2b9685),
            onPressed: () {
              setState(() {
                quantity = (quantity - 1).clamp(0, 3);
                if (quantity == 0) {
                  widget.orders.remove(widget.mealID);
                } else {
                  widget.orders[widget.mealID] = quantity;
                }
              });
            },
          ),
          Text("Qty: $quantity"),
          IconButton(
            iconSize: 35,
            icon: const Icon(Icons.arrow_right),
            tooltip: 'Increase order quantity',
            color: const Color(0xff2b9685),
            onPressed: () {
              setState(() {
                quantity = (quantity + 1).clamp(0, 3);

                widget.orders[widget.mealID] = quantity;
              });
            },
          ),
          // MaterialButton(
          //   onPressed: () => Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => AboutMeal(meal: widget.meal)),
          //   ),
          //   color: const Color(0xff2d9871),
          //   elevation: 0,
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(8.0),
          //   ),
          //   padding: const EdgeInsets.all(14),
          //   textColor: const Color(0xffffffff),
          //   height: 30,
          //   minWidth: 60,
          //   child: const Text(
          //     "About",
          //     style: TextStyle(
          //       fontSize: 12,
          //       fontWeight: FontWeight.w700,
          //       fontStyle: FontStyle.normal,
          //     ),
          //   ),
          // ),
        ],
      )),
    ]);
  }
}
