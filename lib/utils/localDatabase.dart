import 'package:victu/objects/article.dart';
import 'package:victu/objects/meal.dart';
import 'package:victu/objects/order.dart';

//Maybe store large data we regularly read
class LocalDB {
  static List<Order> orders = List<Order>.empty(growable: true);
  static List<Meal> meals = List<Meal>.empty(growable: true);
  static List<Article> articles = List<Article>.empty(growable: true);
}
