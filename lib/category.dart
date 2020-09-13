import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share/share.dart';
import 'package:squiz/qn.dart';

import 'package:squiz/question.dart';

//FirebaseFirestore firestore = FirebaseFirestore.instance;

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  var b;
  void link() async {
    b = await Firestore.instance
        .collection("PlaystoreLink")
        .document("Link")
        .get();
  }

  @override
  void initState() {
    link();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(
      context,
      height: 1920, // Optional
      width: 1080, // Optional
      allowFontScaling: true, // Optional
    );
    return ResponsiveWidgets.builder(
      height: 1920, // Optional
      width: 1080, // Optional
      allowFontScaling: true,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: TextResponsive(
            'De Suriname quiz',
            style: TextStyle(
              color: Colors.green,
              fontSize: 100.h,
            ),
          ),
          centerTitle: true,
          // leading: Center(
          //   child: TextResponsive(
          //     'SQUIZ',
          //     style: TextStyle(
          //       color: Colors.green,
          //       fontSize: 80.h,
          //     ),
          //   ),
          // ),
        ),
        body: Column(
          children: <Widget>[
            Container(
              height: 300.h,
              child: Center(
                child: TextResponsive(
                  'SABI DIRI',
                  style: TextStyle(fontSize: 200.h, color: Colors.black),
                ),
              ),
            ),
            StreamBuilder(
                stream: Firestore.instance.collection('Categories').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView(
                    shrinkWrap: true,
                    children: snapshot.data.documents.map(
                      (document) {
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CountDownTimer(document.get('name'))
                                      //  Question(

                                      // )

                                      ));
                            },
                            child: CategoryX(document.get('name')));
                      },
                    ).toList(),
                  );
                })
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () {
            Share.share(
                'Test je kennis over Suriname! https://${b.data()['link']}',
                subject: 'Look what I made!');
          },
          child: CircleAvatar(
            backgroundColor: Colors.green,
            child: Icon(
              Icons.share,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryX extends StatelessWidget {
  final String name;
  CategoryX(this.name);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Container(
        height: 200.h,
        color: Colors.green,
        child: Center(
          child: TextResponsive(
            name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 150.h,
            ),
          ),
        ),
      ),
    );
  }
}
