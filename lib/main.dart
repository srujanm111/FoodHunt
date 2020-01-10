import 'package:flutter/material.dart';
import 'package:food_hunt/constants.dart';
import 'package:food_hunt/base_page.dart';
import 'package:food_hunt/game_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUp().then((x) {
    runApp(MyApp());
  });
}

Future<void> setUp() async {
  GameManager gameManager = GameManager.instance;
  await gameManager.setUpManager();

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          title: TextStyle(fontSize: 20, color: black),
          subtitle: TextStyle(fontSize: 15, color: black),
          display1: TextStyle(fontSize: 13, color: primary),
          headline: TextStyle(fontSize: 17, color: black, fontWeight: FontWeight.w600),
          caption: TextStyle(fontSize: 13, color: darkGray)
        )
      ),
      home: BasePage(),
    );
  }
}

