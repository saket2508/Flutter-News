import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sandbox/api/constants.dart';
import 'package:share/share.dart';

String getPublishedAt(String _datetimeobj) {
  var publishTime = DateTime.parse(_datetimeobj);
  var now = DateTime.now();
  var difference = now.difference(publishTime);
  // print(difference.inMinutes);
  String timeDiff = "";
  var minutes = difference.inMinutes;
  var hours = difference.inHours;
  var days = difference.inDays;
  if (minutes == 0 || minutes == 1) {
    timeDiff = minutes.toString() + "m ago";
  } else if (minutes > 1 && minutes < 60) {
    timeDiff = minutes.toString() + "m ago";
  } else if (hours == 1 && days == 0) {
    timeDiff = hours.toString() + "h ago";
  } else if (hours > 1 && days == 0) {
    timeDiff = hours.toString() + "h ago";
  } else {
    timeDiff = days.toString() + "d ago";
  }
  print(timeDiff);
  return timeDiff;
}

class Article {
  final String title;
  final String url;
  final String description;
  final String source;
  final String urlToImage;
  final String publishedAt;

  List<Article> newsArticles = [];

  Article(
      {this.title,
      this.description,
      this.urlToImage,
      this.source,
      this.url,
      this.publishedAt});

  factory Article.fromJson(Map<dynamic, dynamic> json) {
    Iterable list = json['articles'];
    List<Article> dataArticles = [];
    return Article(
        description: json['description'],
        publishedAt: getPublishedAt(json['publishedAt']),
        url: json['url'],
        source: json['source']['name'],
        title: json['title'],
        urlToImage: json['urlToImage']);
  }
}

Future<List<Article>> fetchArticles(url) async {
  final response = await http.get(url);
  if (response.statusCode == 200) {
    print(json.decode(response.body));
    List jsonResponse = json.decode(response.body)['articles'];
    return jsonResponse.map((item) => new Article.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load articles');
  }
}

class ArticlesList extends StatefulWidget {
  final String url;
  ArticlesList({this.url});

  @override
  _ArticlesListState createState() => _ArticlesListState();
}

class _ArticlesListState extends State<ArticlesList>
    with AutomaticKeepAliveClientMixin<ArticlesList> {
  Future<List<Article>> futureArticles;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureArticles = fetchArticles(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<List<Article>>(
      future: futureArticles,
      //snapshot provides the status of the object being loaded. Once loaded, hasData returns true
      //snapshot.data contains the object
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            child: RefreshIndicator(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 10.0),
                      child: InkWell(
                        onTap: () {
                          print('Card clicked');
                          Navigator.pushNamed(context, '/article', arguments: {
                            'url': snapshot.data[index].url,
                            'site': snapshot.data[index].source
                          });
                        },
                        child: Card(
                          semanticContainer: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 1.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 180,
                                // margin: EdgeInsets.only(bottom: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10)),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: snapshot
                                                    .data[index].urlToImage ==
                                                null
                                            ? AssetImage(Constants
                                                .NEWS_PLACEHOLDER_IMAGE_ASSET_URL)
                                            : NetworkImage(snapshot
                                                .data[index].urlToImage))),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(snapshot.data[index].source,
                                        style: GoogleFonts.openSans(
                                          textStyle: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[600],
                                              fontSize: 16),
                                        )),
                                    Text(snapshot.data[index].publishedAt,
                                        style: GoogleFonts.openSans(
                                          textStyle: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[600],
                                              fontSize: 16),
                                        )),
                                  ],
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4),
                                  child: Text(snapshot.data[index].title,
                                      style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17),
                                      ))),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
              onRefresh: refreshList,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("${snapshot.error}"));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<Null> refreshList() async {
    // futureArticles = fetchArticles();
    // await Future.delayed(Duration(seconds: 2));
    setState(() {
      futureArticles = fetchArticles(widget.url);
    });
    print('refreshed list');
  }
}
