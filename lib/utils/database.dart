import 'package:firebase_database/firebase_database.dart';
import 'package:victu/objects/article.dart';
import 'package:victu/objects/userData.dart';

final databaseReference = FirebaseDatabase.instance.ref();

DatabaseReference saveArticle(Article article) {
  var id = databaseReference.child('articles/').push();
  id.set(article.toJson());

  return id;
}

String saveUser(UserData userData) {
  var id = databaseReference.child('users/');
  id.child(userData.id).set(userData.toJson());

  return userData.id;
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

Future<List<UserData>> getAllUsers() async {
  DataSnapshot dataSnapshot = await databaseReference.child('users/').get();
  List<UserData> users = [];

  if (dataSnapshot.exists) {
    Map<dynamic, dynamic> values = dataSnapshot.value as Map<dynamic, dynamic>;

    values.forEach((key, value) {
      UserData userData = createUserData(value);
      userData.setId(userData.id);

      users.add(userData);
    });
  }

  return users;
}
