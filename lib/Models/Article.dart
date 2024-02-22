import 'package:news/Models/Commentaire.dart';
import 'package:news/Models/Users.dart';

class Article {
  late int id;
  late int score;
  late String author;
  late DateTime time;
  late String title;
  late Users user;
  late String type;
  late int nombreCommentaire;
  late List<Commentaire>? kids;

  Article(
      {required this.id,
      required this.score,
      required this.time,
      required this.title,
      required this.user,
      required this.type,
      required this.author,
      required this.nombreCommentaire,
      this.kids});

  Article.FromJson(dynamic jsonData) {
    id = jsonData["id"];
    score = jsonData["score"];
    time = DateTime.fromMillisecondsSinceEpoch(jsonData["time"] * 1000,
        isUtc: true);
    author = jsonData["by"];
    title = jsonData["title"];
    type = jsonData["type"];
    user = Users.FromJson(jsonData["by"]);
    nombreCommentaire = jsonData["descendants"];
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "score": score,
      "time": time,
      "title": title,
      "Use_id": user.id,
    };
  }
}
