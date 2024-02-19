import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:news/Database/DatabaseHelper.dart';
import 'package:news/Models/Etudiant.dart';
import 'package:news/Networking/HackerNewsAPI.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: FutureBuilder(
            future: HackerNewsAPI().getTopStories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SpinKitWave(
                  color: Colors.green,
                );
              } else {
                return Text(snapshot.data.toString());
              }
            }));
  }
}
