import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:squiz/category.dart';
import 'package:squiz/loading_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(
      context,
      height: 1920, // Optional
      width: 1080, // Optional
      allowFontScaling: true,
    );
    return MaterialApp(initialRoute: 'Category', routes: {
      'Category': (context) => LoadingScreen(),
      'gg': (context) => Category(),
    });
  }
}
