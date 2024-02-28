import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:news/Database/DatabaseHelper.dart';
import 'package:news/Models/Article.dart';
import 'package:news/Networking/HackerNewsAPI.dart';
import 'package:news/Widgets/ShowComment.dart';
import 'package:share_plus/share_plus.dart';

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
                            SizedBox(
                              height: 10,
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
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ShowComment(
                                                    currentArticle:
                                                        listStories![index],
                                                  )));
                                    },
                                    icon: Icon(
                                      Icons.comment_outlined,
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
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                  radius: 35,
                                  backgroundImage:
                                      AssetImage("images/logo.png"),
                                  backgroundColor: Colors.green),
                              title: Text(
                                listStories![index].author,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                  "${listStories![index].time.day}-${listStories![index].time.month}-${listStories![index].time.year} ${listStories![index].time.hour} ${listStories![index].time.minute}"),
                              selectedColor: Colors.grey,
                              trailing: CircleAvatar(
                                  backgroundColor: Colors.black,
                                  child: Text(
                                    listStories[index].score.toString(),
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.width * 0.01,
                                  left:
                                      MediaQuery.of(context).size.width * 0.01,
                                  right:
                                      MediaQuery.of(context).size.width * 0.01),
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width * 0.05),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.grey[200]),
                              child: Text(
                                listStories[index].title,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                              ),
                            ),
                          ],
                        );
                      }),
                );
              }
            }));
  }
}
