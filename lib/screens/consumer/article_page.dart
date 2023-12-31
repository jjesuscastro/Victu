import 'package:flutter/material.dart';
import 'package:victu/objects/article.dart';
import 'package:victu/objects/users/user_data.dart';
import 'package:victu/utils/local_database.dart';

class ArticlePage extends StatefulWidget {
  final Article article;
  const ArticlePage({super.key, required this.article, required this.userData});

  final UserData userData;

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage>
    with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    LocalDB.updateConsumer(widget.userData.getID())
        .then((value) => {setState(() {})});

    controller = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].
      vsync: this,
      duration: const Duration(seconds: 300),
    )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          String articleID = widget.article.getID();
          if (!LocalDB.consumerData.completedArticles.contains(articleID)) {
            LocalDB.consumerData.points += 10;
            LocalDB.consumerData.completedArticles.add(articleID);
            LocalDB.consumerData.update();
          }
        }
      })
      ..addListener(() {
        setState(() {});
      });

    controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Stack(
              alignment: Alignment.topLeft,
              children: [
                ///***If you have exported images you must have to copy those images in assets/images directory.
                Image(
                  image: NetworkImage(widget.article.imageURL),
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                Container(
                  margin: const EdgeInsets.all(0),
                  padding: const EdgeInsets.all(0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    color: const Color(0x89000000),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.zero,
                    border:
                        Border.all(color: const Color(0x4d9e9e9e), width: 1),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                        padding: const EdgeInsets.all(0),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xffffffff),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Color(0xff000000),
                            size: 24,
                          ),
                          onPressed: () => setState(() {
                            Navigator.of(context).pop();
                          }),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(80, 0, 0, 0),
                          child: SizedBox(
                            height: 20,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(80, 0, 0, 0),
                                  child: LinearProgressIndicator(
                                      backgroundColor: const Color(0x81808080),
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                              Color(0xff2b9685)),
                                      value: controller.value,
                                      minHeight: 15),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(80, 0, 0, 0),
                                  child: Text(
                                    "${(controller.lastElapsedDuration == null ? 0 : controller.lastElapsedDuration!.inSeconds / 60).floor()} : ${(controller.lastElapsedDuration == null ? 0 : controller.lastElapsedDuration!.inSeconds % 60).toString().padLeft(2, '0')}",
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.clip,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 10,
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                alignment: Alignment.topCenter,
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.65,
                decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: const Color(0x4d9e9e9e), width: 1),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: Text(
                          widget.article.title,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 22,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 16),
                        child: Text(
                          widget.article.author,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xff7c7c7c),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          widget.article.body.replaceAll('\\n', '\n'),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
