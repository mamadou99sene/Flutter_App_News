import 'package:news/Models/Commentaire.dart';
import 'package:news/Models/Users.dart';

class Article {
  late int id;
  late int score;
  late String author;
  late DateTime time;
  late String title;
  //late Users user;
  late String type;
  late int? favoris;
  late int nombreCommentaire;
  //late List<Commentaire>? kids;

  Article(
      {required this.id,
      required this.score,
      required this.time,
      required this.title,
      // required this.user,
      required this.type,
      required this.author,
      required this.nombreCommentaire,
      //this.kids,
      this.favoris});

  Article.FromJson(dynamic jsonData) {
    id = jsonData["id"];
    score = jsonData["score"];
    time = DateTime.fromMillisecondsSinceEpoch(jsonData["time"] * 1000,
        isUtc: true);
    author = jsonData["by"];
    title = jsonData["title"];
    type = jsonData["type"];
    favoris = 0;
    nombreCommentaire =
        (jsonData["descendants"] == null ? 0 : jsonData["descendants"]);
  }
  Article.FromDB(dynamic dbData) {
    id = dbData["id"];
    score = (dbData["score"] == null ? 0 : dbData["score"]);
    time = DateTime.fromMillisecondsSinceEpoch(dbData["time"] * 1000,
        isUtc: true);
    author = dbData["Use_id"];
    title = dbData["title"];
    favoris = dbData["favoris"];
    nombreCommentaire =
        (dbData["descendants"] == null ? 0 : dbData["descendants"]);
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "score": score,
      "time": time.toUtc().millisecondsSinceEpoch,
      "title": title,
      "Use_id": author,
      "descendants": nombreCommentaire,
      "favoris": (favoris==null ? 0 : favoris)
    };
  }
}
