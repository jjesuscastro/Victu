// ignore_for_file: unused_field

import 'package:firebase_database/firebase_database.dart';
import 'package:victu/objects/product.dart';
import 'package:victu/objects/user_type.dart';
import 'package:victu/objects/users/user_data.dart';
import 'dart:convert';

import 'package:victu/utils/database.dart';

class FarmerData extends UserData {
  late DatabaseReference _id;
  String contactNumber;
  String location;
  List<Product> products;

  FarmerData(
      super.displayName, super.userType, this.location, this.contactNumber,
      {this.products = const [], super.isRegistered = false});

  @override
  void setId(DatabaseReference id) {
    _id = id;
  }

  void update() {
    updateDatabase(this, _id);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'userType': userType.toJson(),
      'location': location,
      'contactNumber': contactNumber,
      'products': jsonEncode(products),
      'isRegistered': isRegistered,
    };
  }
}

FarmerData createFarmerData(value) {
  Map<String, dynamic> attributes = {
    'displayName': '',
    'userType': UserType.farmer,
    'location': '',
    'contactNumber': '',
    'products': [],
    'isRegistered': false,
  };

  value.forEach((key, value) => {attributes[key] = value});

  FarmerData userData = FarmerData(
    attributes['displayName'],
    UserType.fromJson(attributes['userType']),
    attributes['location'],
    attributes['contactNumber'],
    products: List<Product>.from(
        jsonDecode(attributes['products']).map((i) => createProduct(i))),
    isRegistered: attributes['isRegistered'],
  );

  return userData;
}
