// ignore_for_file: unused_field

import 'package:firebase_database/firebase_database.dart';
import 'package:victu/objects/user_type.dart';
import 'package:victu/objects/users/user_data.dart';

class ConsumerData extends UserData {
  late DatabaseReference _id;
  bool isMale = true;
  int age = 0;
  int height = 0;
  int weight = 0;

  ConsumerData(super.displayName, super.userType, this.isMale, this.age,
      this.height, this.weight,
      {super.isRegistered = false});

  @override
  void setId(DatabaseReference id) {
    _id = id;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'userType': userType.toJson(),
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
    'userType': UserType.consumer,
    'isMale': true,
    'age': 0,
    'height': 0,
    'weight': 0,
    'isRegistered': false,
  };

  value.forEach((key, value) => {attributes[key] = value});

  ConsumerData userData = ConsumerData(
    attributes['displayName'],
    UserType.fromJson(attributes['userType']),
    attributes['isMale'],
    attributes['age'],
    attributes['height'],
    attributes['weight'],
    isRegistered: attributes['isRegistered'],
  );

  return userData;
}
