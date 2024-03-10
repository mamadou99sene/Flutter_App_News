import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news/Models/Article.dart';
import 'package:news/Models/Commentaire.dart';
import 'package:news/Models/SousCommentaire.dart';

class HackerNewsAPI {
  List<int> listTopStories = [];
  List<Article> listArticles = [];
  List<int> idsCommentaire = [];
  List<Commentaire> listComments = [];
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
        if (listTopStories.length == 20) break;
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
        if (listArticles.length == 20) break;
      }
    } catch (e) {
      print(e);
    }
    return listArticles;
  }

  Future<List<int>> getIdsCommentaireByArticle(int idArticle) async {
    http.Response response = await http
        .get(Uri.parse(
            "https://hacker-news.firebaseio.com/v0/item/$idArticle.json?print=pretty"))
        .timeout(Duration(seconds: 10));
    var responseBody = jsonDecode(response.body);
    for (var id in responseBody["kids"]) {
      idsCommentaire.add(id);
    }
    return idsCommentaire;
  }

  Future<List<Commentaire>> getCommentsBeforeRecoverIds(int idArticle) async {
    await getIdsCommentaireByArticle(idArticle);
    print("${idsCommentaire.length} commentaires");
    for (var id in idsCommentaire) {
      try {
        http.Response response = await http.get(Uri.parse(
            "https://hacker-news.firebaseio.com/v0/item/$id.json?print=pretty"));
        if (response.statusCode == 200) {
          var responseBody = jsonDecode(response.body);
          listComments.add(Commentaire.FromJson(responseBody));
          //print(listComments.length);
        }
      } catch (e) {
        print(e);
      }
    }
    return listComments;
  }

  List<int> listSousCommentIds = [];
  Future<List<int>> getIdSousComments(int idCommentaire) async {
    try {
      http.Response response = await http.get(Uri.parse(
          "https://hacker-news.firebaseio.com/v0/item/$idCommentaire.json?print=pretty"));
      int j = 0;
      var responseBody = jsonDecode(response.body);
      if (responseBody["kids"] != null) {
        for (var kid in responseBody["kids"]) {
          j++;
          listSousCommentIds.add(kid);
          print("sous commentaire $j");
        }
      }
    } catch (e) {
      print(e);
    }
    return listSousCommentIds;
  }

  List<SousCommentaire> sousCommentairesList = [];
  Future<List<SousCommentaire>> getSousCommentaires(int idCommentaire) async {
    await getIdSousComments(idCommentaire);
    for (var id in listSousCommentIds) {
      try {
        http.Response response = await http
            .get(Uri.parse(
                "https://hacker-news.firebaseio.com/v0/item/$id.json?print=pretty"))
            .timeout(Duration(seconds: 10));
        if (response.statusCode == 200) {
          var responseBody = jsonDecode(response.body);

          sousCommentairesList.add(SousCommentaire.FromJson(responseBody));
        }
      } catch (e) {
        print(e);
      }
    }
    print("${sousCommentairesList.length} sous commentaire");
    return sousCommentairesList;
  }
}
