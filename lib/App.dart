import 'package:flutter/material.dart';
import 'package:news/Providers/NewsProvider.dart';
import 'package:news/Screens/Home.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: ChangeNotifierProvider(
        create: (context) => NewsProvider(),
        child: Scaffold(
          appBar: AppBar(
            actions: [
              Consumer<NewsProvider>(builder: (context, value, child) {
                if (!value.lenSelectedSubOne) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.restore_from_trash_outlined),
                        color: Colors.white,
                      ),
                      Text(
                        "${value.selectedStories.length}",
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 20),
                      )
                    ],
                  );
                } else {
                  print("variable bool ${value.lenSelectedSubOne}");
                }
                return Container();
              })
            ],
          ),
          body: Home(),
        ),
      ),
    );
  }
}
