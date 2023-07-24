// ignore_for_file: unused_field

import 'package:firebase_database/firebase_database.dart';

class UserData {
  late DatabaseReference _id;
  String displayName = "";
  bool isRegistered = false;

  UserData(this.displayName, {this.isRegistered = false});

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
    'isRegistered': false,
  };

  value.forEach((key, value) => {attributes[key] = value});

  UserData userData = UserData(
    attributes['displayName'],
    isRegistered: attributes['isRegistered'],
  );

  return userData;
}
