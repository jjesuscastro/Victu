import 'package:flutter/material.dart';
import 'package:victu/objects/article.dart';
import 'package:victu/objects/users/user_data.dart';
import 'package:victu/screens/consumer/article_page.dart';
import 'package:victu/utils/database.dart';
import 'package:victu/utils/localDatabase.dart';

class ReadingGoals extends StatefulWidget {
  const ReadingGoals({super.key, required this.userData});

  final UserData userData;

  @override
  State<ReadingGoals> createState() => _ReadingGoalsState();
}

class _ReadingGoalsState extends State<ReadingGoals> {
  bool userLoaded = false;
  bool articlesLoaded = false;

  @override
  void initState() {
    super.initState();

    LocalDB.updateConsumer(widget.userData.getID()).then((value) => {
          setState(() {
            userLoaded = true;
          })
        });

    LocalDB.updateArticles().then((value) => {
          setState(() {
            articlesLoaded = true;
          })
        });
  }

  void openArticle(Article article) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ArticlePage(
                  article: article,
                  userData: widget.userData,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffebebeb),
      appBar: AppBar(
        elevation: 4,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff2b9685),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: const Text(
          "Reading Goals",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            fontSize: 18,
            color: Color(0xffffffff),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                userLoaded
                    ? "Earned Points: ${LocalDB.consumerData.points}"
                    : "Loading Data",
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.clip,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                  color: Color(0xff000000),
                ),
              ),
            ),
          ),
          articlesLoaded
              ? ArticleList(
                  openArticle: openArticle,
                )
              : const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xff2b9685)),
                  ),
                )
        ],
      ),
    );
  }
}

class ArticleList extends StatefulWidget {
  final Function openArticle;
  const ArticleList({super.key, required this.openArticle});

  @override
  State<ArticleList> createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: LocalDB.articles.length,
        itemBuilder: (context, index) {
          var article = LocalDB.articles[index];
          return articleWidget(article, widget.openArticle);
        });
  }
}

Widget articleWidget(Article article, Function openArticle) {
  return Card(
    margin: const EdgeInsets.all(10),
    color: const Color(0xffffffff),
    shadowColor: const Color(0xff000000),
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
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12.0),
              bottomLeft: Radius.circular(12.0)),
          child: Image(
            image: NetworkImage(article.imageURL),
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
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      article.title,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
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
                        const Icon(
                          Icons.person,
                          color: Color(0xff212435),
                          size: 12,
                        ),
                        Text(
                          " ${article.author}",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 12,
                            color: Color.fromARGB(255, 85, 85, 85),
                          ),
                        ),
                      ],
                    ),
                    const Row(
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
                padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    IconButton(
                        icon: const Icon(
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
