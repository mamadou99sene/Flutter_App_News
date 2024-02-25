import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:news/Models/Article.dart';
import 'package:news/Models/Commentaire.dart';
import 'package:news/Networking/HackerNewsAPI.dart';

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
                  children: [
                    Container(
                      height: 100,
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width * 0.05,
                          left: MediaQuery.of(context).size.width * 0.01,
                          right: MediaQuery.of(context).size.width * 0.01),
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.05),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage("images/logo.jpg"),
                        ),
                        title: Text(
                          currentArticle.author,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          currentArticle.title,
                          style: TextStyle(color: Colors.black),
                        ),
                        selectedColor: Colors.grey,
                        trailing: CircleAvatar(
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
                    ),
                    Text("${listComment!.length} commentaires"),
                    Expanded(
                      child: ListView.builder(
                          itemCount:
                              (listComment == null ? 0 : listComment.length),
                          itemBuilder: (context, index) {
                            return Container(
                                margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.width *
                                        0.02,
                                    left: MediaQuery.of(context).size.width *
                                        0.01,
                                    right: MediaQuery.of(context).size.width *
                                        0.01),
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width * 0.05),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.grey),
                                child: ListTile(
                                  leading: CircleAvatar(
                                      backgroundImage:
                                          AssetImage("images/logo.jpg")),
                                  title: Text(listComment[index].author),
                                  subtitle: Text(listComment[index].text),
                                  trailing: Text(
                                    "${listComment![index].time.day}-${listComment![index].time.month}-${listComment![index].time.year} ${listComment![index].time.hour} ${listComment![index].time.minute}",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ));
                          }),
                    )
                  ],
                );
              }
            })));
  }
}
