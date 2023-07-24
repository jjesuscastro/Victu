// ignore_for_file: unused_field

import 'package:firebase_database/firebase_database.dart';
import 'package:victu/objects/users/user_data.dart';

class FarmerData extends UserData {
  late DatabaseReference _id;
  String location;

  FarmerData(super.displayName, this.location, {super.isRegistered = false});

  @override
  void setId(DatabaseReference id) {
    _id = id;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'location': location,
      'isRegistered': isRegistered,
    };
  }
}

FarmerData createFarmerData(value) {
  Map<String, dynamic> attributes = {
    'displayName': '',
    'location': '',
    'isRegistered': false,
  };

  value.forEach((key, value) => {attributes[key] = value});

  FarmerData userData = FarmerData(
    attributes['displayName'],
    attributes['location'],
    isRegistered: attributes['isRegistered'],
  );

  return userData;
}
