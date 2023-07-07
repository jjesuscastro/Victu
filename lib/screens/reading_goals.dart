///File download from FlutterViz- Drag and drop a tools. For more details visit https://flutterviz.io/

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:victu/objects/article.dart';
import 'package:victu/screens/article_page.dart';
import 'package:victu/utils/database.dart';

class ReadingGoals extends StatefulWidget {
  const ReadingGoals({super.key});

  @override
  State<ReadingGoals> createState() => _ReadingGoalsState();
}

class _ReadingGoalsState extends State<ReadingGoals> {
  List<Article> articles = [];

  @override
  void initState() {
    super.initState();
    // newArticle("title", "body", 5);
    updateArticles();
  }

  void updateArticles() {
    getAllArticles().then((articles) => {
          setState(() {
            this.articles = articles;
          })
        });
  }

  void openArticle(Article article) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ArticlePage(article: article)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffebebeb),
      appBar: AppBar(
        elevation: 4,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff2b9685),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: Text(
          "Reading Goals",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            fontSize: 18,
            color: Color(0xffffffff),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ArticleList(
        articles: articles,
        openArticle: openArticle,
      ),
    );
  }

  void newArticle(String title, String body) {
    var article = Article(title, "Article Author", body);
    article.setId(saveArticle(article));
    setState(() {
      articles.add(article);
    });
  }
}

class ArticleList extends StatefulWidget {
  //For testing
  final Function openArticle;
  const ArticleList(
      {super.key, required this.articles, required this.openArticle});

  final List<Article> articles;

  @override
  State<ArticleList> createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.articles.length,
        itemBuilder: (context, index) {
          var article = widget.articles[index];
          return articleWidget(article, widget.openArticle);
        });
  }
}

Widget articleWidget(Article article, Function openArticle) {
  return Card(
    margin: EdgeInsets.all(10),
    color: Color(0xffffffff),
    shadowColor: Color(0xff000000),
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0),
              bottomLeft: Radius.circular(12.0)),
          child: Image(
            image: NetworkImage(
                "https://upload.wikimedia.org/wikipedia/commons/6/6d/Good_Food_Display_-_NCI_Visuals_Online.jpg"),
            height: 130,
            width: 100,
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      article.title,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xff000000),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.person,
                          color: Color(0xff212435),
                          size: 12,
                        ),
                        Text(
                          " ${article.author}",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 12,
                            color: Color.fromARGB(255, 85, 85, 85),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Color(0xff212435),
                          size: 12,
                        ),
                        Text(
                          " 5 min",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 12,
                            color: Color.fromARGB(255, 85, 85, 85),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.arrow_forward,
                          color: Color(0xff212435),
                          size: 24,
                        ),
                        onPressed: () => openArticle(article)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
