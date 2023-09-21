// ignore_for_file: unused_field

import 'package:firebase_database/firebase_database.dart';

class Order {
  late DatabaseReference _id;
  DatabaseReference get id {
    return _id;
  }

  String vendorID;
  String studentID;
  String date;
  String time;
  Map<String, int> orders;

  Order(this.vendorID, this.studentID, this.date, this.time, this.orders);

  void setId(DatabaseReference id) {
    _id = id;
  }

  String getID() {
    return _id.key!;
  }

  Map<String, dynamic> toJson() {
    return {
      'vendorID': vendorID,
      'studentID': studentID,
      'date': date,
      'time': time,
      'orders': orders,
    };
  }
}

Order createOrder(value) {
  Map<String, dynamic> attributes = {
    'vendorID': '',
    'studentID': '',
    'date': '',
    'time': '',
    'orders': {},
  };

  value.forEach((key, value) => {attributes[key] = value});

  Order order = Order(
    attributes['vendorID'],
    attributes['studentID'],
    attributes['date'],
    attributes['time'],
    attributes['orders'].cast<String, int>(),
  );

  return order;
}
