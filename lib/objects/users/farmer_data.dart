// ignore_for_file: unused_field

import 'package:firebase_database/firebase_database.dart';
import 'package:victu/objects/user_type.dart';
import 'package:victu/objects/users/user_data.dart';

class FarmerData extends UserData {
  late DatabaseReference _id;
  String location;

  FarmerData(super.displayName, super.userType, this.location,
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
      'location': location,
      'isRegistered': isRegistered,
    };
  }
}

FarmerData createFarmerData(value) {
  Map<String, dynamic> attributes = {
    'displayName': '',
    'userType': UserType.farmer,
    'location': '',
    'isRegistered': false,
  };

  value.forEach((key, value) => {attributes[key] = value});

  FarmerData userData = FarmerData(
    attributes['displayName'],
    UserType.fromJson(attributes['userType']),
    attributes['location'],
    isRegistered: attributes['isRegistered'],
  );

  return userData;
}
