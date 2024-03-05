import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'package:news/Database/DatabaseHelper.dart';
import 'package:news/Models/Article.dart';
import 'package:news/Networking/HackerNewsAPI.dart';
import 'package:news/Widgets/ShowComment.dart';
import 'package:share_plus/share_plus.dart';

class Home extends StatelessWidget {
  //final DatabaseHelper _databaseHelper = GetIt.instance<DatabaseHelper>();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    _databaseHelper.getDB();
    return Material(
        child: FutureBuilder(
            future: HackerNewsAPI().getAllStories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SpinKitCircle(
                  color: Colors.black,
                );
              } else {
                List<Article>? listStories = snapshot.data;
                if (listStories != null) {
                  try {
                    for (Article article in listStories) {
                      // _databaseHelper.insertStories(article);
                    }
                  } catch (e) {
                    print("Impossible d'inserer cet article");
                    //print(e);
                  }
                }
                return Container(
                  decoration: BoxDecoration(
                      // gradient: LinearGradient(colors: Colors.primaries)
                      ),
                  child: ListView.builder(
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
                            Column(
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
                                                  builder: (context) =>
                                                      ShowComment(
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
                                  color: Colors.black,
                                  thickness: 1,
                                )
                              ],
                            )
                          ],
                        );
                      }),
                );
              }
            }));
  }
}
