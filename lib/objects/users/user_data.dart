// ignore_for_file: unused_field

import 'package:firebase_database/firebase_database.dart';
import 'package:victu/objects/user_type.dart';

class UserData {
  late DatabaseReference _id;
  String displayName = "";
  bool isRegistered = false;
  UserType userType = UserType.none;

  UserData(this.displayName, this.userType, {this.isRegistered = false});

  void setId(DatabaseReference id) {
    _id = id;
  }

  Map<String, dynamic> toJson() {
    throw Exception('FunctionNotOverriden');
  }
}

UserData createUserData(value) {
  Map<String, dynamic> attributes = {
    'displayName': '',
    'userType': UserType.none,
    'isRegistered': false,
  };

  value.forEach((key, value) => {attributes[key] = value});

  UserData userData = UserData(
    attributes['displayName'],
    UserType.fromJson(attributes['userType']),
    isRegistered: attributes['isRegistered'],
  );

  return userData;
}
