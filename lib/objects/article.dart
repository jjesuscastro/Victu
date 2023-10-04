// ignore_for_file: unused_field

import 'package:firebase_database/firebase_database.dart';

class Article {
  late DatabaseReference _id;
  String title = "";
  String author = "";
  String body = "";
  String imageURL = "";
  bool completed = false;

  Article(this.title, this.author, this.body, this.imageURL);

  void setId(DatabaseReference id) {
    _id = id;
  }

  String getID() {
    return _id.key!;
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'body': body,
      'imageURL': imageURL,
    };
  }
}

Article createArticle(value) {
  Map<String, dynamic> attributes = {
    'title': '',
    'author': '',
    'body': '',
    'imageURL': '',
    'timeToRead': 0,
  };

  value.forEach((key, value) => {attributes[key] = value});

  Article article = Article(attributes['title'], attributes['author'],
      attributes['body'], attributes['imageURL']);

  return article;
}
