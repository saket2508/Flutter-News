import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:sandbox/pages/home.dart';
import './pages/home.dart';
import './pages/articlePage.dart';
import './pages/search.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => MyHomePage(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/article': (context) => ArticlePage(),
        '/search': (context) => Search(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          appBarTheme: AppBarTheme(color: Colors.redAccent),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          accentColor: Colors.redAccent,
          textTheme: TextTheme(
            title: GoogleFonts.openSans(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.white)),
          )),
    );
  }
}
