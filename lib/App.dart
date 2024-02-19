import 'package:flutter/material.dart';
import 'package:news/Screens/Home.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Home(),
    );
  }
}
