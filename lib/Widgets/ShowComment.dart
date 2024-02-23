import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:news/Networking/HackerNewsAPI.dart';

class ShowComment extends StatelessWidget {
  late int idArticle;
  ShowComment({required this.idArticle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: FutureBuilder(
            future: HackerNewsAPI().getIdsCommentaireByArticle(this.idArticle),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SpinKitPianoWave(
                  color: Colors.green,
                  size: 50,
                );
              } else {
                List<int>? list = snapshot.data;
                return Text(list![0].toString());
              }
            })));
  }
}
