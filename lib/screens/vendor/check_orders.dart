import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:victu/objects/meal.dart';
import 'package:victu/objects/order.dart';
import 'package:victu/objects/users/user_data.dart';
import 'package:victu/utils/database.dart';
import 'package:victu/utils/date_util.dart';
import 'package:victu/utils/local_database.dart';
import 'package:victu/utils/time_frames.dart';

class CheckOrders extends StatefulWidget {
  final UserData userData;

  const CheckOrders({super.key, required this.userData});

  @override
  State<CheckOrders> createState() => _CheckOrdersState();
}

class _CheckOrdersState extends State<CheckOrders> {
  List<Order> orders = [];
  bool mealsLoaded = false;
  bool ordersLoaded = false;

  @override
  void initState() {
    super.initState();

    LocalDB.updateVendor(widget.userData.getID()).then((value) => {
          LocalDB.updateMeals().then((value) => {
                LocalDB.updateOrders().then((value) => {
                      orders = value
                          .where((order) =>
                              order.vendorID == widget.userData.getID() &&
                              order.isValid)
                          .toList(),
                      setState(() {
                        mealsLoaded = true;
                        ordersLoaded = true;
                      })
                    })
              })
        });
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              if (mealsLoaded)
                ListView(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 50),
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  children: [
                    dayCard(context, DateUtil.getToday().weekday,
                        DateUtil.getToday().formattedDate, orders),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget dayCard(
    BuildContext context, String day, String date, List<Order> orders) {
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
                MealTime(time: "B", day: day, orders: orders),
                MealTime(time: "L", day: day, orders: orders),
                MealTime(time: "D", day: day, orders: orders)
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class MealTime extends StatefulWidget {
  const MealTime(
      {super.key, required this.time, required this.day, required this.orders});
  final String time;
  final String day;
  final List<Order> orders;
  @override
  State<MealTime> createState() => _MealTimeState();
}

class _MealTimeState extends State<MealTime> {
  bool ordersUpdated = false;
  TextEditingController quantityController = TextEditingController();
  Map<String, int> mealOrders = {};

  String time = "";
  List<String> timeFrames = [];

  @override
  void initState() {
    getTimes();
    getMealOrders();
    super.initState();
  }

  getTimes() {
    time = widget.time == "B"
        ? "Breakfast"
        : widget.time == "L"
            ? "Lunch"
            : "Dinner";
    timeFrames = widget.time == "B"
        ? TimeFrames.breakfastTimes
        : widget.time == "L"
            ? TimeFrames.lunchTimes
            : TimeFrames.dinnerTimes;
  }

  getMealOrders() {
    for (var e in widget.orders) {
      e.orders.forEach((key, value) {
        List<String> oValues = key.split(';');

        if (oValues[0] == widget.time) {
          mealOrders.update(key, (v) => v += value, ifAbsent: () => value);
        }
      });
    }

    setState(() {
      ordersUpdated = true;
    });
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
          Text(time,
              style:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
          const Divider(),
          timeFrameCards(timeFrames, widget.orders),
          Container(height: 25),
          Text("Total Orders for $time:",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const Divider(),
          ordersUpdated
              ? ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: mealOrders.length,
                  itemBuilder: (BuildContext context, int index) {
                    List<String> mealValues =
                        mealOrders.keys.elementAt(index).split(';');

                    Meal? meal;
                    meal = findMeal(mealValues);

                    int servings = int.parse(mealValues[2]);

                    int orders = mealOrders.values.elementAt(index);

                    return MenuEntry(meal, servings, orders);
                  },
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

Map<String, Map<String, int>> getTimeframeOrders(List<Order> orders) {
  Map<String, Map<String, int>> timeFrameOrders = {};

  for (var element in orders) {
    timeFrameOrders["${element.orderNumber} ${element.date}"] = element.orders;
  }

  return timeFrameOrders;
}

Meal findMeal(List<Meal> meals, List<String> mealValues) {
  Meal meal = meals.firstWhere((element) => element.id.key == mealValues[1]);

  return meal;
}

Widget timeFrameCards(List<String> timeFrames, List<Order> orders) {
  List<Order> timeFrameOrders = [];

  return ListView.builder(
    physics: const NeverScrollableScrollPhysics(),
    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    itemCount: timeFrames.length,
    itemBuilder: (BuildContext context, int index) {
      timeFrameOrders = orders
          .where(
              (order) => order.timeFrame == timeFrames[index] && order.isValid)
          .toList();

      Map<String, Map<String, int>> finalOrders =
          getTimeframeOrders(timeFrameOrders);

      return ExpandableNotifier(
        child: Card(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
          color: const Color.fromARGB(255, 186, 238, 229),
          shadowColor: const Color(0x4d939393),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
            side: const BorderSide(color: Color(0xff2b9685), width: 1),
          ),
          child: ScrollOnExpand(
            child: ExpandablePanel(
              header: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            timeFrames[index],
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
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: finalOrders.length,
                      itemBuilder: (BuildContext context, int index) {
                        String orderNumber = finalOrders.keys.elementAt(index);

                        return OrderItems(
                            orderNumber: orderNumber,
                            orderItems: finalOrders.values.elementAt(index));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

class OrderItems extends StatelessWidget {
  const OrderItems(
      {super.key, required this.orderNumber, required this.orderItems});

  final String orderNumber;
  final Map<String, int> orderItems;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Text(
              "Order Number: ",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            Text(orderNumber),
          ]),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: orderItems.length,
            itemBuilder: (BuildContext context, int index) {
              List<String> mealValues =
                  orderItems.keys.elementAt(index).split(';');

              Meal? meal;
              meal = findMeal(LocalDB.meals, mealValues);

              int servings = int.parse(mealValues[2]);

              int orders = orderItems.values.elementAt(index);

              return MenuEntry(meal, servings, orders);
            },
          ),
          const Divider(),
        ]);
  }
}

class MenuEntry extends StatefulWidget {
  const MenuEntry(this.meal, this.servings, this.orders, {super.key});

  final Meal meal;
  final int servings;
  final int orders;

  @override
  State<MenuEntry> createState() => _MenuEntryState();
}

class _MenuEntryState extends State<MenuEntry> {
  bool value = false;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.meal.title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("Orders: ${widget.orders}"),
            if (widget.orders > widget.servings)
              Text("Not enough servings! (${widget.servings})",
                  style: const TextStyle(color: Colors.red))
          ],
        ),
      ),
    ]);
  }
}
