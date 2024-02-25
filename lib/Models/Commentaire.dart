import 'package:news/Models/Article.dart';
import 'package:news/Models/SousCommentaire.dart';
import 'package:news/Models/Users.dart';

class Commentaire {
  late int id;
  late String text;
  late DateTime time;
  late String author;
  late int parent;
  late Article article;
  late Users user;
  late List<SousCommentaire>? kids;
  Commentaire(
      {required this.id,
      required this.text,
      required this.time,
      required this.article,
      required this.parent,
      required this.author,
      required this.user,
      this.kids});

  Commentaire.FromJson(dynamic jsonData) {
    id = jsonData["id"];
    text = (jsonData["text"] == null ? "" : jsonData["text"]);
    time = DateTime.fromMillisecondsSinceEpoch(jsonData["time"] * 1000,
        isUtc: true);
    parent = jsonData["parent"];
    author = (jsonData["by"] == null ? "" : jsonData["by"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "text": text,
      "time": time,
      "Art_id": article.id,
      "Use_id": user.id,
    };
  }
}
