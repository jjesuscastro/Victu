///File download from FlutterViz- Drag and drop a tools. For more details visit https://flutterviz.io/

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

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
                  dayCard("Mon", "July 10, 2023"),
                  dayCard("Tue", "July 11, 2023"),
                  dayCard("Wed", "July 12, 2023"),
                  dayCard("Thu", "July 13, 2023"),
                  dayCard("Fri", "July 14, 2023"),
                  dayCard("Sat", "July 15, 2023"),
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
              Container(
                width: 65,
                alignment: Alignment.center,
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xfff2f2f2),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  day,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
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
          collapsed: Container(height: 10),
          expanded: const Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Column(children: [
                  Text("Breakfast"),
                  Text("Longganisa"),
                  Text("Bacon"),
                ]),
                Column(children: [
                  Text("Lunch"),
                  Text("Longganisa"),
                  Text("Bacon"),
                ]),
                Column(children: [
                  Text("Dinner"),
                  Text("Longganisa"),
                  Text("Bacon"),
                ]),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
