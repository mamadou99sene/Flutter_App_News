import 'package:news/Models/Commentaire.dart';
import 'package:news/Models/Users.dart';

class SousCommentaire {
  late int id;
  late String text;
  late DateTime time;
  late String author;
  late int parent;
  //late Users user;
  late Commentaire commentaire;
  //late List<SousCommentaire>? kids;
  SousCommentaire({
    required this.id,
    required this.text,
    required this.time,
    required this.author,
    required this.parent,
    //required this.user,
    required this.commentaire,
    // this.kids
  });

  SousCommentaire.FromJson(dynamic jsonData) {
    id = jsonData["id"];
    text = (jsonData["text"] == null ? "" : jsonData["text"]);
    time = DateTime.fromMillisecondsSinceEpoch(jsonData["time"] * 1000,
        isUtc: true);
    parent = jsonData["parent"];
    author = (jsonData["by"] == null ? "" : jsonData["by"]);
  }
  SousCommentaire.FromDB(dynamic dbData) {
    id = dbData["id"];
    text = dbData["text"];
    time =
        DateTime.fromMillisecondsSinceEpoch(dbData["time"] * 1000, isUtc: true);
    author = dbData["Use_id"];
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "text": text,
      "time": time.toUtc().millisecondsSinceEpoch,
      "Com_id": commentaire.id,
      "Use_id": author,
    };
  }
}
