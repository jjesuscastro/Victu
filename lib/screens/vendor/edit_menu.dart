import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:victu/objects/meal.dart';
import 'package:victu/objects/users/vendor_data.dart';
import 'package:victu/screens/about_meal.dart';
import 'package:victu/screens/vendor/ingredient_summary.dart';
import 'package:victu/utils/database.dart';

class EditMenu extends StatefulWidget {
  final VendorData vendorData;

  const EditMenu({super.key, required this.vendorData});

  @override
  State<EditMenu> createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  List<Meal> meals = [];
  bool mealsLoaded = false;

  @override
  void initState() {
    super.initState();
    getMonday();
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
          "Schedule Recipes",
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
      //? Floating Action Button: Uncomment to add ability to create meals
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => const CreateMeal()),
      //   ),
      //   shape: const CircleBorder(),
      //   backgroundColor: const Color(0xff2d9871),
      //   foregroundColor: Colors.white,
      //   child: const Icon(Icons.add),
      // ),
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                      child: MaterialButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => IngredientSummary(
                                  vendorData: widget.vendorData)),
                        ),
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
                          "Summary of Ingredients",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ),
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

                  return MenuEntry(
                      meal,
                      int.parse(mealValues[2]),
                      deleteMeal,
                      widget.vendorData.menus[widget.day]!.keys
                          .elementAt(index));
                }

                return const SizedBox(); //If meal isn't correct time or doesnt exist
              }),
          showDropdown
              ? Row(children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 10, 0),
                      child: Container(
                        width: 130,
                        height: 50,
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 13),
                        decoration: BoxDecoration(
                          color: const Color(0xffffffff),
                          border: Border.all(
                              color: const Color(0xff2d9871), width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            hint: const Text("Meal"),
                            value: currentMeal,
                            items: widget.meals
                                .map<DropdownMenuItem<Meal>>((Meal value) {
                              return DropdownMenuItem<Meal>(
                                value: value,
                                child: Text(value.title),
                              );
                            }).toList(),
                            style: const TextStyle(
                              color: Color(0xff000000),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                            ),
                            onChanged: (newValue) {
                              setState(() {
                                currentMeal = newValue;
                              });
                            },
                            icon: const Icon(Icons.food_bank),
                            iconSize: 24,
                            iconEnabledColor: const Color(0xff212435),
                            elevation: 8,
                            isExpanded: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 75,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(2, 14, 12, 0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        controller: quantityController,
                        obscureText: false,
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Color(0xff000000),
                        ),
                        decoration: InputDecoration(
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                                color: Color(0xff2d9871), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                                color: Color(0xff2d9871), width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                                color: Color(0xff2d9871), width: 1),
                          ),
                          hintText: "Qty",
                          hintStyle: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xff000000),
                          ),
                          filled: true,
                          fillColor: const Color(0xffffffff),
                          isDense: false,
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 8, 10, 8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 14, 0, 0),
                      child: MaterialButton(
                        onPressed: () {
                          setState(() {
                            showMealDropDown(false);
                          });
                        },
                        color: Colors.red,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.all(0),
                        textColor: const Color(0xffffffff),
                        height: 45,
                        minWidth: MediaQuery.of(context).size.width,
                        child: const Icon(Icons.cancel),
                      ),
                    ),
                  ),
                ])
              : Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                  child: MaterialButton(
                    onPressed: () {
                      setState(() {
                        showMealDropDown(true);
                      });
                    },
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(10),
                    textColor: const Color(0xff2d9871),
                    height: 25,
                    minWidth: MediaQuery.of(context).size.width,
                    child: const Text(
                      "Add Meal",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ),
          if (showDropdown)
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: MaterialButton(
                onPressed: () {
                  setState(() {
                    saveMeal();
                    showMealDropDown(false);
                  });
                },
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(10),
                textColor: const Color(0xff2d9871),
                height: 25,
                minWidth: MediaQuery.of(context).size.width,
                child: const Text(
                  "Save",
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
    );
  }
}

class MenuEntry extends StatefulWidget {
  const MenuEntry(this.meal, this.servings, this.deleteCallback,
      this.deleteCallbackParameter,
      {super.key});

  final Meal meal;
  final int servings;
  final Function deleteCallback;
  final String deleteCallbackParameter;

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
          Text("Servings: ${widget.servings}"),
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
      SizedBox(
        width: 40,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: MaterialButton(
            onPressed: () {
              widget.deleteCallback(widget.deleteCallbackParameter);
            },
            color: Colors.red,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.all(0),
            textColor: const Color(0xffffffff),
            height: 45,
            minWidth: MediaQuery.of(context).size.width,
            child: const Icon(Icons.delete),
          ),
        ),
      ),
    ]);
  }
}
