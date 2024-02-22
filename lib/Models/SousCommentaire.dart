import 'package:news/Models/Commentaire.dart';
import 'package:news/Models/Users.dart';

class SousCommentaire {
  late int id;
  late String text;
  late DateTime time;
  late String author;
  late int parent;
  late Users user;
  late Commentaire commentaire;
  late List<SousCommentaire>? kids;
  SousCommentaire(
      {required this.id,
      required this.text,
      required this.time,
      required this.author,
      required this.parent,
      required this.user,
      required this.commentaire,
      this.kids});

  SousCommentaire.FromJson(dynamic jsonData) {
    id = jsonData["id"];
    text = jsonData["text"];
    time = jsonData["time"];
    author = jsonData["by"];
    parent = jsonData["parent"];
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "text": text,
      "time": time,
      "Com_id": commentaire.id,
      "Use_id": user.id,
    };
  }
}
