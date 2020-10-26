import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/articlesList.dart';
import 'dart:async';
import 'package:sandbox/api/constants.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String _result;
  final myController = TextEditingController();
  String query = "";
  bool _validate = false;
  bool _error = false;
  bool _loading = false;
  Future<List<Article>> futureArticles;
  // Widget _articles = Container();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
  }

  void getData() async {
    String url = "";
    String day = '';
    String yday = '';
    String mon = '';
    var now = DateTime.now();
    var year = now.year.toString();
    var month = now.month;
    var prev = now.day - 1;
    if (prev < 10) {
      yday = '0' + prev.toString();
    } else {
      yday = prev.toString();
    }
    if (now.day < 10) {
      day = '0' + now.day.toString();
    } else {
      day = now.day.toString();
    }
    if (month < 10) {
      mon = '0' + month.toString();
    } else {
      mon = month.toString();
    }
    if (query.toLowerCase() == "bbc") {
      url =
          "https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=d070d9891fc84f519e55c9a7b4577a2e";
    } else if (query.toLowerCase() == "cnn") {
      url =
          "https://newsapi.org/v2/top-headlines?sources=cnn&apiKey=d070d9891fc84f519e55c9a7b4577a2e";
    } else if (query.toLowerCase() == "reuters") {
      url =
          "https://newsapi.org/v2/top-headlines?sources=reuters&apiKey=d070d9891fc84f519e55c9a7b4577a2e";
    } else if (query.toLowerCase() == "al jazeera") {
      url =
          "https://newsapi.org/v2/top-headlines?sources=al-jazeera-english&apiKey=d070d9891fc84f519e55c9a7b4577a2e";
    } else {
      url = "https://newsapi.org/v2/top-headlines?q=" +
          query +
          "&from=${year}-${mon}-${day}&to=${year}-${mon}-${day}&sortBy=popularity&apiKey=d070d9891fc84f519e55c9a7b4577a2e";
      print(url);
    }
    setState(() {
      futureArticles = fetchArticles(url);
    });
  }

  void searchQuery(String value) {
    if (value == "") {
      setState(() {
        _validate = true;
      });
    } else {
      if (_validate) {
        setState(() {
          _validate = false;
        });
      }
      print(value);
      setState(() {
        query = value;
      });
      getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Search',
          style: Theme.of(context).textTheme.title,
        ),
        actions: [],
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
              child: TextField(
                controller: myController,
                autocorrect: true,
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  color: Colors.grey[800],
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'Search',
                  helperText: 'Search any country, topic or news source',
                  errorText: _validate ? 'Error: Search can\'t be empty' : null,
                  helperStyle: TextStyle(fontStyle: FontStyle.italic),
                  errorStyle: TextStyle(fontStyle: FontStyle.italic),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                      // color: Colors.red
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                      // color: Colors.
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                      // color: Colors.blueGrey
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                // onChanged: onQueryChange,
                onSubmitted: searchQuery,
              ),
            ),
            futureArticles == null || _error
                ? Container(
                    child: _error
                        ? Text('Could not find articles matching ' + query)
                        : Text(''),
                  )
                : Expanded(
                    child: FutureBuilder<List<Article>>(
                      future: futureArticles,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return (ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 10.0),
                                  child: InkWell(
                                    onTap: () {
                                      print('Card clicked');
                                      Navigator.pushNamed(context, '/article',
                                          arguments: {
                                            'url': snapshot.data[index].url,
                                            'site': snapshot.data[index].source
                                          });
                                    },
                                    child: Card(
                                      semanticContainer: true,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      elevation: 2.0,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 200,
                                            // margin: EdgeInsets.only(bottom: 5),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10)),
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: snapshot.data[index]
                                                                .urlToImage ==
                                                            null
                                                        ? AssetImage(Constants
                                                            .NEWS_PLACEHOLDER_IMAGE_ASSET_URL)
                                                        : NetworkImage(
                                                            snapshot.data[index]
                                                                .urlToImage,
                                                          ))),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    snapshot.data[index].source,
                                                    style: GoogleFonts.openSans(
                                                      textStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              Colors.grey[600],
                                                          fontSize: 18),
                                                    )),
                                                Text(
                                                    snapshot.data[index]
                                                        .publishedAt,
                                                    style: GoogleFonts.openSans(
                                                      textStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              Colors.grey[600],
                                                          fontSize: 18),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 4),
                                              child: Text(
                                                  snapshot.data[index].title,
                                                  style: GoogleFonts.openSans(
                                                    textStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 18),
                                                  ))),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }));
                        } else if (snapshot.hasError) {
                          return Center(child: Text("${snapshot.error}"));
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
