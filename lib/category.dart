import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share/share.dart';
import 'package:squiz/qn.dart';
import 'package:firebase_core/firebase_core.dart';

//FirebaseFirestore firestore = FirebaseFirestore.instance;
const String testDevice = 'YOUR_DEVICE_ID';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<Color> coll = [];
  var b;
  static String bannerUnitId = 'ca-app-pub-8475411739576687/8371671855';
  void link() async {
    b = await Firestore.instance
        .collection("PlaystoreLink")
        .document("Link")
        .get();
//    _showDialog();
  }

  static String appId = 'ca-app-pub-8475411739576687~5306524814';
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    childDirected: true,
    nonPersonalizedAds: true,
  );

  BannerAd _bannerAd;

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: 'ca-app-pub-8475411739576687/8371671855',
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }

//ca-app-pub-8475411739576687/2927773486
  @override
  void initState() {
    link();
    super.initState();
    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-8475411739576687~5306524814');
    _bannerAd = createBannerAd()..load();

    _bannerAd ??= createBannerAd();
    _bannerAd
      ..load()
      ..show();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
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
              color: Color(0xff347F3D),
              fontSize: 50,
            ),
          ),
          centerTitle: true,
          //  gradient: LinearGradient(colors: [Colors.red, Colors.yellow]),
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.red, Colors.yellow])),
          child: Column(
            children: <Widget>[
              Container(
                height: 300.h,
                child: Center(
                  child: TextResponsive('SABI DIRI',
                      style: GoogleFonts.hanalei(
                          fontSize: 250.h, color: Colors.black)
//                  TextStyle(fontSize: 250.h,
//
//                      color: Colors.black),
                      ),
                ),
              ),
              StreamBuilder(
                  stream:
                      Firestore.instance.collection('Categories').snapshots(),
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
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xff347F3D),
          onPressed: () {
            Share.share(
                'Test je kennis over Suriname! https://${b.data()['link']}',
                subject: 'Look what I made!');
          },
          child: CircleAvatar(
            backgroundColor: Color(0xff347F3D),
            child: Icon(
              Icons.share,
              color: Colors.white,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
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
        height: 150.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Color(0xff347F3D),
        ),
        child: Center(
          child: TextResponsive(
            name,
            style: TextStyle(
                color: Colors.white,
                fontSize: 150.h,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

// MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
//   keywords: <String>['flutterio', 'beautiful apps'],
//   contentUrl: 'https://flutter.io',
//   birthday: DateTime.now(),
//   childDirected: false,
//   designedForFamilies: false,
//   gender:
//       MobileAdGender.male, // or MobileAdGender.female, MobileAdGender.unknown
//   testDevices: <String>[], // Android emulators are considered test devices
// );

// BannerAd myBanner = BannerAd(
//   // Replace the testAdUnitId with an ad unit id from the AdMob dash.
//   // https://developers.google.com/admob/android/test-ads
//   // https://developers.google.com/admob/ios/test-ads
//   adUnitId: 'ca-app-pub-8475411739576687/8371671855',
//   size: AdSize.smartBanner,
//   targetingInfo: targetingInfo,
//   listener: (MobileAdEvent event) {
//     print("BannerAd event is $event");
//   },
// );

// InterstitialAd myInterstitial = InterstitialAd(
//   // Replace the testAdUnitId with an ad unit id from the AdMob dash.
//   // https://developers.google.com/admob/android/test-ads
//   // https://developers.google.com/admob/ios/test-ads
//   adUnitId: InterstitialAd.testAdUnitId,
//   targetingInfo: targetingInfo,
//   listener: (MobileAdEvent event) {
//     print("InterstitialAd event is $event");
//   },
// );
