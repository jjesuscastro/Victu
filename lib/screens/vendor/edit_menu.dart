///File download from FlutterViz- Drag and drop a tools. For more details visit https://flutterviz.io/

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:victu/screens/about_meal.dart';
import 'package:victu/screens/vendor/create_meal.dart';

class EditMenu extends StatefulWidget {
  const EditMenu({super.key});

  @override
  State<EditMenu> createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  @override
  void initState() {
    super.initState();
    getMonday();
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateMeal()),
        ),
        shape: const CircleBorder(),
        backgroundColor: const Color(0xff2d9871),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              ListView(
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 50),
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                children: [
                  dayCard("Mon", DateFormat.yMMMMd().format(getMonday())),
                  dayCard(
                      "Tue",
                      DateFormat.yMMMMd()
                          .format(getMonday().add(const Duration(days: 1)))),
                  dayCard(
                      "Wed",
                      DateFormat.yMMMMd()
                          .format(getMonday().add(const Duration(days: 2)))),
                  dayCard(
                      "Thu",
                      DateFormat.yMMMMd()
                          .format(getMonday().add(const Duration(days: 3)))),
                  dayCard(
                      "Fri",
                      DateFormat.yMMMMd()
                          .format(getMonday().add(const Duration(days: 4)))),
                  dayCard(
                      "Sat",
                      DateFormat.yMMMMd()
                          .format(getMonday().add(const Duration(days: 5)))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget dayCard(String day, String date) {
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
                            "assets/icons/${day.toLowerCase()}.png")),
                  )),
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
          expanded: const Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Breakfast",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20)),
                          Divider(),
                          MenuEntry("Longganisa w/ Rice", 20),
                          MenuEntry("Corned Beef w/ Rice", 20),
                          MenuEntry("Bacon & Eggs", 10),
                        ])),
                Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Lunch",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20)),
                          Divider(),
                          MenuEntry("Sinigang w/ Rice", 30),
                          MenuEntry("Tapa w/ Rice", 30),
                          MenuEntry("Lumpia w/ Rice", 50),
                        ])),
                Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Dinner",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20)),
                          Divider(),
                          MenuEntry("Fried Chicken w/ Rice", 80),
                        ])),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class MenuEntry extends StatefulWidget {
  const MenuEntry(this.entryName, this.servings, {super.key});

  final String entryName;
  final int servings;

  @override
  State<MenuEntry> createState() => _MenuEntryState();
}

class _MenuEntryState extends State<MenuEntry> {
  bool value = false;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Checkbox(
        value: value,
        onChanged: (value) {
          setState(() {
            this.value = value!;
          });
        },
      ),
      Expanded(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.entryName,
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
              MaterialPageRoute(builder: (context) => const AboutMeal()),
            ),
            color: const Color(0xff2d9871),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.all(5),
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
      )
    ]);
  }
}
