import 'package:firebase_database/firebase_database.dart';
import 'package:victu/objects/article.dart';
import 'package:victu/objects/meal.dart';
import 'package:victu/objects/user_type.dart';
import 'package:victu/objects/users/farmer_data.dart';
import 'package:victu/objects/users/user_data.dart';
import 'package:victu/objects/users/vendor_data.dart';

import '../objects/users/consumer_data.dart';

final databaseReference = FirebaseDatabase.instance.ref();

DatabaseReference saveArticle(Article article) {
  var id = databaseReference.child('articles/').push();
  id.set(article.toJson());

  return id;
}

DatabaseReference saveUser(String uid, UserData userData) {
  var id = databaseReference.child('users/');
  id.child(uid).set(userData.toJson());

  return id.child(uid);
}

DatabaseReference saveMeal(Meal meal) {
  var id = databaseReference.child('meals/').push();
  id.set(meal.toJson());

  return id;
}

void updateDatabase(var data, DatabaseReference id) {
  id.update(data.toJson());
}

Future<List<Article>> getAllArticles() async {
  DataSnapshot dataSnapshot = await databaseReference.child('articles/').get();
  List<Article> articles = [];

  if (dataSnapshot.exists) {
    Map<dynamic, dynamic> values = dataSnapshot.value as Map<dynamic, dynamic>;

    values.forEach((key, value) {
      Article article = createArticle(value);
      article.setId(databaseReference.child('articles/$key'));

      articles.add(article);
    });
  }

  return articles;
}

Future<List<Meal>> getAllMeals() async {
  DataSnapshot dataSnapshot = await databaseReference.child('meals/').get();
  List<Meal> meals = [];

  if (dataSnapshot.exists) {
    Map<dynamic, dynamic> values = dataSnapshot.value as Map<dynamic, dynamic>;

    values.forEach((key, value) {
      Meal meal = createMeal(value);
      meal.setId(databaseReference.child('meals/$key'));

      meals.add(meal);
    });
  }

  return meals;
}

Future<UserData> getUser(String uid) async {
  DataSnapshot dataSnapshot = await databaseReference.child('users/$uid').get();

  if (dataSnapshot.exists) {
    Map<dynamic, dynamic> value = dataSnapshot.value as Map<dynamic, dynamic>;

    UserData userData = createUserData(value);
    userData.setId(databaseReference.child('users/$uid'));

    if (!userData.isRegistered) {
      throw Exception("User found but not registered");
    }

    return userData;
  }

  throw Exception("User not found");
}

Future<ConsumerData> getConsumer(String uid) async {
  DataSnapshot dataSnapshot = await databaseReference.child('users/$uid').get();

  if (dataSnapshot.exists) {
    Map<dynamic, dynamic> value = dataSnapshot.value as Map<dynamic, dynamic>;

    ConsumerData consumerData = createConsumerData(value);
    consumerData.setId(databaseReference.child('users/$uid'));

    if (!consumerData.isRegistered) {
      throw Exception("Consumer found but not registered");
    }

    return consumerData;
  }

  throw Exception("Consumer not found");
}

Future<FarmerData> getFarmer(String uid) async {
  DataSnapshot dataSnapshot = await databaseReference.child('users/$uid').get();

  if (dataSnapshot.exists) {
    Map<dynamic, dynamic> value = dataSnapshot.value as Map<dynamic, dynamic>;

    FarmerData farmerData = createFarmerData(value);
    farmerData.setId(databaseReference.child('users/$uid'));

    if (!farmerData.isRegistered) {
      throw Exception("Farmer found but not registered");
    }

    return farmerData;
  }

  throw Exception("Farmer not found");
}

Future<VendorData> getVendor(String uid) async {
  DataSnapshot dataSnapshot = await databaseReference.child('users/$uid').get();

  if (dataSnapshot.exists) {
    Map<dynamic, dynamic> value = dataSnapshot.value as Map<dynamic, dynamic>;

    VendorData vendorData = createVendorData(value);
    vendorData.setId(databaseReference.child('users/$uid'));

    if (!vendorData.isRegistered) {
      throw Exception("Vendor found but not registered");
    }

    return vendorData;
  }

  throw Exception("Vendor not found");
}

Future<List<VendorData>> getAllVendors() async {
  DataSnapshot dataSnapshot = await databaseReference.child('users/').get();
  List<VendorData> vendors = [];

  if (dataSnapshot.exists) {
    Map<dynamic, dynamic> values = dataSnapshot.value as Map<dynamic, dynamic>;

    values.forEach((key, value) {
      UserData userData = createUserData(value);
      if (userData.userType == UserType.vendor) {
        VendorData vendor = createVendorData(value);
        vendor.setId(databaseReference.child('users/$key'));

        vendors.add(vendor);
      }
    });
  }

  return vendors;
}

Future<List<FarmerData>> getAllFarmers(String location) async {
  DataSnapshot dataSnapshot = await databaseReference.child('users/').get();
  List<FarmerData> farmers = [];

  if (dataSnapshot.exists) {
    Map<dynamic, dynamic> values = dataSnapshot.value as Map<dynamic, dynamic>;

    values.forEach((key, value) {
      UserData userData = createUserData(value);
      if (userData.userType == UserType.farmer) {
        FarmerData farmer = createFarmerData(value);
        farmer.setId(databaseReference.child('users/$key'));

        if (location == farmer.location) farmers.add(farmer);
      }
    });
  }

  return farmers;
}
