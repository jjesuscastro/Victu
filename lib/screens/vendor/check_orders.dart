import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:victu/objects/meal.dart';
import 'package:victu/objects/users/vendor_data.dart';
import 'package:victu/utils/database.dart';

class CheckOrders extends StatefulWidget {
  final VendorData vendorData;

  const CheckOrders({super.key, required this.vendorData});

  @override
  State<CheckOrders> createState() => _CheckOrdersState();
}

class _CheckOrdersState extends State<CheckOrders> {
  List<Meal> meals = [];
  bool mealsLoaded = false;

  @override
  void initState() {
    super.initState();
    updateMeals();
  }

  void updateMeals() {
    getAllMeals().then((meals) => {
          setState(() {
            this.meals = meals;
            mealsLoaded = true;
          })
        });
  }

  DateTime getMonday() {
    DateTime now = DateTime.now();
    if (now.weekday == 7) now = now.add(const Duration(days: 1));
    DateTime weekStart = now.subtract(Duration(days: (now.weekday - 1)));

    return weekStart;
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
                    dayCard(
                        context,
                        "Monday",
                        DateFormat.yMMMMd().format(getMonday()),
                        meals,
                        widget.vendorData),
                    dayCard(
                        context,
                        "Tuesday",
                        DateFormat.yMMMMd()
                            .format(getMonday().add(const Duration(days: 1))),
                        meals,
                        widget.vendorData),
                    dayCard(
                        context,
                        "Wednesday",
                        DateFormat.yMMMMd()
                            .format(getMonday().add(const Duration(days: 2))),
                        meals,
                        widget.vendorData),
                    dayCard(
                        context,
                        "Thursday",
                        DateFormat.yMMMMd()
                            .format(getMonday().add(const Duration(days: 3))),
                        meals,
                        widget.vendorData),
                    dayCard(
                        context,
                        "Friday",
                        DateFormat.yMMMMd()
                            .format(getMonday().add(const Duration(days: 4))),
                        meals,
                        widget.vendorData),
                    dayCard(
                        context,
                        "Saturday",
                        DateFormat.yMMMMd()
                            .format(getMonday().add(const Duration(days: 5))),
                        meals,
                        widget.vendorData),
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
  bool showDropdown = false;
  TextEditingController quantityController = TextEditingController();
  var currentMeal;

  showMealDropDown(bool value) {
    showDropdown = value;
  }

  Meal findMeal(List<String> mealValues) {
    Meal meal =
        widget.meals.firstWhere((element) => element.id.key == mealValues[1]);

    return meal;
  }

  void saveMeal() {
    int currentOrders = 0;
    String removeKey = '';

    widget.vendorData.menus[widget.day]!.forEach((key, value) {
      if (key.contains("${widget.time};${currentMeal.id.key}")) {
        currentOrders = value;
        removeKey = key;
      }
    });

    if (removeKey.isNotEmpty) {
      widget.vendorData.menus[widget.day]!.remove(removeKey);
    }

    widget.vendorData.menus[widget.day]![
            "${widget.time};${currentMeal.id.key};${int.parse(quantityController.text)}"] =
        currentOrders;

    widget.vendorData.update();
  }

  deleteMeal(String menuKey) {
    setState(() {
      widget.vendorData.menus[widget.day]!.remove(menuKey);

      widget.vendorData.update();
    });
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

                int servings = int.parse(mealValues[2]);

                int orders = widget.vendorData.menus[widget.day]!.values
                    .elementAt(index);

                return MenuEntry(meal, servings, orders);
              }

              return const SizedBox(); //If meal isn't correct time or doesnt exist
            },
          ),
        ],
      ),
    );
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
