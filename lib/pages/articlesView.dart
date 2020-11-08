import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sandbox/api/constants.dart';
import 'package:sandbox/widgets/articlesList.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../pages/search.dart';

class ArticlesView extends StatefulWidget {
  ArticlesView({Key key}) : super(key: key);
  @override
  _ArticlesViewState createState() => _ArticlesViewState();
}

class _ArticlesViewState extends State<ArticlesView> {
  final ArticlesList worldNews = ArticlesList(
    url: Constants.US_NEWS_URL,
  );
  final ArticlesList usNews = ArticlesList(
    url: Constants.WORLD_NEWS_URL,
  );
  final ArticlesList indiaNews = ArticlesList(
    url: Constants.INDIA_NEWS_URL,
  );

  @override
  void initState() {
    // TODO: implement initState
    // worldNews = ArticlesList(
    //   url: Constants.WORLD_NEWS_URL,
    // );
    // usNews = ArticlesList(
    //   url: Constants.US_NEWS_URL,
    // );
    // indiaNews = ArticlesList(
    //   url: Constants.INDIA_NEWS_URL,
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(children: [worldNews, usNews, indiaNews]);
  }
}
