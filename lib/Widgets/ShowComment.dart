import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'package:news/Models/Article.dart';
import 'package:news/Models/Commentaire.dart';
import 'package:news/Models/SousCommentaire.dart';
import 'package:news/Networking/ArticleService.dart';
import 'package:news/Networking/HackerNewsAPI.dart';
import 'package:news/Widgets/ShowSousComment.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../Database/DatabaseHelper.dart';
import '../Providers/NewsProvider.dart';

class ShowComment extends StatelessWidget {
  late Article currentArticle;
  final DatabaseHelper _databaseHelper = GetIt.instance<DatabaseHelper>();
  ShowComment({required this.currentArticle});

  @override
  Widget build(BuildContext context) {
    _databaseHelper.getDB();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Publication de ${currentArticle.author}",
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
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
                currentArticle.author,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                "${currentArticle.time.day}-${currentArticle.time.month}-${currentArticle.time.year} ${currentArticle.time.hour} ${currentArticle.time.minute}",
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
                currentArticle.title,
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      _databaseHelper.ChangeStorieFavorite(currentArticle);
                    },
                    icon: (currentArticle.favoris == 0
                        ? Icon(
                            Icons.favorite_outline,
                            color: Colors.black,
                          )
                        : Icon(
                            Icons.favorite,
                            color: Colors.yellow,
                          ))),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  child: Text(
                    "Commentaires",
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            FutureBuilder(
                future: ArticleService().onLoadCommentaires(currentArticle),
                //HackerNewsAPI()
                //.getCommentsBeforeRecoverIds(this.currentArticle.id),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SpinKitCircle(
                      color: Colors.black,
                    );
                  } else {
                    List<Commentaire>? listComment = snapshot.data;
                    if (listComment != null) {
                      for (Commentaire comment in listComment) {
                        try {
                          comment.article = currentArticle;
                          _databaseHelper.insertCommentaire(comment);
                        } catch (e) {
                          _databaseHelper.updateCommentaire(comment);
                          print("Impossible d'inserer ce commentaire");
                        }
                      }
                    }
                    return Expanded(
                      child: ListView.builder(
                          itemCount:
                              (listComment == null ? 0 : listComment.length),
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: CircleAvatar(
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
                                                listComment![index].author,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            listComment[index].text,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14),
                                          ),
                                        ],
                                      )),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${listComment![index].time.day}-${listComment![index].time.month}-${listComment![index].time.year} ${listComment![index].time.hour} ${listComment![index].time.minute}",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.favorite_outline,
                                                color: Colors.black,
                                              )),
                                        ],
                                      ),
                                      //afficher la derniere reponse avec juste
                                      FutureBuilder(
                                          future: ArticleService()
                                              .onLoadSousCommentaires(
                                                  listComment[index]),
                                          //HackerNewsAPI()
                                          //.getSousCommentaires(
                                          //   listComment[index].id),
                                          builder: (context, snapchot1) {
                                            if (snapchot1.connectionState ==
                                                ConnectionState.waiting) {
                                              return SpinKitCircle(
                                                color: Colors.black,
                                              );
                                            } else {
                                              List<SousCommentaire>?
                                                  oneSousComment =
                                                  snapchot1.data;
                                              if (oneSousComment!.length == 0) {
                                              } else {
                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      ShowSousComment(
                                                                          currentCommentaire:
                                                                              listComment[index])));
                                                        },
                                                        child: Text(
                                                          "Voir les ${oneSousComment.length} Reponses",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14),
                                                        )),
                                                  ],
                                                );
                                              }
                                              return Text("");
                                              /*return ListTile(
                                                  title: (oneSousComment?[
                                                              index] ==
                                                          null
                                                      ? Container()
                                                      : Text(
                                                          "${oneSousComment?[oneSousComment.length - 1].author}")));*/
                                            }
                                          })
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                    );
                  }
                })),
          ],
        ));
  }
}
