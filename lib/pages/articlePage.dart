import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:share/share.dart';

class ArticlePage extends StatefulWidget {
  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  _onShare(BuildContext context, String url) async {
    await Share.share(url);
  }

  @override
  Widget build(BuildContext context) {
    String url = "";
    // String text = "Article link";
    Map data = ModalRoute.of(context).settings.arguments;
    String url_temp = data['url'];
    String site_title = data['site'];
    String location = url_temp.substring(4);
    String header = url_temp.substring(0, 5);
    if (header.contains("https")) {
      url = url_temp;
    } else {
      url = "http" + location;
    }
    print(url);
    return Scaffold(
      // backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          site_title,
          style: Theme.of(context).textTheme.title,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () => _onShare(context, url),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(),
        ],
      ),
    );
  }
}
