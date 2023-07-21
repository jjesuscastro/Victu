// ignore_for_file: unused_field

import 'package:firebase_database/firebase_database.dart';

class UserData {
  late DatabaseReference _id;
  String type = "";
  String displayName = "";
  bool isRegistered = false;
  bool isMale = true;
  int age = 0;
  int height = 0;
  int weight = 0;

  UserData(this.displayName, this.isMale, this.age, this.height, this.weight,
      {this.isRegistered = false, this.type = ""});

  void setId(DatabaseReference id) {
    _id = id;
  }

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'isMale': isMale,
      'age': age,
      'height': height,
      'weight': weight,
      'isRegistered': isRegistered,
      'type': type,
    };
  }
}

UserData createUserData(value) {
  Map<String, dynamic> attributes = {
    'displayName': '',
    'isMale': true,
    'age': 0,
    'height': 0,
    'weight': 0,
    'isRegistered': false,
    'type': ''
  };

  value.forEach((key, value) => {attributes[key] = value});

  UserData userData = UserData(attributes['displayName'], attributes['isMale'],
      attributes['age'], attributes['height'], attributes['weight'],
      isRegistered: attributes['isRegistered'], type: attributes['type']);

  return userData;
}
