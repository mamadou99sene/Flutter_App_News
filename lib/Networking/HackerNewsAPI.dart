import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news/Models/Article.dart';

class HackerNewsAPI {
  List<int> listTopStories = [];
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
      }
      getAllStories();
      return listTopStories;
    } on TimeoutException {
      return [];
    } catch (e) {}
  }

  Future<List<Article>> getAllStories() async {
    List<Article> listArticles = [];
    for (var storieID in listTopStories) {
      var request = await http.get(Uri.parse(
          "https://hacker-news.firebaseio.com/v0/item/${storieID}.json"));
      var response = jsonDecode(request.body);
      listArticles.add(Article.FromJson(response));
    }
    print("nombre d'article ${listArticles.length}");
    return listArticles;
  }
}
