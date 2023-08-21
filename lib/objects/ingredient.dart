import 'package:victu/objects/measurement_type.dart';

class Ingredient {
  String name;
  int amount;
  MeasurementType measurement;

  Ingredient(this.name, this.amount, this.measurement);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'measurement': measurement.toJson(),
    };
  }
}

Ingredient createIngredient(value) {
  Map<String, dynamic> attributes = {
    'name': '',
    'amount': 0,
    'measurement': MeasurementType.pcs,
  };

  value.forEach((key, value) => {attributes[key] = value});

  Ingredient ingredient = Ingredient(
    attributes['name'],
    attributes['amount'],
    MeasurementType.fromJson(attributes['measurement']),
  );

  return ingredient;
}

Ingredient cloneIngredient(Ingredient oldIngredient) {
  return Ingredient(
      oldIngredient.name, oldIngredient.amount, oldIngredient.measurement);
}
