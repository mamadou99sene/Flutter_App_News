import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:news/Database/DatabaseHelper.dart';
import 'package:news/Models/Article.dart';

class ArticleService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> cleanupNonFavoriteArticles() async {
    List<Article> nonFavoriteArticles =
        await _databaseHelper.getNonFavoriteArticles();
    print("nombre de non favoris ${nonFavoriteArticles.length}");
    for (Article article in nonFavoriteArticles) {
      bool isArticleAvailable = await checkArticleAvailability(article);
      if (!isArticleAvailable) {
        int deleted = await _databaseHelper.deleteStorie(article);
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
}
