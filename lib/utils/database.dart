import 'package:firebase_database/firebase_database.dart';
import 'package:victu/objects/article.dart';

final databaseReference = FirebaseDatabase.instance.ref();

DatabaseReference saveArticle(Article article) {
  var id = databaseReference.child('articles/').push();
  id.set(article.toJson());

  return id;
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
