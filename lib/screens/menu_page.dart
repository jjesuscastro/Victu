///File download from FlutterViz- Drag and drop a tools. For more details visit https://flutterviz.io/

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
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
          "Menu For The Week",
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
              ListView(
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
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
                            "assets/images/${day.toLowerCase()}.png")),
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
                          Text("Longganisa"),
                          Text("Bacon"),
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
                          Text("Longganisa"),
                          Text("Bacon"),
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
                          Text("Longganisa"),
                          Text("Bacon"),
                        ])),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
