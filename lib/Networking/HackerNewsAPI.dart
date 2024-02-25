import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news/Models/Article.dart';
import 'package:news/Models/Commentaire.dart';
import 'package:news/Models/SousCommentaire.dart';

class HackerNewsAPI {
  List<int> listTopStories = [];
  List<Article> listArticles = [];
  static List<int> idsCommentaire = [];
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
        if (listTopStories.length == 5) break;
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
        if (listArticles.length == 5) break;
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
    print(idsCommentaire.length);
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

  List<List<int>> listSousCommentIds = [];
  Future<List<List<int>>> getIdSousComments() async {
    print("appell de la methode");
    int i = 0;
    try {
      for (var idSouscomment in idsCommentaire) {
        i++;
        http.Response response = await http.get(Uri.parse(
            "https://hacker-news.firebaseio.com/v0/item/$idSouscomment.json?print=pretty"));
        List<int> ListIdKids = [];
        print("commentaire $i $idSouscomment");
        int j = 0;
        var responseBody = jsonDecode(response.body);
        if (responseBody["kids"] != null) {
          for (var kids in responseBody["kids"]) {
            j++;
            ListIdKids.add(kids);
            print("sous commentaire $j");
          }
        }
        listSousCommentIds.add(ListIdKids);
      }
    } catch (e) {
      print(e);
    }
    return listSousCommentIds;
  }

  Future<List<SousCommentaire>> getSousCommentaires() async {
    List<SousCommentaire> sousCommentairesList = [];
    for (var id in listSousCommentIds) {
      try {
        http.Response response = await http.get(Uri.parse(
            "https://hacker-news.firebaseio.com/v0/item/$id.json?print=pretty"));
        if (response.statusCode == 200) {
          var responseBody = jsonDecode(response.body);
          sousCommentairesList.add(SousCommentaire.FromJson(responseBody));
          //print(listComments.length);
        }
      } catch (e) {
        print(e);
      }
    }
    return sousCommentairesList;
  }
}
