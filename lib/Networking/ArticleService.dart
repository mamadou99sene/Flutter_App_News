import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:news/Database/DatabaseHelper.dart';
import 'package:news/Models/Article.dart';
import 'package:news/Networking/HackerNewsAPI.dart';

import '../Models/Commentaire.dart';
import '../Models/SousCommentaire.dart';

class ArticleService {
  final DatabaseHelper _databaseHelper = GetIt.instance<DatabaseHelper>();

  Future<void> cleanupNonFavoriteArticles() async {
    List<Article> nonFavoriteArticles =
        await _databaseHelper.getNonFavoriteArticles();
    print("nombre de non favoris ${nonFavoriteArticles.length}");
    for (Article article in nonFavoriteArticles) {
      bool isArticleAvailable = await checkArticleAvailability(article);
      if (!isArticleAvailable) {
        int deleted = await _databaseHelper.deleteArticle(article);
        print("suppression de l'article num ${article.favoris}: $deleted");
      } else {
        print("Article touvee");
      }
    }
  }

  Future<bool> checkArticleAvailability(Article article) async {
    try {
      http.Response response = await http.get(Uri.parse(
          "https://hacker-news.firebaseio.com/v0/item/${article.id}.json?print=pretty"));
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      // En cas d'erreur, considérons que l'article n'est pas disponible
      return false;
    }
    return false;
  }

  // Méthode pour planifier la routine de nettoyage
  void startCleanupRoutine() {
    const Duration cleanupInterval =
        Duration(hours: 2); // Par exemple, nettoyer toutes les semaines

    Timer.periodic(cleanupInterval, (Timer timer) async {
      await cleanupNonFavoriteArticles();
      print('Routine de nettoyage exécutée.');
    });
  }

  Future<List<Article>> onLoadStories({bool forceToAPI = false}) async {
    List<Article> localArticles = await _databaseHelper.getAllStories();
    if (forceToAPI || localArticles.isEmpty) {
      List<Article> apiArticles = await HackerNewsAPI().getAllStories();
      for (Article article in apiArticles) {
        try {
          await _databaseHelper.insertStories(article);
          print("insertion de nouveau article");
        } catch (e) {
          await _databaseHelper.UpdateStorie(article);
          print("modification de l'article num ${article.id}");
        }
      }
      return apiArticles;
    }
    return localArticles;
  }

  void startPeriodicStoriesRecover() {
    const Duration period =
        const Duration(minutes: 5); // Intervalles de 5 minutes
    Timer.periodic(period, (Timer timer) async {
      await onLoadStories(forceToAPI: true);
      print('Recuperation périodique des aricles lancée');
    });
  }

  Future<List<Commentaire>> onLoadCommentaires(Article article) async {
    List<Commentaire> localCommentaires =
        await _databaseHelper.getCommentsByArticleId(article);

    if (localCommentaires.isEmpty) {
      List<Commentaire> apiCommentaires =
          await HackerNewsAPI().getCommentsBeforeRecoverIds(article.id);
      print("recuperation depuis l'API");

      /*for (Commentaire commentaire in apiCommentaires) {
        try {
          await _databaseHelper.insertCommentaire(commentaire);
          print("Insertion de nouveau de commentaire");
        } catch (e) {
          await _databaseHelper.updateCommentaire(commentaire);
        }
      }*/

      return apiCommentaires;
    }
    return localCommentaires;
  }

  Future<List<SousCommentaire>> onLoadSousCommentaires(
      Commentaire commentaire) async {
    List<SousCommentaire> localSousCommentaires =
        await _databaseHelper.getSubCommentsByCommentId(commentaire);

    if (localSousCommentaires.isNotEmpty) {
      return localSousCommentaires;
    } else {
      List<SousCommentaire> apiSousCommentaires =
          await HackerNewsAPI().getSousCommentaires(commentaire.id);

      /*for (SousCommentaire sousCommentaire in apiSousCommentaires) {
        try {
          await _databaseHelper.insertSousCommentaire(sousCommentaire);
          print("Insertion de nouveau de sous commentaire");
        } catch (e) {
          await _databaseHelper.updateSousCommentaire(sousCommentaire);
        }
      }*/

      return apiSousCommentaires;
    }
  }
}
