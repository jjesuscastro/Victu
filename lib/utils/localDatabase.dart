import 'package:victu/objects/article.dart';
import 'package:victu/objects/meal.dart';
import 'package:victu/objects/order.dart';
import 'package:victu/objects/users/consumer_data.dart';
import 'package:victu/objects/users/farmer_data.dart';
import 'package:victu/objects/users/vendor_data.dart';
import 'package:victu/utils/database.dart';

//Maybe store large data we regularly read
class LocalDB {
  static late List<Order> orders;
  static late List<Meal> meals;
  static late List<Article> articles;
  static late List<FarmerData> farmers;
  static late ConsumerData consumerData;
  static late VendorData vendorData;
  static late FarmerData farmerData;

  static Future<List<Meal>> updateMeals() async {
    LocalDB.meals = await getAllMeals();
    return LocalDB.meals;
  }

  static Future<List<Order>> updateOrders() async {
    LocalDB.orders = await getAllOrders();
    return LocalDB.orders;
  }

  static Future<List<Article>> updateArticles() async {
    LocalDB.articles = await getAllArticles();
    return LocalDB.articles;
  }

  static Future<List<FarmerData>> updateFarmers(String location) async {
    LocalDB.farmers = await getAllFarmers(location);
    return LocalDB.farmers;
  }

  static Future<ConsumerData> updateConsumer(String uid) async {
    LocalDB.consumerData = await getConsumer(uid);
    return LocalDB.consumerData;
  }

  static Future<VendorData> updateVendor(String uid) async {
    LocalDB.vendorData = await getVendor(uid);
    return LocalDB.vendorData;
  }

  static Future<VendorData> updateVendorBySchool(String school) async {
    LocalDB.vendorData = await getAllVendors().then((vendors) {
      return vendors.firstWhere((v) => v.school == school);
    });
    return LocalDB.vendorData;
  }

  static Future<FarmerData> updateFarmer(String uid) async {
    LocalDB.farmerData = await getFarmer(uid);
    return LocalDB.farmerData;
  }
}
