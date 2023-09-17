import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:victu/objects/ingredient.dart';
import 'package:victu/objects/meal.dart';
import 'package:victu/objects/measurement_type.dart';
import 'package:victu/objects/users/vendor_data.dart';
import 'package:victu/screens/vendor/nearby_farmers.dart';
import 'package:victu/utils/database.dart';

class IngredientSummary extends StatefulWidget {
  final VendorData vendorData;

  const IngredientSummary({super.key, required this.vendorData});

  @override
  State<IngredientSummary> createState() => _IngredientSummaryState();
}

class _IngredientSummaryState extends State<IngredientSummary> {
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
          "Summary of Ingredients",
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                      child: MaterialButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NearbyFarmers(
                                  location: widget.vendorData.location)),
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
                          "See Available Local Businesses",
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
  List<Ingredient> getIngredients(Map<String, int> menuEntries) {
    List<Ingredient> ingredientsList = [];
    menuEntries.forEach((key, value) {
      //0 = Time
      //1 = Meal ID
      //2 = Servings
      List<String> keyValues = key.split(';');

      if (keyValues.length == 3) {
        Meal meal =
            meals.firstWhere((element) => element.id.key == keyValues[1]);

        for (var ingredient in meal.ingredients) {
          Ingredient ing = ingredientsList.firstWhere(
              (i) => i.name == ingredient.name,
              orElse: () => Ingredient("None", 0, MeasurementType.g));

          if (ing.name != "None") {
            Ingredient newIngredient = cloneIngredient(ing);
            newIngredient.amount +=
                (ingredient.amount * int.parse(keyValues[2]));
            ingredientsList[ingredientsList
                .indexWhere((i) => i.name == ingredient.name)] = newIngredient;
          } else {
            Ingredient i = cloneIngredient(ingredient);
            i.amount *= int.parse(keyValues[2]);
            ingredientsList.add(i);
          }
        }
      }
    });

    return ingredientsList;
  }

  List<Ingredient> ingredientsList = getIngredients(vendorData.menus[day]!);

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
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: ingredientsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return IngredientEntry(
                          ingredientsList[index].name,
                          ingredientsList[index].amount,
                          ingredientsList[index].measurement);
                    })
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class IngredientEntry extends StatelessWidget {
  const IngredientEntry(this.name, this.amount, this.measurement, {super.key});

  final String name;
  final int amount;
  final MeasurementType measurement;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (measurement == MeasurementType.g && amount >= 1000)
                  Text("Amount: ${amount / 1000}${MeasurementType.kg.toJson()}")
                else
                  Text("Amount: $amount${measurement.toJson()}"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
