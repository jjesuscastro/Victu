// ignore_for_file: unused_field

import 'package:firebase_database/firebase_database.dart';
import 'package:victu/objects/user_type.dart';

class UserData {
  late DatabaseReference _id;
  String displayName = "";
  bool isRegistered = false;
  bool isAdmin = false;
  UserType userType = UserType.none;

  UserData(this.displayName, this.userType,
      {this.isRegistered = false, this.isAdmin = false});

  String getID() {
    return _id.key!;
  }

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
    'isAdmin': false,
  };

  value.forEach((key, value) => {attributes[key] = value});

  UserData userData = UserData(
    attributes['displayName'],
    UserType.fromJson(attributes['userType']),
    isRegistered: attributes['isRegistered'],
    isAdmin: attributes['isAdmin'],
  );

  return userData;
}
