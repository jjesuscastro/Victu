import 'package:firebase_database/firebase_database.dart';
import 'package:victu/objects/user_type.dart';
import 'package:victu/objects/users/user_data.dart';
import 'package:victu/utils/database.dart';

class ConsumerData extends UserData {
  late DatabaseReference _id;
  bool isMale = true;
  int age = 0;
  int height = 0;
  int weight = 0;
  int points = 0;
  String vendorID;
  List<String> completedArticles;

  ConsumerData(
    super.displayName,
    super.userType,
    this.isMale,
    this.age,
    this.height,
    this.weight,
    this.points,
    this.vendorID,
    this.completedArticles, {
    super.isRegistered = false,
    super.isAdmin = false,
  });

  @override
  void setId(DatabaseReference id) {
    _id = id;
  }

  @override
  String getID() {
    return _id.key!;
  }

  void update() {
    updateDatabase(this, _id);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'userType': userType.toJson(),
      'isMale': isMale,
      'age': age,
      'height': height,
      'weight': weight,
      'points': points,
      'vendorID': vendorID,
      'completedArticles': completedArticles,
      'isRegistered': isRegistered,
      'isAdmin': isAdmin,
    };
  }
}

ConsumerData createConsumerData(value) {
  Map<String, dynamic> attributes = {
    'displayName': '',
    'userType': UserType.consumer,
    'isMale': true,
    'age': 0,
    'height': 0,
    'weight': 0,
    'points': 0,
    'vendorID': '',
    'completedArticles': '',
    'isRegistered': false,
    'isAdmin': false,
  };

  value.forEach((key, value) => {attributes[key] = value});

  List<String> completedArticles = [];

  try {
    completedArticles = List<String>.from(
        attributes['completedArticles'].map((s) => s.toString()));
  } catch (e) {
    // print(e);
  }

  ConsumerData userData = ConsumerData(
    attributes['displayName'],
    UserType.fromJson(attributes['userType']),
    attributes['isMale'],
    attributes['age'],
    attributes['height'],
    attributes['weight'],
    attributes['points'],
    attributes['vendorID'],
    completedArticles,
    isRegistered: attributes['isRegistered'],
    isAdmin: attributes['isAdmin'],
  );

  return userData;
}
