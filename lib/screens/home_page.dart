import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:victu/objects/order.dart';
import 'package:victu/objects/user_type.dart';
import 'package:victu/objects/users/user_data.dart';
import 'package:victu/objects/users/vendor_data.dart';
import 'package:victu/screens/admin/create_article.dart';
import 'package:victu/screens/consumer/active_orders.dart';
import 'package:victu/screens/consumer/menu_page.dart';
import 'package:victu/screens/consumer/order_page.dart';
import 'package:victu/screens/consumer/reading_goals.dart';
import 'package:victu/screens/farmer/edit_products.dart';
import 'package:victu/screens/farmer/nearby_vendors.dart';
import 'package:victu/screens/login.dart';
import 'package:victu/screens/vendor/check_orders.dart';
import 'package:victu/screens/admin/create_meal.dart';
import 'package:victu/screens/vendor/edit_menu.dart';
import 'package:victu/screens/vendor/receive_orders.dart';
import 'package:victu/screens/vendor/unclaimed_orders.dart';
import 'package:victu/utils/auth.dart';
import 'package:victu/utils/database.dart';
import 'package:victu/utils/date_util.dart';
import 'package:victu/utils/local_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.user, required this.userData});

  final User user;
  final UserData userData;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool userLoaded = false;

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const Login(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    if (widget.userData.userType == UserType.vendor) {
      LocalDB.updateVendor(widget.userData.getID()).then((userData) => {
            setState(() {
              userLoaded = true;

              validateMenus(userData);
              updateOrders(userData);
            })
          });
    } else {
      userLoaded = true;
    }

    super.initState();
  }

  void validateMenus(VendorData vendorData) {
    DateTime now = DateTime.now();
    DateTime validDate =
        DateFormat("MMMM DD, yyyy").parse(vendorData.validDate);

    if (now.isAfter(validDate)) {
      vendorData.menus.forEach((day, menu) {
        menu.forEach((mealKey, value) {
          vendorData.menus[day]![mealKey] = 0;
          value = 0;
        });
      });

      vendorData.validDate = DateUtil.getDay(7).formattedDate;

      vendorData.update();
    }
  }

  void updateOrders(VendorData vendorData) {
    List<Order> vendorOrders = List<Order>.empty(growable: true);
    getAllOrders().then((orders) => {
          setState(() {
            vendorOrders = orders
                .where((order) => order.vendorID == vendorData.getID())
                .toList();

            validateOrders(vendorData, vendorOrders);
          })
        });
  }

  void validateOrders(VendorData vendorData, List<Order> orders) {
    for (var order in orders) {
      if (DateUtil.checkToday(order.date)) {
        order.isValid = true;
        order.update();
      } else {
        order.isValid = false;
        order.update();
      }
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
          "Victu",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            fontSize: 24,
            color: Color(0xffffffff),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              setState(() {});
              await Authentication.signOut(context: context);
              setState(() {});
              // ignore: use_build_context_synchronously
              Navigator.of(context).pushReplacement(_routeToSignInScreen());
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: Text(
                  "Hello,",
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    fontSize: 24,
                    color: Color(0xff272727),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Text(
                  widget.user.displayName!,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                ),
              ),
              ListView(
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "What would you like to do today?",
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
                  if (userLoaded &&
                      widget.userData.userType == UserType.consumer)
                    ...consumerActionCards(context, widget.userData),
                  if (userLoaded && widget.userData.userType == UserType.farmer)
                    ...farmerActionCards(context, widget.userData),
                  if (userLoaded && widget.userData.userType == UserType.vendor)
                    ...vendorActionCards(context, widget.userData),
                  if (userLoaded && widget.userData.isAdmin)
                    ...adminActionCards(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<Widget> consumerActionCards(BuildContext context, UserData userData) {
  return [
    actionCard(
      "Reading goals",
      const Icon(
        Icons.bookmark_outline,
        color: Color(0xff212435),
        size: 24,
      ),
      () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ReadingGoals(userData: userData)),
      ),
    ),
    actionCard(
      "See menu for the week",
      const Icon(
        Icons.food_bank_outlined,
        color: Color(0xff212435),
        size: 24,
      ),
      () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MenuPage(userData: userData)),
      ),
    ),
    actionCard(
      "Reserve an order",
      const Icon(
        Icons.attach_money,
        color: Color(0xff212435),
        size: 24,
      ),
      () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrderPage(userData: userData)),
      ),
    ),
    actionCard(
      "Active Orders",
      const Icon(
        Icons.bar_chart,
        color: Color(0xff212435),
        size: 24,
      ),
      () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ActiveOrders(userData: userData)),
      ),
    ),
  ];
}

List<Widget> vendorActionCards(BuildContext context, UserData userData) {
  return [
    actionCard(
      "Schedule Recipes",
      const Icon(
        Icons.bookmark_outline,
        color: Color(0xff212435),
        size: 24,
      ),
      () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EditMenu(userData: userData)),
      ),
    ),
    actionCard(
      "Check Orders",
      const Icon(
        Icons.food_bank_outlined,
        color: Color(0xff212435),
        size: 24,
      ),
      () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CheckOrders(userData: userData)),
      ),
    ),
    actionCard(
      "Receive Orders",
      const Icon(
        Icons.bar_chart,
        color: Color(0xff212435),
        size: 24,
      ),
      () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ReceiveOrders(userData: userData)),
      ),
    ),
    actionCard(
      "Unclaimed Orders",
      const Icon(
        Icons.warning,
        color: Color(0xff212435),
        size: 24,
      ),
      () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UnclaimedOrders(userData: userData)),
      ),
    ),
  ];
}

List<Widget> farmerActionCards(BuildContext context, UserData userData) {
  return [
    actionCard(
      "Update Available Products",
      const Icon(
        Icons.bookmark_outline,
        color: Color(0xff212435),
        size: 24,
      ),
      () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditProducts(userData: userData)),
      ),
    ),
    actionCard(
      "See Nearby Canteens",
      const Icon(
        Icons.food_bank_outlined,
        color: Color(0xff212435),
        size: 24,
      ),
      () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NearbyVendors(userData: userData)),
      ),
    ),
  ];
}

List<Widget> adminActionCards(BuildContext context) {
  return [
    actionCard(
        "Create Meal",
        const Icon(
          Icons.food_bank_sharp,
          color: Color(0xff212435),
          size: 24,
        ),
        () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateMeal()),
            )),
    actionCard(
        "Create Article",
        const Icon(
          Icons.article,
          color: Color(0xff212435),
          size: 24,
        ),
        () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateArticle()),
            ))
  ];
}

Widget actionCard(String text, Icon icon, Function action) {
  return InkWell(
    onTap: () => {action()},
    child: Container(
      height: 100,
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: Card(
        color: const Color(0xffffffff),
        shadowColor: const Color(0x4d939393),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: const BorderSide(color: Color(0xff2c9692), width: 2),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                icon,
                Text(
                  "\t\t\t\t$text",
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
