// ignore_for_file: unused_field

import 'package:firebase_database/firebase_database.dart';
import 'package:victu/objects/ingredient.dart';

class Meal {
  late DatabaseReference _id;
  DatabaseReference get id {
    return _id;
  }

  String title = "";
  String description;
  List<Ingredient> ingredients;
  List<String> recipe;

  Meal(this.title, this.description, this.ingredients, this.recipe);

  void setId(DatabaseReference id) {
    _id = id;
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
      'recipe': recipe,
    };
  }
}

Meal createMeal(value) {
  Map<String, dynamic> attributes = {
    'title': '',
    'description': '',
    'ingredients': <Ingredient>[],
    'recipe': <String>[],
  };

  value.forEach((key, value) => {attributes[key] = value});

  Meal meal = Meal(
    attributes['title'],
    attributes['description'],
    (attributes['ingredients'] as List)
        .map((item) => createIngredient(item))
        .toList(),
    (attributes['recipe'] as List).map((item) => item as String).toList(),
  );

  return meal;
}
