import 'package:flutter/material.dart';
import 'package:news/App.dart';
import 'package:get_it/get_it.dart';
import 'package:news/Database/DatabaseHelper.dart';
import 'package:news/Networking/ArticleService.dart';

void main() {
  GetIt.instance.registerLazySingleton<DatabaseHelper>(
    () => new DatabaseHelper(),
  );
  ArticleService service = ArticleService();
  service.startCleanupRoutine();
  service.startPeriodicStoriesRecover();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: App(),
  ));
}
