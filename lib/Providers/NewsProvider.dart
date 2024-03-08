import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NewsProvider extends ChangeNotifier {
  late Color color;
  late int CurrentStorie = -1;

  void changeColor() {
    this.color = Colors.yellow;
    notifyListeners();
  }
}
