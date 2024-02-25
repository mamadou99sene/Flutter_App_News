import 'dart:io';
import 'package:news/Models/Article.dart';
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
    String request1 =
        "create table Users(id varchar(254) not null, created datetime, karma int, about varchar(254), primary key (id));";
    String request2 =
        "create table Article( id int not null, Use_id varchar(254) not null, score int, time datetime, title varchar(254), type varchar(254), favoris bool, primary key (id));";
    String request3 =
        "create table Commentaire( id int not null, Art_id int not null, Use_id varchar(254) not null, text varchar(254), time datetime, primary key (id));";
    String request4 =
        "create table SousCommentaire( id int not null, Com_id int not null, Use_id varchar(254) not null, text varchar(254), time datetime, primary key (id));";
    String foreign_request =
        "alter table Article add constraint FK_submitted foreign key (Use_id) references Users (id) on delete restrict on update restrict; alter table Commentaire add constraint FK_effectuer foreign key (Use_id)  references Users (id) on delete restrict on update restrict; alter table Commentaire add constraint FK_kids foreign key (Art_id) references Article (id) on delete restrict on update restrict; alter table SousCommentaire add constraint FK_kids foreign key (Com_id) references Commentaire (id) on delete restrict on update restrict; alter table SousCommentaire add constraint FK_submitted foreign key (Use_id)  references Users (id) on delete restrict on update restrict;";

    await db.execute(request1);
    await db.execute(request2);
    await db.execute(request3);
    await db.execute(request4);
    await db.execute(foreign_request);
  }

  Future<int> insertStories(Article article) async {
    //flushbar
    return await _db.insert("Article", article.toJson());
  }

  Future<List<Map<String, Object?>>> getAllStories() async {
    var results = await _db.query("Article");
    return results;
  }

  Future<int> getStorieById(Article article) async {
    return await _db.update("Article", article.toJson());
  }

  Future<int> deleteStorie(Article article) async {
    return _db.delete("Article", where: 'id = ?', whereArgs: [article.id]);
  }
}
