import 'dart:async';

import 'package:http/http.dart' as http;

class HackerNewsAPI {
  Future<List<int>?> getTopStories() async {
    try {
      var request = await http
          .get(Uri.parse(
              "https://hacker-news.firebaseio.com/v0/topstories.json"))
          .timeout(Duration(seconds: 10));
      String response = request.body;
      var responseSplited =
          response.substring(1, response.length - 1).split(",");
      List<int> list = [];
      for (var i in responseSplited) {
        list.add(int.parse(i));
      }
      return list;
    } on TimeoutException {
      return [];
    } catch (e) {}
  }
}
