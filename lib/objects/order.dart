// ignore_for_file: unused_field

import 'package:firebase_database/firebase_database.dart';
import 'package:victu/utils/database.dart';

class Order {
  late DatabaseReference _id;
  DatabaseReference get id {
    return _id;
  }

  String vendorID;
  String studentID;
  String orderNumber;
  String date;
  String time;
  String timeFrame;
  bool isValid;
  Map<String, int> orders;

  Order(this.vendorID, this.studentID, this.orderNumber, this.date, this.time,
      this.timeFrame, this.isValid, this.orders);

  void setId(DatabaseReference id) {
    _id = id;
  }

  String getID() {
    return _id.key!;
  }

  void update() {
    updateDatabase(this, _id);
  }

  Map<String, dynamic> toJson() {
    return {
      'vendorID': vendorID,
      'studentID': studentID,
      'orderNumber': orderNumber,
      'date': date,
      'time': time,
      'timeFrame': timeFrame,
      'isvalid': isValid,
      'orders': orders,
    };
  }
}

Order createOrder(value) {
  Map<String, dynamic> attributes = {
    'vendorID': '',
    'studentID': '',
    'orderNumber': '',
    'date': '',
    'time': '',
    'timeFrame': '',
    'isValid': true,
    'orders': {},
  };

  value.forEach((key, value) => {attributes[key] = value});

  Order order = Order(
    attributes['vendorID'],
    attributes['studentID'],
    attributes['orderNumber'],
    attributes['date'],
    attributes['time'],
    attributes['timeFrame'],
    attributes['isValid'],
    attributes['orders'].cast<String, int>(),
  );

  return order;
}
