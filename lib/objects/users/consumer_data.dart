// ignore_for_file: unused_field

import 'package:firebase_database/firebase_database.dart';
import 'package:victu/objects/users/user_data.dart';

class ConsumerData extends UserData {
  late DatabaseReference _id;
  bool isMale = true;
  int age = 0;
  int height = 0;
  int weight = 0;

  ConsumerData(
      super.displayName, this.isMale, this.age, this.height, this.weight,
      {super.isRegistered = false});

  @override
  void setId(DatabaseReference id) {
    _id = id;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'isMale': isMale,
      'age': age,
      'height': height,
      'weight': weight,
      'isRegistered': isRegistered,
    };
  }
}

ConsumerData createConsumerData(value) {
  Map<String, dynamic> attributes = {
    'displayName': '',
    'isMale': true,
    'age': 0,
    'height': 0,
    'weight': 0,
    'isRegistered': false,
  };

  value.forEach((key, value) => {attributes[key] = value});

  ConsumerData userData = ConsumerData(
    attributes['displayName'],
    attributes['isMale'],
    attributes['age'],
    attributes['height'],
    attributes['weight'],
    isRegistered: attributes['isRegistered'],
  );

  return userData;
}
