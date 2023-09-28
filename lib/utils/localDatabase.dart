import 'package:victu/objects/article.dart';
import 'package:victu/objects/meal.dart';
import 'package:victu/objects/order.dart';
import 'package:victu/objects/users/farmer_data.dart';
import 'package:victu/objects/users/user_data.dart';
import 'package:victu/objects/users/vendor_data.dart';
import 'package:victu/utils/database.dart';

//Maybe store large data we regularly read
class LocalDB {
  static late List<Order> orders;
  static late List<Meal> meals;
  static late List<Article> articles;
  static late List<FarmerData> farmers;
  static late UserData userData;
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

  static Future<UserData> updateUser(String uid) async {
    LocalDB.userData = await getUser(uid);
    return LocalDB.userData;
  }

  static Future<VendorData> updateVendor(String uid) async {
    LocalDB.vendorData = await getVendor(uid);
    return LocalDB.vendorData;
  }

  static Future<FarmerData> updateFarmer(String uid) async {
    LocalDB.farmerData = await getFarmer(uid);
    return LocalDB.farmerData;
  }
}
