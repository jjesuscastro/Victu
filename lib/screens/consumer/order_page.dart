import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:victu/objects/meal.dart';
import 'package:victu/objects/users/consumer_data.dart';
import 'package:victu/objects/users/vendor_data.dart';
import 'package:victu/screens/about_meal.dart';
import 'package:victu/utils/database.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key, required this.consumerData});

  final ConsumerData consumerData;

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<Meal> meals = [];
  late VendorData vendor;
  bool mealsLoaded = false;
  bool vendorLoaded = false;

  @override
  void initState() {
    super.initState();
    updateMeals();
    updateVendor();
  }

  void updateMeals() {
    getAllMeals().then((meals) => {
          setState(() {
            this.meals = meals;
            mealsLoaded = true;
          })
        });
  }

  void updateVendor() {
    getAllVendors().then((vendors) => {
          setState(() {
            vendor = vendors
                .firstWhere((v) => v.school == widget.consumerData.school);
            vendorLoaded = true;
          })
        });
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
                        meals,
                        vendor),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget dayCard(BuildContext context, String day, String date, List<Meal> meals,
    VendorData vendorData) {
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
                    time: "B", day: day, vendorData: vendorData, meals: meals),
                MealTime(
                    time: "L", day: day, vendorData: vendorData, meals: meals),
                MealTime(
                    time: "D", day: day, vendorData: vendorData, meals: meals)
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
      {super.key,
      required this.time,
      required this.day,
      required this.vendorData,
      required this.meals});
  final String time;
  final String day;
  final List<Meal> meals;
  final VendorData vendorData;
  @override
  State<MealTime> createState() => _MealTimeState();
}

class _MealTimeState extends State<MealTime> {
  Meal findMeal(List<String> mealValues) {
    Meal meal =
        widget.meals.firstWhere((element) => element.id.key == mealValues[1]);

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
          Text(
              widget.time == "B"
                  ? "Breakfast"
                  : widget.time == "L"
                      ? "Lunch"
                      : "Dinner",
              style:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
          const Divider(),
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: widget.vendorData.menus[widget.day]!.length,
              itemBuilder: (BuildContext context, int index) {
                List<String> mealValues = widget
                    .vendorData.menus[widget.day]!.keys
                    .elementAt(index)
                    .split(';');

                if (mealValues[0] == widget.time) {
                  Meal? meal;
                  meal = findMeal(mealValues);

                  return MenuEntry(meal);
                }

                return const SizedBox(); //If meal isn't correct time or doesnt exist
              }),
        ],
      ),
    );
  }
}

class MenuEntry extends StatefulWidget {
  const MenuEntry(this.meal, {super.key});

  final Meal meal;

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
          const Text("Qty: ${0}"),
        ],
      )),
      TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        ),
        onPressed: () {},
        child: Padding(
          padding: EdgeInsets.zero,
          child: MaterialButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AboutMeal(meal: widget.meal)),
            ),
            color: const Color(0xff2d9871),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.all(14),
            textColor: const Color(0xffffffff),
            height: 30,
            minWidth: 60,
            child: const Text(
              "About",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}