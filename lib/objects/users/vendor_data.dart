// ignore_for_file: unused_field

import 'package:firebase_database/firebase_database.dart';
import 'package:victu/objects/user_type.dart';
import 'package:victu/objects/users/farmer_data.dart';

class VendorData extends FarmerData {
  late DatabaseReference _id;
  String canteenName;
  String contactNumber;
  String school;

  VendorData(super.displayName, super.userType, super.location,
      this.canteenName, this.contactNumber, this.school,
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
      'canteenName': canteenName,
      'contactNumber': contactNumber,
      'school': school,
      'isRegistered': isRegistered,
    };
  }
}

VendorData createVendorData(value) {
  Map<String, dynamic> attributes = {
    'displayName': '',
    'userType': UserType.vendor,
    'location': '',
    'canteenName': '',
    'contactNumber': '',
    'school': '',
    'isRegistered': false,
  };

  value.forEach((key, value) => {attributes[key] = value});

  VendorData userData = VendorData(
    attributes['displayName'],
    UserType.fromJson(attributes['userType']),
    attributes['location'],
    attributes['canteenName'],
    attributes['contactNumber'],
    attributes['school'],
    isRegistered: attributes['isRegistered'],
  );

  return userData;
}
