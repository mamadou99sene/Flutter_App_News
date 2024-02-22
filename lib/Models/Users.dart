import 'package:news/Models/Commentaire.dart';

class Users {
  late String id;
  late DateTime created;
  late int karma;
  late String about;
  late List<Commentaire>? submitted;

  Users(
      {required this.id,
      required this.created,
      required this.karma,
      required this.about,
      this.submitted});

  Users.FromJson(dynamic jsonData) {
    id = jsonData["id"];
    created = jsonData["created"];
    karma = jsonData["karma"];
    about = jsonData["about"];
    submitted = jsonData["submitted"];
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "created": created, "karma": karma, "about": about};
  }
}
