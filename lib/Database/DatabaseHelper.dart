import 'dart:io';
import 'package:news/Models/Etudiant.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  //pour appeler le methode init pour pouvoir initialiser la base
  //de données, il faut creer un getter sur le db; et si le db est
  //null on fait appel a la methode init sinon on retourne null
  late Database _db;

  Database getDB() {
    if (_db == null) {
      init();
    } else {
      return _db;
    }
    return _db;
  }

  init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "news_DB");
    openDatabase(path, version: 1, onCreate: _oncreate);
  }

  _oncreate(Database db, int version) async {
    String request = "CREATE TABLE();";
    await db.execute(request);
  }

  Future<int> insertStories(Etudiant etudiant) async {
    //flushbar
    return await _db.insert("Etudiant", etudiant.etudiantToJson());
  }

  _getAllStories() async {
    var results = _db.query("Table_name");
  }
}
