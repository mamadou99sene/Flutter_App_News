import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:news/Models/Article.dart';
import 'package:news/Models/Commentaire.dart';
import 'package:news/Models/SousCommentaire.dart';
import 'package:news/Networking/HackerNewsAPI.dart';
import 'package:news/Widgets/ShowSousComment.dart';
import 'package:share_plus/share_plus.dart';

class ShowComment extends StatelessWidget {
  late Article currentArticle;
  ShowComment({required this.currentArticle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: FutureBuilder(
            future: HackerNewsAPI()
                .getCommentsBeforeRecoverIds(this.currentArticle.id),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SpinKitPianoWave(
                  color: Colors.green,
                  size: 50,
                );
              } else {
                List<Commentaire>? listComment = snapshot.data;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        radius: 35,
                        backgroundImage: AssetImage("images/logo.png"),
                      ),
                      title: Text(
                        currentArticle.author,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
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
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.05),
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
                            Text("${listComment!.length}")
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
                    Expanded(
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
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${listComment![index].time.day}-${listComment![index].time.month}-${listComment![index].time.year} ${listComment![index].time.hour} ${listComment![index].time.minute}",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      Row(
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
                                                                    listComment[
                                                                        index])));
                                              },
                                              child: Text(
                                                "Voir Reponses:",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              )),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                    )
                  ],
                );
              }
            })));
  }
}
