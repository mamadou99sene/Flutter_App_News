import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'package:news/Models/Commentaire.dart';
import 'package:news/Models/SousCommentaire.dart';
import 'package:news/Networking/ArticleService.dart';
import 'package:news/Networking/HackerNewsAPI.dart';
import 'package:share_plus/share_plus.dart';

import '../Database/DatabaseHelper.dart';

class ShowSousComment extends StatelessWidget {
  late Commentaire currentCommentaire;
  ShowSousComment({required this.currentCommentaire});
  final DatabaseHelper _databaseHelper = GetIt.instance<DatabaseHelper>();
  @override
  Widget build(BuildContext context) {
    _databaseHelper.getDB();
    return Scaffold(
      appBar: AppBar(
        title: Text("Reponse à ${currentCommentaire.author}"),
        centerTitle: true,
        elevation: 10,
      ),
      body: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 35,
              backgroundImage: AssetImage("images/logo.png"),
            ),
            title: Text(
              currentCommentaire.author,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              "${currentCommentaire.time.day}-${currentCommentaire.time.month}-${currentCommentaire.time.year} ${currentCommentaire.time.hour} ${currentCommentaire.time.minute}",
            ),
            trailing: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.black,
                  )),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.width * 0.01,
                left: MediaQuery.of(context).size.width * 0.01,
                right: MediaQuery.of(context).size.width * 0.01),
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey[200]),
            child: Text(
              currentCommentaire.text,
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.favorite_outline,
                    color: Colors.black,
                  )),
              IconButton(
                  onPressed: () {
                    Share.share("Partger cet article");
                  },
                  icon: Icon(
                    Icons.share,
                  )),
              Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.comment_outlined,
                      )),
                ],
              ),
            ],
          ),
          FutureBuilder(
              future:
                  ArticleService().onLoadSousCommentaires(currentCommentaire),
              //HackerNewsAPI().getSousCommentaires(currentCommentaire.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SpinKitCircle(
                    color: Colors.black,
                  );
                } else {
                  List<SousCommentaire>? lisSouCommentaire = snapshot.data;
                  if (lisSouCommentaire != null) {
                    for (SousCommentaire subComment in lisSouCommentaire) {
                      try {
                        subComment.commentaire = currentCommentaire;
                        _databaseHelper.insertSousCommentaire(subComment);
                      } catch (e) {
                        _databaseHelper.updateSousCommentaire(subComment);
                        print("Impossible d'inserer ce  sous commentaire");
                      }
                    }
                  }
                  return Expanded(
                    child: ListView.builder(
                        itemCount: (lisSouCommentaire == null
                            ? 0
                            : lisSouCommentaire.length),
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.05,
                            ),
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.05),
                            child: ListTile(
                              leading: CircleAvatar(
                                  radius: 20,
                                  backgroundImage:
                                      AssetImage("images/logo.png")),
                              subtitle: Column(
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.02,
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.01,
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.01),
                                      padding: EdgeInsets.all(
                                          MediaQuery.of(context).size.width *
                                              0.05),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.grey[200]),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                lisSouCommentaire![index]
                                                    .author,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            lisSouCommentaire[index].text,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14),
                                          ),
                                        ],
                                      )),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${lisSouCommentaire![index].time.day}-${lisSouCommentaire![index].time.month}-${lisSouCommentaire![index].time.year} ${lisSouCommentaire![index].time.hour} ${lisSouCommentaire![index].time.minute}",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.favorite_outline,
                                            color: Colors.black,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  );
                }
              }),
        ],
      ),
    );
  }
}
