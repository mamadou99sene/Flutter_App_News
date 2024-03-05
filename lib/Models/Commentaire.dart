import 'package:news/Models/Article.dart';
import 'package:news/Models/SousCommentaire.dart';
import 'package:news/Models/Users.dart';

class Commentaire {
  late int id;
  late String text;
  late DateTime time;
  late String author;
  late Article article;
  //late Users user;
  //late List<SousCommentaire>? kids;
  Commentaire({
    required this.id,
    required this.text,
    required this.time,
    required this.article,
    required this.author,
    // required this.user,
    //this.kids
  });

  Commentaire.FromJson(dynamic jsonData) {
    id = jsonData["id"];
    text = (jsonData["text"] == null ? "" : jsonData["text"]);
    time = DateTime.fromMillisecondsSinceEpoch(jsonData["time"] * 1000,
        isUtc: true);
    author = (jsonData["by"] == null ? "" : jsonData["by"]);
  }
  Commentaire.FromDB(dynamic dbData) {
    id = dbData["id"];
    text = dbData["text"];
    time = DateTime.fromMillisecondsSinceEpoch(dbData["time"] * 1000,
        isUtc: true);
    author = dbData["Use_id"];
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "text": text,
      "time": time.toUtc().millisecondsSinceEpoch,
      "Art_id": article.id,
      "Use_id": author
    };
  }
}
