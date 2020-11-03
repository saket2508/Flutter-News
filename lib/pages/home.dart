import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sandbox/api/constants.dart';
import 'package:sandbox/widgets/articlesList.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  // Future<List<Article>> futureArticles;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // futureArticles = fetchArticles();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(

            // backgroundColor: Colors.grey[300],
            appBar: AppBar(
              title: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.newspaper,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Flutter News',
                        style: Theme.of(context).textTheme.title,
                      ),
                    )
                  ]),
              actions: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    Navigator.pushNamed(context, '/search');
                  },
                ),
              ],
              bottom: TabBar(
                tabs: [
                  Tab(text: 'Top Stories'),
                  Tab(text: 'World'),
                  Tab(text: 'India'),
                ],
              ),
            ),
            body: TabBarView(children: [
              ArticlesList(
                url: Constants.US_NEWS_URL,
              ),
              ArticlesList(
                url: Constants.WORLD_NEWS_URL,
              ),
              ArticlesList(
                url: Constants.INDIA_NEWS_URL,
              ),
            ])));
  }
}
