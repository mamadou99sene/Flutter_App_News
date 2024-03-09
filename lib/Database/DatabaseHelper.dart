import 'dart:io';
import 'package:news/Models/Article.dart';
import 'package:news/Models/Commentaire.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../Models/SousCommentaire.dart';

class DatabaseHelper {
  //pour appeler le methode init pour pouvoir initialiser la base
  //de données, il faut creer un getter sur le db; et si le db est
  //null on fait appel a la methode init sinon on retourne null

  Future<Database> getDB() async {
    Database _db;
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "news_DB.db");
    _db = await openDatabase(path, version: 1, onCreate: _oncreate);
    return _db;
  }

  _oncreate(Database db, int version) async {
    String request1 =
        "create table Users(id varchar(254) not null, primary key (id));";
    String request2 =
        "create table Article( id INTEGER not null, Use_id varchar(254) not null, score INTEGER, time INTEGER, title varchar(254), type varchar(254), favoris INTEGER, descendants INTEGER, primary key (id));";
    String request3 =
        "create table Commentaire( id INTEGER not null, Art_id INTEGER not null, Use_id varchar(254) not null, text varchar(254), time INTEGER, primary key (id));";
    String request4 =
        "create table SousCommentaire( id INTEGER not null, Com_id INTEGER not null, Use_id varchar(254) not null, text varchar(254), time INTEGER, primary key (id));";

    await db.execute(request1);
    await db.execute(request2);
    await db.execute(request3);
    await db.execute(request4);
    String foreign_request1 =
        "ALTER TABLE Article ADD CONSTRAINT FK_submitted FOREIGN KEY (Use_id) REFERENCES Users (id) ON DELETE RESTRICT ON UPDATE RESTRICT";

    String foreign_request2 =
        "ALTER TABLE Commentaire ADD CONSTRAINT FK_effectuer FOREIGN KEY (Use_id) REFERENCES Users (id) ON DELETE RESTRICT ON UPDATE RESTRICT";

    String foreign_request3 =
        "ALTER TABLE Commentaire ADD CONSTRAINT FK_kids FOREIGN KEY (Art_id) REFERENCES Article (id) ON DELETE RESTRICT ON UPDATE RESTRICT";

    String foreign_request4 =
        "ALTER TABLE SousCommentaire ADD CONSTRAINT FK_kids FOREIGN KEY (Com_id) REFERENCES Commentaire (id) ON DELETE RESTRICT ON UPDATE RESTRICT";

    String foreign_request5 =
        "ALTER TABLE SousCommentaire ADD CONSTRAINT FK_submitted FOREIGN KEY (Use_id) REFERENCES Users (id) ON DELETE RESTRICT ON UPDATE RESTRICT";

    try {
      await db.transaction((txn) async {
        await txn.execute(foreign_request1);
        await txn.execute(foreign_request2);
        await txn.execute(foreign_request3);
        await txn.execute(foreign_request4);
        await txn.execute(foreign_request5);
      });
      print("Contraintes FOREIGN KEY ajoutées avec succès");
    } catch (e) {
      print("Erreur lors de l'ajout des contraintes FOREIGN KEY");
      print(e);
    }
    print("Creation des tables effectuée");
  }

  Future<int> insertStories(Article article) async {
    //flushbar
    Database _db = await getDB();
    return await _db.insert("Article", article.toJson());
  }

  Future<List<Article>> getAllStories() async {
    Database _db = await getDB();
    final List<Map<String, dynamic>> results = await _db.query('Article');
    return results.map((map) => Article.FromDB(map)).toList();
  }

  Future<int> UpdateStorie(Article article) async {
    Database _db = await getDB();
    return await _db.update("Article", article.toJson(),
        where: 'id = ?', whereArgs: [article.id]);
  }

  Future<int> deleteStorie(Article article) async {
    Database _db = await getDB();
    return _db.delete("Article", where: 'id = ?', whereArgs: [article.id]);
  }

  Future<List<Commentaire>> getCommentsByArticleId(Article article) async {
    Database _db = await getDB();
    final List<Map<String, dynamic>> results = await _db.query(
      'Commentaire',
      where: 'Art_id = ?',
      whereArgs: [article.id],
    );

    return results.map((map) => Commentaire.FromDB(map)).toList();
  }

  Future<List<SousCommentaire>> getSubCommentsByCommentId(
      Commentaire commentaire) async {
    Database _db = await getDB();
    final List<Map<String, dynamic>> results = await _db.query(
      'SousCommentaire',
      where: 'Com_id = ?',
      whereArgs: [commentaire.id],
    );

    return results.map((map) => SousCommentaire.FromDB(map)).toList();
  }

  Future<int> ChangeStorieFavorite(Article article) async {
    Database _db = await getDB();
    return await _db.update(
      'Article',
      {
        'favoris': article.favoris == 0 ? 1 : 0
      }, // 1 pour true, 0 pour false (voir explication précédente)
      where: 'id = ?',
      whereArgs: [article.id],
    );
  }

  Future<int> insertCommentaire(Commentaire commentaire) async {
    Database _db = await getDB();
    return await _db.insert("Commentaire", commentaire.toJson());
  }

  Future<int> insertSousCommentaire(SousCommentaire sousCommentaire) async {
    Database _db = await getDB();
    return await _db.insert("SousCommentaire", sousCommentaire.toJson());
  }

  Future<int> updateCommentaire(Commentaire commentaire) async {
    Database _db = await getDB();
    return await _db.update(
      "Commentaire",
      commentaire.toJson(),
      where: 'id = ?',
      whereArgs: [commentaire.id],
    );
  }

  Future<int> updateSousCommentaire(SousCommentaire sousCommentaire) async {
    Database _db = await getDB();
    return await _db.update(
      "Commentaire",
      sousCommentaire.toJson(),
      where: 'id = ?',
      whereArgs: [sousCommentaire.id],
    );
  }

  Future<List<Article>> getNonFavoriteArticles() async {
    Database _db = await getDB();
    var results = await _db.query(
      'Article',
      where: 'favoris = ?',
      whereArgs: [0], // Articles non favoris
    );

    return results.map((map) => Article.FromDB(map)).toList();
  }
}
