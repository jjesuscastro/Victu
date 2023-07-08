///File download from FlutterViz- Drag and drop a tools. For more details visit https://flutterviz.io/

import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

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
          "Menu For The Week",
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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              ListView(
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                children: [
                  Card(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    color: const Color(0xffffffff),
                    shadowColor: const Color(0x4d939393),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      side:
                          const BorderSide(color: Color(0x4d9e9e9e), width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: 65,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Color(0xfff2f2f2),
                              shape: BoxShape.circle,
                            ),
                            child: const Text(
                              "Mon",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                          const Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    "July 10, 2023",
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    color: const Color(0xffffffff),
                    shadowColor: const Color(0x4d939393),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      side:
                          const BorderSide(color: Color(0x4d9e9e9e), width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: 65,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Color(0xfff2f2f2),
                              shape: BoxShape.circle,
                            ),
                            child: const Text(
                              "Tue",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                          const Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    "July 11, 2023",
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    color: const Color(0xffffffff),
                    shadowColor: const Color(0x4d939393),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      side:
                          const BorderSide(color: Color(0x4d9e9e9e), width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: 65,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Color(0xfff2f2f2),
                              shape: BoxShape.circle,
                            ),
                            child: const Text(
                              "Wed",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                          const Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    "July 12, 2023",
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    color: const Color(0xffffffff),
                    shadowColor: const Color(0x4d939393),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      side:
                          const BorderSide(color: Color(0x4d9e9e9e), width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: 65,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Color(0xfff2f2f2),
                              shape: BoxShape.circle,
                            ),
                            child: const Text(
                              "Thu",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                          const Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    "July 13, 2023",
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    color: const Color(0xffffffff),
                    shadowColor: const Color(0x4d939393),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      side:
                          const BorderSide(color: Color(0x4d9e9e9e), width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: 65,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Color(0xfff2f2f2),
                              shape: BoxShape.circle,
                            ),
                            child: const Text(
                              "Fri",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                          const Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    "July 14, 2023",
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    color: const Color(0xffffffff),
                    shadowColor: const Color(0x4d939393),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      side:
                          const BorderSide(color: Color(0x4d9e9e9e), width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: 65,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Color(0xfff2f2f2),
                              shape: BoxShape.circle,
                            ),
                            child: const Text(
                              "Sat",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                          const Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    "July 15, 2023",
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
