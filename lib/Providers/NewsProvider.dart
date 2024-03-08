import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:news/Database/DatabaseHelper.dart';

import '../Models/Article.dart';

class NewsProvider extends ChangeNotifier {
  late Color color = Colors.yellow;
  late int CurrentStorie = -1;
  late Article currentArticle;
  late List<Article> selectedStories = [];
  late bool lenSelectedSubOne = false;

  void changeColor() {
    this.color = this.color;
    notifyListeners();
  }

  void markFavoriteStorie() {
    DatabaseHelper _db = GetIt.instance<DatabaseHelper>();
    _db.ChangeStorieFavorite(currentArticle);
    this.color = this.color;

    notifyListeners();
  }

  void notifierLenghtSelectedStorie() {
    if (selectedStories.length > 1) {
      this.lenSelectedSubOne = true;
      print("la taile des articles selectionné  bon ${lenSelectedSubOne}");
      notifyListeners();
    }
  }
}
