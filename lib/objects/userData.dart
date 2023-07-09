// ignore_for_file: unused_field

import 'package:firebase_database/firebase_database.dart';

class UserData {
  late DatabaseReference _id;
  String displayName = "";
  bool isRegistered = false;
  bool isMale = true;
  int age = 0;
  int height = 0;
  int weight = 0;

  UserData(this.isRegistered, this.displayName, this.isMale, this.age,
      this.height, this.weight);

  void setId(DatabaseReference id) {
    _id = id;
  }

  Map<String, dynamic> toJson() {
    return {
      'isRegistered': isRegistered,
      'displayName': displayName,
      'isMale': isMale,
      'age': age,
      'height': height,
      'weight': weight,
    };
  }
}

UserData createUserData(value) {
  Map<String, dynamic> attributes = {
    'isRegistered': false,
    'displayName': '',
    'isMale': true,
    'age': 0,
    'height': 0,
    'weight': 0,
  };

  value.forEach((key, value) => {attributes[key] = value});

  UserData userData = UserData(
      attributes['isRegistered'],
      attributes['displayName'],
      attributes['isMale'],
      attributes['age'],
      attributes['height'],
      attributes['weight']);

  return userData;
}
