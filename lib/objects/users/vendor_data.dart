// ignore_for_file: unused_field

import 'package:firebase_database/firebase_database.dart';
import 'package:victu/objects/user_type.dart';
import 'package:victu/objects/users/farmer_data.dart';
import 'package:victu/utils/database.dart';

class VendorData extends FarmerData {
  late DatabaseReference _id;
  String school;
  Map<String, Map<String, int>> menus;

  VendorData(
    super.businessName,
    super.displayName,
    super.userType,
    super.location,
    super.contactNumber,
    this.school,
    this.menus, {
    super.isRegistered = false,
    super.isAdmin = false,
  });

  @override
  void setId(DatabaseReference id) {
    _id = id;
  }

  String getID() {
    return _id.key!;
  }

  @override
  void update() {
    if (!menus.containsKey("Monday")) {
      menus["Monday"] = {};
    }

    if (!menus.containsKey("Tuesday")) {
      menus["Tuesday"] = {};
    }

    if (!menus.containsKey("Wednesday")) {
      menus["Wednesday"] = {};
    }

    if (!menus.containsKey("Thursday")) {
      menus["Thursday"] = {};
    }

    if (!menus.containsKey("Friday")) {
      menus["Friday"] = {};
    }

    if (!menus.containsKey("Saturday")) {
      menus["Saturday"] = {};
    }

    updateDatabase(this, _id);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'businessName': businessName,
      'displayName': displayName,
      'userType': userType.toJson(),
      'location': location,
      'contactNumber': contactNumber,
      'school': school,
      'menus': menus,
      'isRegistered': isRegistered,
      'isAdmin': isAdmin,
    };
  }
}

VendorData createVendorData(value) {
  Map<String, dynamic> attributes = {
    'businessName': '',
    'displayName': '',
    'userType': UserType.vendor,
    'location': '',
    'contactNumber': '',
    'school': '',
    'menus': {},
    'isRegistered': false,
    'isAdmin': false,
  };

  value.forEach((key, value) => {attributes[key] = value});

  VendorData userData = VendorData(
    attributes['businessName'],
    attributes['displayName'],
    UserType.fromJson(attributes['userType']),
    attributes['location'],
    attributes['contactNumber'],
    attributes['school'],
    {
      'Monday': attributes['menus']['Monday'].cast<String, int>(),
      'Tuesday': attributes['menus']['Tuesday'].cast<String, int>(),
      'Wednesday': attributes['menus']['Wednesday'].cast<String, int>(),
      'Thursday': attributes['menus']['Thursday'].cast<String, int>(),
      'Friday': attributes['menus']['Friday'].cast<String, int>(),
      'Saturday': attributes['menus']['Saturday'].cast<String, int>(),
    },
    isRegistered: attributes['isRegistered'],
    isAdmin: attributes['isAdmin'],
  );

  return userData;
}
