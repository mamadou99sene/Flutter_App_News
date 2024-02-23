import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:news/Database/DatabaseHelper.dart';
import 'package:news/Models/Article.dart';
import 'package:news/Networking/HackerNewsAPI.dart';
import 'package:news/Widgets/ShowComment.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: FutureBuilder(
            future: HackerNewsAPI().getAllStories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SpinKitWave(
                  color: Colors.green,
                );
              } else {
                List<Article>? listStories = snapshot.data;
                return Container(
                  decoration: BoxDecoration(
                      // gradient: LinearGradient(colors: Colors.primaries)
                      ),
                  child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.linked_camera,
                                      color: Colors.green,
                                    )),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.share,
                                      color: Colors.green,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      print(index);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ShowComment(
                                                  idArticle:
                                                      listStories![index].id)));
                                    },
                                    icon: Icon(
                                      Icons.comment,
                                      color: Colors.green,
                                    )),
                              ],
                            ),
                            Divider(
                              color: Colors.green,
                              thickness: 1,
                            )
                          ],
                        );
                      },
                      itemCount: (listStories == null ? 0 : listStories.length),
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                              radius: 40,
                              backgroundImage: AssetImage("images/logo.jpg"),
                              backgroundColor: Colors.green),
                          title: Text(
                            listStories![index].author,
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            listStories[index].title,
                            style: TextStyle(color: Colors.black),
                          ),
                          selectedColor: Colors.grey,
                          trailing: CircleAvatar(
                              backgroundColor: Colors.green,
                              child: Text(listStories[index].score.toString())),
                        );
                      }),
                );
              }
            }));
  }
}
