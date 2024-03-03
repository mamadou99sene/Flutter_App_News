import 'package:flutter/material.dart';
import 'package:news/App.dart';
import 'package:get_it/get_it.dart';
import 'package:news/Database/DatabaseHelper.dart';

void main() {
  GetIt.instance.registerLazySingleton<DatabaseHelper>(
    () => new DatabaseHelper(),
  );
  runApp(MaterialApp(
    home: App(),
  ));
}
