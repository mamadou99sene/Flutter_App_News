import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news/Models/Commentaire.dart';

class ShowSousComment extends StatelessWidget {
  late Commentaire currentCommentaire;
  ShowSousComment({required this.currentCommentaire});

  @override
  Widget build(BuildContext context) {
    print(currentCommentaire.text);
    return Scaffold();
  }
}
