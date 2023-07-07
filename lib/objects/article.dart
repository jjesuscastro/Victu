// ignore_for_file: unused_field

import 'package:firebase_database/firebase_database.dart';

class Article {
  late DatabaseReference _id;
  String title = "";
  String author = "";
  String body = "";

  Article(this.title, this.author, this.body);

  void setId(DatabaseReference id) {
    _id = id;
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'body': body,
    };
  }
}

Article createArticle(value) {
  Map<String, dynamic> attributes = {
    'title': '',
    'author': '',
    'body': '',
    'timeToRead': 0,
  };

  value.forEach((key, value) => {attributes[key] = value});

  Article article =
      Article(attributes['title'], attributes['author'], attributes['body']);

  return article;
}
