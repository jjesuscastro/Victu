import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:victu/objects/order.dart';
import 'package:victu/objects/users/user_data.dart';
import 'package:victu/utils/database.dart';
import 'package:victu/utils/date_util.dart';
import 'package:victu/utils/local_database.dart';

class UnclaimedOrders extends StatefulWidget {
  final UserData userData;

  const UnclaimedOrders({super.key, required this.userData});

  @override
  State<UnclaimedOrders> createState() => _UnclaimedOrdersState();
}

class _UnclaimedOrdersState extends State<UnclaimedOrders> {
  Map<String, Map<String, int>> unclaimedOrders = {};
  //key: date
  //value: map<string, int>
  //  key: studentName/ID
  //  value: number of unclaimed orders
  List<Order> orders = [];
  bool mealsLoaded = false;
  bool ordersLoaded = false;

  @override
  void initState() {
    super.initState();

    LocalDB.updateVendor(widget.userData.getID()).then((value) => {
          LocalDB.updateMeals().then((value) => {
                LocalDB.updateOrders().then((value) => {
                      setState(() {
                        orders = value
                            .where((order) =>
                                order.vendorID == widget.userData.getID())
                            .toList();

                        organizeOrders();
                      })
                    })
              })
        });
  }

  void organizeOrders() async {
    await Future.forEach(
      orders,
      (element) async {
        var userData = await getUser(element.studentID);
        var studentName = userData.displayName;

        if (!unclaimedOrders.containsKey(element.date)) {
          unclaimedOrders[element.date] = {};
        }

        if (!unclaimedOrders[element.date]!.containsKey(studentName)) {
          unclaimedOrders[element.date]![studentName] = 1;
        } else {
          unclaimedOrders[element.date]![studentName] =
              unclaimedOrders[element.date]![studentName]! + 1;
        }
      },
    );

    setState(() {
      ordersLoaded = true;
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
          "Unclaimed Orders",
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
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 50),
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: unclaimedOrders.length,
                  itemBuilder: (context, index) {
                    return dayCard(
                        context,
                        DateUtil.getWeekdayFromDate(
                            unclaimedOrders.keys.elementAt(index)),
                        unclaimedOrders.keys.elementAt(index),
                        unclaimedOrders.values.elementAt(index));
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget dayCard(
    BuildContext context, String day, String date, Map<String, int> orders) {
  return ExpandableNotifier(
    initialExpanded: false,
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
            padding: const EdgeInsets.fromLTRB(25, 10, 25, 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Table(
                  // border:
                  //     TableBorder.all(width: 1.0, color: Colors.black),
                  children: [
                    const TableRow(
                      children: [
                        TableCell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Student Name",
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 18,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ],
                          ),
                        ),
                        TableCell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Orders",
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 18,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    for (int i = 0; i < orders.length; i++)
                      TableRow(
                        children: [
                          TableCell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  orders.keys.elementAt(i),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TableCell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(orders.values.elementAt(i).toString()),
                              ],
                            ),
                          )
                        ],
                      )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
