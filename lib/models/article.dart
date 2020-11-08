class Article {
  final String title;
  final String url;
  final String description;
  final String source;
  final String urlToImage;
  final String publishedAt;

  Article(
      {this.title,
      this.description,
      this.urlToImage,
      this.source,
      this.url,
      this.publishedAt});

  factory Article.fromJson(Map<dynamic, dynamic> json) {
    // Iterable list = json['articles'];
    return Article(
        description: json['description'],
        publishedAt: getPublishedAt(json['publishedAt']),
        url: json['url'],
        source: json['source']['name'],
        title: json['title'],
        urlToImage: json['urlToImage']);
  }
}

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
    timeDiff = minutes.toString() + " min ago";
  } else if (minutes > 1 && minutes < 60) {
    timeDiff = minutes.toString() + " mins ago";
  } else if (hours == 1 && days == 0) {
    timeDiff = hours.toString() + " hour ago";
  } else if (hours > 1 && days == 0) {
    timeDiff = hours.toString() + " hours ago";
  } else {
    timeDiff = days.toString() + " days ago";
  }
  print(timeDiff);
  return timeDiff;
}
