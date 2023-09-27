import 'package:victu/objects/meal.dart';
import 'package:victu/objects/order.dart';

class LocalDB {
  static List<Order> orders = List<Order>.empty(growable: true);
  static List<Meal> meals = List<Meal>.empty(growable: true);
}
