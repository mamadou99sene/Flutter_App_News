import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news/Models/Article.dart';

class HackerNewsAPI {
  List<int> listTopStories = [];
  List<Article> listArticles = [];
  Future<List<int>?> getIDTopStories() async {
    try {
      var request = await http
          .get(Uri.parse(
              "https://hacker-news.firebaseio.com/v0/topstories.json"))
          .timeout(Duration(seconds: 10));
      String response = request.body;
      var responseSplited =
          response.substring(1, response.length - 1).split(",");
      for (var i in responseSplited) {
        listTopStories.add(int.parse(i));
        if (listTopStories.length == 10) break;
      }
      return listTopStories;
    } on TimeoutException {
      return [];
    } catch (e) {}
  }

  Future<List<Article>> getAllStories() async {
    await getIDTopStories();
    try {
      for (var storieID in listTopStories) {
        var request = await http.get(Uri.parse(
            "https://hacker-news.firebaseio.com/v0/item/${storieID}.json?print=pretty"));
        var response = jsonDecode(request.body);
        listArticles.add(Article.FromJson(response));
        print("nombre d'article ${listArticles.length}");
        if (listArticles.length == 10) break;
      }
    } catch (e) {
      print(e);
    }
    return listArticles;
  }
}
