// ignore_for_file: unused_field

import 'package:firebase_database/firebase_database.dart';

class Meal {
  late DatabaseReference _id;
  String title = "";
  String description;
  List<String> ingredients;
  List<String> recipe;

  Meal(this.title, this.description, this.ingredients, this.recipe);

  void setId(DatabaseReference id) {
    _id = id;
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'ingredients': ingredients,
      'recipe': recipe,
    };
  }
}

Meal createMeal(value) {
  Map<String, dynamic> attributes = {
    'title': '',
    'description': '',
    'ingredients': {},
    'recipe': {},
  };

  value.forEach((key, value) => {attributes[key] = value});

  Meal meal = Meal(attributes['title'], attributes['description'],
      attributes['ingredients'], attributes['recipe']);

  return meal;
}
