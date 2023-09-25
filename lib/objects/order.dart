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
  String timeFrame;
  Map<String, int> orders;

  Order(this.vendorID, this.studentID, this.date, this.time, this.timeFrame,
      this.orders);

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
      'timeFrame': timeFrame,
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
    'timeFrame': '',
    'orders': {},
  };

  value.forEach((key, value) => {attributes[key] = value});

  Order order = Order(
    attributes['vendorID'],
    attributes['studentID'],
    attributes['date'],
    attributes['time'],
    attributes['timeFrame'],
    attributes['orders'].cast<String, int>(),
  );

  return order;
}
